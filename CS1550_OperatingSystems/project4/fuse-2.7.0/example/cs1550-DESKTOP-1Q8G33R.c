/*
	FUSE: Filesystem in Userspace
	Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>

	This program can be distributed under the terms of the GNU GPL.
	See the file COPYING.
*/

#define	FUSE_USE_VERSION 26

#include <fuse.h>
#include <stdio.h>
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
FILE *disk; //global disk pointer, every function should return the pointer back to the beginning before returning
struct cs1550_root_directory *root; 

static long * findFree(int);
static int setBit(long *);

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
	int res = 0;

	memset(stbuf, 0, sizeof(struct stat));
	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME];
	char extension[MAX_EXTENSION];
	sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension);
	printf("dir %s\n", directory);

	//is path the root dir?
	if (strcmp(path, "/") == 0) {
		stbuf->st_mode = S_IFDIR | 0755;
		stbuf->st_nlink = 2;
	} else if (directory!=NULL) { //Check if name is subdirectory
		int i;
		struct cs1550_directory currentDir;
		for (i=0; i<root->nDirectories; i++) {
			currentDir = root->directories[i];
			if(strcmp(directory, currentDir.dname+1)==0) {
				stbuf->st_mode = S_IFDIR | 0755;
				stbuf->st_nlink = 2;
				res = 0; //no error
				break;
			}
		}
		if (filename!=NULL && extension!=NULL) { //Check if name is a regular file
			struct cs1550_directory_entry dir;
			struct cs1550_file_directory currentFile;
			long blockStart = currentDir.nStartBlock; //save the start of the directory block
			fseek(disk, blockStart, SEEK_SET);
			fread(&dir, BLOCK_SIZE, 1, disk);
			for (i=0; i<dir.nFiles; i++) {
				currentFile = dir.files[i];
				if(strcmp(filename, currentFile.fname+1)==0 && strcmp(extension, currentFile.fext+1)==0) {
					stbuf->st_mode = S_IFREG | 0666;
					stbuf->st_nlink = 1; //file links
					stbuf->st_size = currentFile.fsize; //file size - make sure you replace with real size!
					res = 0; // no error
					break;
				} else {
					res = -ENOENT;
				}
			}
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
	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME];
	char extension[MAX_EXTENSION];
	int i, j;
	struct cs1550_directory currentDir;
	long blockStart;

	//the filler function allows us to add entries to the listing
	//read the fuse.h file for a description (in the ../include dir)
	filler(buf, ".", NULL, 0);
	filler(buf, "..", NULL, 0);

	//print all directories
	if (strcmp(path, "/") == 0) {
		for (i=0; i<root->nDirectories; i++) {
			filler(buf, root->directories[i].dname, NULL, 0);
		}
		return 0;
	}

	/*
	//add the user stuff (subdirs or files)
	//the +1 skips the leading '/' on the filenames
	filler(buf, newpath + 1, NULL, 0);
	*/
	sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension);
	//check if the path exists
	for (i=0; i<root->nDirectories; i++) {
		currentDir = root->directories[i];
		if(strcmp(currentDir.dname+1, directory)==0) {
			struct cs1550_directory_entry dir;
			struct cs1550_file_directory currentFile;
			blockStart = currentDir.nStartBlock; //save the start of the directory block
			fseek(disk, blockStart, SEEK_SET);
			fread(&dir, BLOCK_SIZE, 1, disk);
			for (j=0; j<dir.nFiles; j++) {
				currentFile = dir.files[j];
				char *filename;
				strcpy(filename, currentFile.fname);
				strcat(filename, currentFile.fext);
				filler(buf, filename, NULL, 0);
			}
			break;
		}
	}

	//File not found
	if (i >= root->nDirectories) {
		printf("Directory not found\n");
		return -ENOENT;
	}

	
	fseek(disk, 0, SEEK_SET);
	return 0;
}

/*
 * Creates a directory. We can ignore mode since we're not dealing with
 * permissions, as long as getattr returns appropriate ones for us.
 */
static int cs1550_mkdir(const char *path, mode_t mode)
{
	(void) path;
	(void) mode;
	long * freeBlock;
	int i;
	//Check length of directory name
	if(strlen(path)>MAX_FILENAME) {
		printf("Error: Max length of filename: %i\n", MAX_FILENAME);
		return -ENAMETOOLONG;
	}

	for(i=0; i<root->nDirectories; i++) {
		if(strcmp(root->directories[i].dname, path)==0) {
			printf("Error: Filename %s already exists\n", path);
			return -EEXIST;
		}
	}

	//Check bit map
	freeBlock = findFree(1);
	printf("First free block = %i\n", freeBlock[0]);
	if (freeBlock[0] != -1) {
		struct cs1550_directory_entry *newDir = malloc(sizeof(struct cs1550_directory_entry));
		newDir->nFiles=0;
		
		int x =root->nDirectories;
		strcpy(root->directories[x].dname, path);
		root->directories[x].nStartBlock = freeBlock[0];
		
		//write directory to file
		fseek(disk, freeBlock[0], SEEK_SET);
		fwrite(newDir, BLOCK_SIZE, 1, disk);
		setBit(freeBlock); //set the bit in the bit map
		root->nDirectories++; //increment the number of directories

		//update root directory
		fseek(disk, 0, SEEK_SET);
		fwrite(root, BLOCK_SIZE, 1, disk);

		free(newDir);
	}
	fseek(disk, 0, SEEK_SET);
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
	
	char directory[MAX_FILENAME];
	char filename[MAX_FILENAME];
	char extension[MAX_EXTENSION];
	sscanf(path, "/%[^/]/%[^.].%s", directory, filename, extension);
	if (directory!=NULL) { //for subdirectory
		int i;s
		struct cs1550_directory currentDir;
		for (i=0; i<root->nDirectories; i++) {
			currentDir = root->directories[i];
			if(strcmp(directory, currentDir.dname+1)==0) {
				if (filename!=NULL && extension!=NULL) { //Check if name is a regular file
					struct cs1550_directory_entry dir;
					struct cs1550_file_directory currentFile;
					long blockStart = currentDir.nStartBlock; //save the start of the directory block
					fseek(disk, blockStart, SEEK_SET);
					fread(&dir, BLOCK_SIZE, 1, disk);
					for (i=0; i<dir.nFiles; i++) {
						currentFile = dir.files[i];
						if(strcmp(filename, currentFile.fname+1)==0 && strcmp(extension, currentFile.fext+1)==0) {
							stbuf->st_mode = S_IFREG | 0666;
							stbuf->st_nlink = 1; //file links
							stbuf->st_size = currentFile.fsize; //file size - make sure you replace with real size!
							res = 0; // no error
							break;
						} else {
							res = -ENOENT;
						}
					}
				}
				
			}
		}
		 
	}

	return -EOENT;
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
	(void) buf;
	(void) offset;
	(void) fi;
	(void) path;

	//check to make sure path exists
	//check that size is > 0
	//check that offset is <= to the file size
	//read in data
	//set size and return, or error

	size = 0;

	return size;
}

/*
 * Write size bytes from buf into file starting from offset
 *
 */
static int cs1550_write(const char *path, const char *buf, size_t size,
			  off_t offset, struct fuse_file_info *fi)
{
	(void) buf;
	(void) offset;
	(void) fi;
	(void) path;

	//check to make sure path exists
	//check that size is > 0
	//check that offset is <= to the file size
	//write data
	//set size (should be same as input) and return, or error

	return size;
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
	printf("Num Directories = %i\n", root->nDirectories);

	// check if bit map is initialized by checking if the blocks are still set to 0
	fseek(disk, BITMAP, SEEK_SET); //seek to the beginning of the bit map (last 3 blocks)
	unsigned char c[3*BLOCK_SIZE];
	fread(c, sizeof(char), 1, disk); //read the first byte of the bit map
	if (c[0]<0x80) { //if the first bit is NOT set init bit map
		fseek(disk, BITMAP, SEEK_SET);
		c[0] = 0x80; //10000000
		c[3*BLOCK_SIZE-1] = 0x07; //00000111
		fwrite(c, sizeof(char), 3*BLOCK_SIZE, disk);
		printf("Initialized disk...\n");
	}
    printf("We're all gonna live from here ....\n");
	fseek(disk, 0, SEEK_SET); //return the pointer back to the beginning of the file
		return NULL;
}

static void cs1550_destroy(void* args)
{
		(void) args;
		fclose(disk);
		free(root);
    printf("... and die like a boss here\n");
}

//Return the indexes of the first free blocks found in the bit map
static long * findFree(int size)
{
	int i, j, found = 0;
	static long index[MAX_ENTRIES_IN_INDEX_BLOCK];
	unsigned char bitmap[3*BLOCK_SIZE];
	fseek(disk, BITMAP, SEEK_SET); 
	fread(bitmap, sizeof(bitmap), 1, disk);

	for (i=0; i<sizeof(bitmap)&&found<size; i++) {
		char c = bitmap[i];
		// printf("free: %hhx\n", c);
		for (j=7; j>=0&&found<size; j--) {
			if (!(c & 0x01)) {
				index[found++] = j+(i*8);
			}
			c = c >> 1;
		}
	}
	if(size<MAX_ENTRIES_IN_INDEX_BLOCK-1) {
		index[found]= -1;
		// printf("%i: %i\n", found, index[found]);
	}

	fseek(disk, 0, SEEK_SET);
	return index;
}

static int setBit(long * blockNum)
{
	int mapByte;
	int offset;
	char c;
	int i=0;
	// printf("%i: %i\n", 1, blockNum[1]);
	while (blockNum[i]>0) {
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

	fseek(disk, 0, SEEK_SET);
	return 1;
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
