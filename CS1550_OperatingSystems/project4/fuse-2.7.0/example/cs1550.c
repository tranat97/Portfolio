/*
	FUSE: Filesystem in Userspace
	Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>

	This program can be distributed under the terms of the GNU GPL.
	See the file COPYING.
*/

#define	FUSE_USE_VERSION 26

#include <fuse.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

//size of a disk block
#define	BLOCK_SIZE 512

//size of disk
#define DISK_SIZE (5*1024*1024)
//offset for the beginning of the bit map
#define BITMAP DISK_SIZE-(3*BLOCK_SIZE)

//we'll use 8.3 filenames
#define	MAX_FILENAME 8
#define	MAX_EXTENSION 3

//How many files can there be in one directory?
#define MAX_FILES_IN_DIR (BLOCK_SIZE - sizeof(int)) / ((MAX_FILENAME + 1) + (MAX_EXTENSION + 1) + sizeof(size_t) + sizeof(long))

//global pointers to the .disk File and root directory
FILE *disk;
struct cs1550_root_directory *root; 

//helper functions
static int findFree(int, long *);
static int setBit(int, long *);
static long min(long, long);

//The attribute packed means to not align these things
struct cs1550_directory_entry
{
	int nFiles;	//How many files are in this directory.
				//Needs to be less than MAX_FILES_IN_DIR

	struct cs1550_file_directory
	{
		char fname[MAX_FILENAME + 1];	//filename (plus space for nul)
		char fext[MAX_EXTENSION + 1];	//extension (plus space for nul)
		size_t fsize;					//file size
		long nIndexBlock;				//where the index block is on disk
	} __attribute__((packed)) files[MAX_FILES_IN_DIR];	//There is an array of these

	//This is some space to get this to be exactly the size of the disk block.
	//Don't use it for anything.
	char padding[BLOCK_SIZE - MAX_FILES_IN_DIR * sizeof(struct cs1550_file_directory) - sizeof(int)];
} ;

typedef struct cs1550_root_directory cs1550_root_directory;

#define MAX_DIRS_IN_ROOT (BLOCK_SIZE - sizeof(int)) / ((MAX_FILENAME + 1) + sizeof(long))

struct cs1550_root_directory
{
	int nDirectories;	//How many subdirectories are in the root
						//Needs to be less than MAX_DIRS_IN_ROOT
	struct cs1550_directory
	{
		char dname[MAX_FILENAME + 1];	//directory name (plus space for nul)
		long nStartBlock;				//where the directory block is on disk
	} __attribute__((packed)) directories[MAX_DIRS_IN_ROOT];	//There is an array of these

	//This is some space to get this to be exactly the size of the disk block.
	//Don't use it for anything.
	char padding[BLOCK_SIZE - MAX_DIRS_IN_ROOT * sizeof(struct cs1550_directory) - sizeof(int)];
} ;


typedef struct cs1550_directory_entry cs1550_directory_entry;

//How many entries can one index block hold?
#define	MAX_ENTRIES_IN_INDEX_BLOCK (BLOCK_SIZE/sizeof(long))

struct cs1550_index_block
{
      //All the space in the index block can be used for index entries.
			// Each index entry is a data block number.
      long entries[MAX_ENTRIES_IN_INDEX_BLOCK];
};

typedef struct cs1550_index_block cs1550_index_block;

//How much data can one block hold?
#define	MAX_DATA_IN_BLOCK (BLOCK_SIZE)

struct cs1550_disk_block
{
	//All of the space in the block can be used for actual data
	//storage.
	char data[MAX_DATA_IN_BLOCK];
};

typedef struct cs1550_disk_block cs1550_disk_block;

/*
 * Called whenever the system wants to know the file attributes, including
 * simply whether the file exists or not.
 *
 * man -s 2 stat will show the fields of a stat structure
 */
static int cs1550_getattr(const char *path, struct stat *stbuf)
{
	int res = -ENOENT;

	memset(stbuf, 0, sizeof(struct stat));
	char directory[MAX_FILENAME+1];
	char filename[MAX_FILENAME+1];
	char extension[MAX_EXTENSION+1];
	int x = sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension);
	// printf("%i dir %s/%s.%s\n", x, directory, filename, extension);

	//is path the root dir?
	if (strcmp(path, "/") == 0) {
		stbuf->st_mode = S_IFDIR | 0755;
		stbuf->st_nlink = 2;
		res = 0;
	} else if (x>0) { 
		int i;
		//Check for directory
		for (i=0; i<root->nDirectories; i++) {
			if(strcmp(directory, root->directories[i].dname+1)==0) {
				stbuf->st_mode = S_IFDIR | 0755;
				stbuf->st_nlink = 2;
				res = 0; //no error
				break;
			}
		}
		if(x==2) {
			return -EISDIR;
		}
		if (x==3) {
			res = -ENOENT;
			struct cs1550_directory_entry *dir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
			long blockStart = root->directories[i].nStartBlock; //save the start of the directory block
			fseek(disk, blockStart*BLOCK_SIZE, SEEK_SET);
			fread(dir, sizeof(struct cs1550_directory_entry), 1, disk);
			// printf("%i\n", dir->nFiles);
			for (i=0; i<dir->nFiles; i++) {
				if(strcmp(filename, dir->files[i].fname)==0 && strcmp(extension, dir->files[i].fext)==0) {
					stbuf->st_mode = S_IFREG | 0666;
					stbuf->st_nlink = 1; //file links
					stbuf->st_size = dir->files[i].fsize; //file size
					res = 0; // no error
					break;
				}
			}
			free(dir);
		} 
	} else {
		//Else return that path doesn't exist
		res = -ENOENT;
	}
	return res;
}

/*
 * Called whenever the contents of a directory are desired. Could be from an 'ls'
 * or could even be when a user hits TAB to do autocompletion
 */
static int cs1550_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
			 off_t offset, struct fuse_file_info *fi)
{
	//Since we're building with -Wall (all warnings reported) we need
	//to "use" every parameter, so let's just cast them to void to
	//satisfy the compiler
	(void) offset;
	(void) fi;
	char directory[MAX_FILENAME+1];
	int i;
	long blockStart;

	//the filler function allows us to add entries to the listing
	//read the fuse.h file for a description (in the ../include dir)
	filler(buf, ".", NULL, 0);
	filler(buf, "..", NULL, 0);

	if (strcmp(path, "/") == 0) {
		for (i=0; i<root->nDirectories; i++) {
			filler(buf, root->directories[i].dname+1, NULL, 0);
		}
		return 0;
	}

	/*
	//add the user stuff (subdirs or files)
	//the +1 skips the leading '/' on the filenames
	filler(buf, newpath + 1, NULL, 0);
	*/
	
	if(sscanf(path, "/%[^/]/", directory)==1) {
		for (i=0; i<root->nDirectories; i++) {
			if(strcmp(root->directories[i].dname+1, directory)==0) {
				struct cs1550_directory_entry *dir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
				blockStart = root->directories[i].nStartBlock; //save the start of the directory block
				// printf("block start: %i\n", blockStart);
				fseek(disk, blockStart*BLOCK_SIZE, SEEK_SET);
				fread(dir, sizeof(struct cs1550_directory_entry), 1, disk);
				for (i=0; i<dir->nFiles; i++) {
					// printf("Filename: %s%s\n", dir->files[i].fname, dir->files[i].fext);
					char filename[MAX_FILENAME+1];
					strncpy(filename, dir->files[i].fname, MAX_FILENAME);
					strncat(filename, ".", 2);
					strncat(filename, dir->files[i].fext, MAX_EXTENSION);
					filler(buf, filename, NULL, 0);
				}
				free(dir);
				return 0;
			}
		}
	}

	//File not found
	// printf("Directory not found\n");
	return -ENOENT;
}

/*
 * Creates a directory. We can ignore mode since we're not dealing with
 * permissions, as long as getattr returns appropriate ones for us.
 */
static int cs1550_mkdir(const char *path, mode_t mode)
{
	// (void) path;
	(void) mode;
	long freeBlocks[1];
	int i;
	char directory[MAX_FILENAME+1];
	char filename[MAX_FILENAME+1];
	char extension[MAX_EXTENSION+1];
	
	if(sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension)>1) {
		return -EPERM;
	}

	//Check length of directory name
	if(strlen(directory)>MAX_FILENAME) {
		// printf("Error: Max length of filename: %i\n", MAX_FILENAME);
		return -ENAMETOOLONG;
	}

	for(i=0; i<root->nDirectories; i++) {
		if(strcmp(root->directories[i].dname, path)==0) {
			// printf("Error: Directory %s already exists\n", path);
			return -EEXIST;
		}
	}

	if(root->nDirectories>=MAX_DIRS_IN_ROOT) {
		return -ENOSPC;
	}

	//Check bit map for free block 
	if (findFree(1, freeBlocks)==1) {
		// printf("First Free Block: %i\n", freeBlocks[0]);
		//init new directory entry
		struct cs1550_directory_entry *newDir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
		newDir->nFiles=0;

		int x = root->nDirectories; //index of new directory in root
		strncpy(root->directories[x].dname, path, MAX_FILENAME);
		root->directories[x].nStartBlock = freeBlocks[0];
		
		//write directory to file
		fseek(disk, freeBlocks[0]*BLOCK_SIZE, SEEK_SET);
		fwrite(newDir, sizeof(struct cs1550_directory_entry), 1, disk);
		setBit(1, freeBlocks); //set the bit in the bit map
		
		//update root directory
		root->nDirectories++; //increment the number of directories
		// printf("nDirectories: %i/%i\n", root->nDirectories, MAX_DIRS_IN_ROOT);
		fseek(disk, 0, SEEK_SET);
		fwrite(root, sizeof(struct cs1550_root_directory), 1, disk);

		free(newDir);
	}
	return 0;
}

/*
 * Removes a directory.
 */
static int cs1550_rmdir(const char *path)
{
	(void) path;
    return 0;
}

/*
 * Does the actual creation of a file. Mode and dev can be ignored.
 *
 */
static int cs1550_mknod(const char *path, mode_t mode, dev_t dev)
{
	(void) mode;
	(void) dev;
	int i;
	long freeBlocks[2];
	
	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME];
	char extension[MAX_EXTENSION];
	//if all fields are not filled assume trying to add to root
	if (sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension)!=3) {
		return -EPERM;
	}
	// printf("/%s/%s.%s\n", directory, filename, extension);

	//Check length of directory name
	if(strlen(filename)>MAX_FILENAME || strlen(extension)>MAX_EXTENSION) {
		return -ENAMETOOLONG;
	}
	
	for (i=0; i<root->nDirectories; i++) {
		//search for the subdirectory in the root
		if (strcmp(directory, root->directories[i].dname+1)==0) {
			long directStart = root->directories[i].nStartBlock;
			struct cs1550_directory_entry *dir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
			fseek(disk, directStart*BLOCK_SIZE, SEEK_SET);
			fread(dir, sizeof(struct cs1550_directory_entry), 1, disk);
			//make sure there is enough space in the directory file
			if (dir->nFiles>=MAX_FILES_IN_DIR) {
				free(dir);
				return -ENOSPC;
			}
			//check if there is already a file with the name.ext inthis directory
			for (i=0; i<dir->nFiles; i++) {
				// printf("%s%s\n", dir->files[i].fname, dir->files[i].fext);
				if (strcmp(filename, dir->files[i].fname)==0 && 
					strcmp(extension, dir->files[i].fext)==0) {
						free(dir);
						return -EEXIST; //if so return error
				}
			}
			//initialize file directory
			int x = dir->nFiles; //index of next file in directory
			strncpy(dir->files[x].fname, filename, MAX_FILENAME);
			strncpy(dir->files[x].fext, extension, MAX_EXTENSION);
			dir->files[x].fsize = 0;
			// printf("init %s%s\n", dir->files[x].fname, dir->files[x].fext);
			//initialize index block
			struct cs1550_index_block *iblock = (struct cs1550_index_block *)malloc(sizeof(struct cs1550_index_block));
			//find a free block for the iblock and data block
			long iblockStart, dataStart;
			if (findFree(2, freeBlocks)==2) {
				iblockStart = freeBlocks[0];
				dataStart = freeBlocks[1];
			} else {
				//free stuff
				free(dir);
				free(iblock);
				return -ENOSPC;
			}

			//start writing to disk (update meta data after successful writes)
			//iblock
			iblock->entries[0] = dataStart;
			fseek(disk, iblockStart*BLOCK_SIZE, SEEK_SET);
			fwrite(iblock, sizeof(struct cs1550_index_block), 1, disk);
			//update directory
			dir->files[x].nIndexBlock = iblockStart;
			dir->nFiles++;
			fseek(disk, directStart*BLOCK_SIZE, SEEK_SET);
			fwrite(dir, sizeof(struct cs1550_directory_entry), 1, disk);

			//set bits in bit map
			setBit(2, freeBlocks);

			//free stuff
			free(dir);
			free(iblock);
			return 0;
		}
	}

	return -ENOENT;
}

/*
 * Deletes a file
 */
static int cs1550_unlink(const char *path)
{
    (void) path;

    return 0;
}

/*
 * Read size bytes from file into buf starting from offset
 *
 */
static int cs1550_read(const char *path, char *buf, size_t size, off_t offset,
			  struct fuse_file_info *fi)
{
	// (void) buf;
	// (void) offset;
	(void) fi;
	// (void) path;
	int i;
	size_t read = 0;

	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME+1];
	char extension[MAX_EXTENSION+1];


	if(sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension)==3) {
		//check to make sure path exists
		for (i=0; i<root->nDirectories; i++) {
			//search for the directory in root
			// printf("%s\n", root->directories[i].dname);
			if (strcmp(directory, root->directories[i].dname+1)==0) {
				//directory found
				long directStart = root->directories[i].nStartBlock;
				struct cs1550_directory_entry *dir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
				fseek(disk, directStart*BLOCK_SIZE, SEEK_SET);
				fread(dir, sizeof(struct cs1550_directory_entry), 1, disk);
				//check if there is a file with the name.ext in this directory
				for (i=0; i<dir->nFiles; i++) {
					if (strcmp(filename, dir->files[i].fname)==0 && 
						strcmp(extension, dir->files[i].fext)==0) {
						//file found! check that size is > 0
						if (size<=0) {
							free(dir);
							return 0;
						}
						//check offset
						if (offset>dir->files[i].fsize) {
							free(dir);
							return -EFBIG;
						}

						long iblockStart = dir->files[i].nIndexBlock;
						struct cs1550_index_block *iblock = (struct cs1550_index_block *)malloc(sizeof(struct cs1550_index_block));
						fseek(disk, iblockStart*BLOCK_SIZE, SEEK_SET);
						fread(iblock, sizeof(cs1550_index_block), 1, disk);

						//begin reading
						i=(int)offset/BLOCK_SIZE;
						long blockOffset = offset;
						while (read<size && i<dir->nFiles) {
							//number of bytes to read during this loop
							//read up to the end of the block or just what is needed (min of those 2)
							long nBytes = min((long)(MAX_DATA_IN_BLOCK-blockOffset), (long)(size-read));
							fseek(disk, iblock->entries[i++]*BLOCK_SIZE+blockOffset, SEEK_SET);
							fread(buf, 1, nBytes, disk);
							read+=nBytes;
							blockOffset = 0;
						}
						free(iblock);
						free(dir);
						return read;
					}
				}
			}
		}

	} else {
		return -EISDIR;
	}
	//set size (should be same as input) and return, or error

	return -ENOENT;
}

/*
 * Write size bytes from buf into file starting from offset
 *
 */
static int cs1550_write(const char *path, const char *buf, size_t size,
			  off_t offset, struct fuse_file_info *fi)
{
	// (void) buf;
	// (void) offset;
	(void) fi;
	// (void) path;
	int i;
	size_t written = 0;

	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME+1];
	char extension[MAX_EXTENSION+1];


	if(sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension)==3) {
		//check to make sure path exists
		for (i=0; i<root->nDirectories; i++) {
			//search for the directory in root
			if (strcmp(directory, root->directories[i].dname+1)==0) {
				//directory found
				long directStart = root->directories[i].nStartBlock;
				struct cs1550_directory_entry *dir = (struct cs1550_directory_entry *)malloc(sizeof(struct cs1550_directory_entry));
				fseek(disk, directStart*BLOCK_SIZE, SEEK_SET);
				fread(dir, sizeof(struct cs1550_directory_entry), 1, disk);
				//check if there is a file with the name.ext in this directory
				for (i=0; i<dir->nFiles; i++) {
					if (strcmp(filename, dir->files[i].fname)==0 && 
						strcmp(extension, dir->files[i].fext)==0) {
							size_t *fsize = &dir->files[i].fsize;
						//file found! check that size is > 0
						if (size<=0) {
							free(dir);
							return 0;
						}
						//check offset
						
						if (offset>(*fsize)) {
							free(dir);
							// printf("\t\t fsize = %i/%i\n", offset, (*fsize));
							return -EFBIG;
						}
						
						long iblockStart = dir->files[i].nIndexBlock;
						struct cs1550_index_block *iblock = (struct cs1550_index_block *)malloc(sizeof(struct cs1550_index_block));
						fseek(disk, iblockStart*BLOCK_SIZE, SEEK_SET);
						fread(iblock, sizeof(cs1550_index_block), 1, disk);
						
						//begin writing
						i=(int)offset/BLOCK_SIZE;
						long blockOffset = offset;
						while (written<size) {
							//number of bytes to write during this loop
							//fill the rest of the block up or write the rest of the buf that needs written (min of the 2)
							long nBytes = min((long)(MAX_DATA_IN_BLOCK-blockOffset), (long)(size-written));
							fseek(disk, iblock->entries[i++]*BLOCK_SIZE+blockOffset, SEEK_SET);
							fwrite(buf, 1, nBytes, disk);
							written+=nBytes;
							//if more needs to be written and the block is full make a new disk block
							if(written<size && i<MAX_ENTRIES_IN_INDEX_BLOCK && iblock->entries[i]==0) {
								long freeBlocks[1];
								if(findFree(1, freeBlocks)==1) {
									//update iblock
									iblock->entries[i]=freeBlocks[0];
									fseek(disk, iblockStart*BLOCK_SIZE, SEEK_SET);
									fwrite(iblock, sizeof(struct cs1550_index_block), 1, disk);

									setBit(1, freeBlocks);
								} 
							} else {
								free(dir);
								free(iblock);
								return written;
							}
							blockOffset = 0;
						}
						//update size in directory
						//check offset and update file size
						if (offset==dir->files[i].fsize) { //append mode
							(*fsize) = (*fsize)+written;
							// if (offset>0) {
							// 	(*fsize)--;
							// }
						} else {
							(*fsize) = written;
						}
						//write back to disk
						fseek(disk, directStart*BLOCK_SIZE, SEEK_SET);
						fwrite(dir, sizeof(struct cs1550_directory_entry), 1, disk);
						free(dir);
						free(iblock);
						// printf("written %i/%i\n", written, size);
						return written;

					}
				}
			}
		}

	} 
	return -ENOENT;
}

//helper min function
static long min(long left, long right)
{
	if(left>right)
		return right;
	return left;
}

/*
 * truncate is called when a new file is created (with a 0 size) or when an
 * existing file is made shorter. We're not handling deleting files or
 * truncating existing ones, so all we need to do here is to initialize
 * the appropriate directory entry.
 *
 */
static int cs1550_truncate(const char *path, off_t size)
{
	(void) path;
	(void) size;

    return 0;
}


/*
 * Called when we open a file
 *
 */
static int cs1550_open(const char *path, struct fuse_file_info *fi)
{
	(void) path;
	(void) fi;
    /*
        //if we can't find the desired file, return an error
        return -ENOENT;
    */

    //It's not really necessary for this project to anything in open

    /* We're not going to worry about permissions for this project, but
	   if we were and we don't have them to the file we should return an error

        return -EACCES;
    */

    return 0; //success!
}

/*
 * Called when close is called on a file descriptor, but because it might
 * have been dup'ed, this isn't a guarantee we won't ever need the file
 * again. For us, return success simply to avoid the unimplemented error
 * in the debug log.
 */
static int cs1550_flush (const char *path , struct fuse_file_info *fi)
{
	(void) path;
	(void) fi;

	return 0; //success!
}

/* Thanks to Mohammad Hasanzadeh Mofrad (@moh18) for these
   two functions */
static void * cs1550_init(struct fuse_conn_info* fi)
{
	  (void) fi;
	disk = fopen(".disk", "rb+"); //open the .disk file (disk is a global variable)
	//Initialize the .disk file if not done already
	root = (struct cs1550_root_directory *)malloc(sizeof(struct cs1550_root_directory));
	fread(root, BLOCK_SIZE, 1, disk);
	// printf("Num Directories = %i\n", root->nDirectories);

	// check if bit map is initialized by checking if the blocks are still set to 0
	fseek(disk, BITMAP, SEEK_SET); //seek to the beginning of the bit map (last 3 blocks)
	unsigned char c[3*BLOCK_SIZE];
	fread(c, sizeof(char), 1, disk); //read the first byte of the bit map
	if (c[0]<0x80) { //if the first bit is NOT set init bit map
		fseek(disk, BITMAP, SEEK_SET);
		c[0] = 0x80; //10000000
		c[3*BLOCK_SIZE-1] = 0x07; //00000111
		fwrite(c, sizeof(char), sizeof(c), disk);
		// printf("Initialized disk...\n");
	}
    printf("We're all gonna live from here ....\n");
		return NULL;
}

static void cs1550_destroy(void* args)
{
		(void) args;
		fclose(disk);
		free(root);
    printf("... and die like a boss here\n");
}

//Return the number of free blocks found in the bit map
static int findFree(int size, long *freeBlocks)
{
	int i, j, found = 0;
	unsigned char bitmap[3*BLOCK_SIZE];
	fseek(disk, BITMAP, SEEK_SET); 
	fread(bitmap, sizeof(bitmap), 1, disk);

	for (i=0; i<sizeof(bitmap)&&found<size; i++) {
		char c = bitmap[i];
		// printf("free: %hhx\n", c);
		for (j=7; j>=0&&found<size; j--) {
			if (!(c & 0x01)) { //found a 0 *free block)
				freeBlocks[found++] = j+(i*8);
			}
			c = c >> 1;
		}
	}

	return found;
}

static int setBit(int count, long * blockNum)
{
	int mapByte;
	int offset;
	char c;
	int i=0;
	// printf("%i: %i\n", 1, blockNum[1]);
	while (i<count) {
		mapByte = (int)blockNum[i]/8;
		offset = (int)blockNum[i]%8;
		fseek(disk, BITMAP+mapByte, SEEK_SET);
		fread(&c, sizeof(char), 1, disk);
		// printf("init set: %hhx\n", c);
		c = c | (0x80 >> offset);
		fseek(disk, BITMAP+mapByte, SEEK_SET);
		fwrite(&c, sizeof(char), 1, disk); //overwrite the byte
		i++;
	}

	// fseek(disk, BITMAP+mapByte, SEEK_SET);
	// fread(&c, sizeof(char), 1, disk);
	// printf("after set: %hhx\n", c);

	return i;
}


//register our new functions as the implementations of the syscalls
static struct fuse_operations hello_oper = {
    .getattr	= cs1550_getattr,
    .readdir	= cs1550_readdir,
    .mkdir	= cs1550_mkdir,
		.rmdir = cs1550_rmdir,
    .read	= cs1550_read,
    .write	= cs1550_write,
		.mknod	= cs1550_mknod,
		.unlink = cs1550_unlink,
		.truncate = cs1550_truncate,
		.flush = cs1550_flush,
		.open	= cs1550_open,
		.init = cs1550_init,
    .destroy = cs1550_destroy,
};

//Don't change this.
int main(int argc, char *argv[])
{
	return fuse_main(argc, argv, &hello_oper, NULL);
}