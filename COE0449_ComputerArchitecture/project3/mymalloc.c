#include "mymalloc.h"

struct Block {
    int occ;              // whether block is occupied
    int size;             // size of block (including header)
    struct Block *prev;   // pointer to previous block
    struct Block *next;   // pointer to next block
};

static struct Block *head = NULL;

void *my_malloc(int size)
{
    static struct Block *prev = NULL;
    static int first = 1;

    struct Block *header = (struct Block *)sbrk(sizeof(struct Block));
    void *cur = sbrk(size);
    header->occ = 1;
    header->size = size+sizeof(struct Block);
    header->prev = prev;
    if(header->prev != NULL)
        header->prev->next = header;
    prev = header;


    if(first)
    {
        head = header;
        first = 0;
    }
    return cur;
}

void my_free(void *data)
{
    struct Block *n = (struct Block *)data;
    n->occ = 0;
}

void dump_heap()
{
    struct Block *cur;
    printf("brk: %p\n", sbrk(0));
    printf("head->");
    for(cur = head; cur != NULL; cur = cur->next) {
        printf("[%d:%d:%d]->", cur->occ, (char*)cur - (char*)head, cur->size);
        fflush(stdout);
        assert((char*)cur >= (char*)head && (char*)cur + cur->size <= (char*)sbrk(0)); // check that block is within bounds of the heap
        if(cur->next != NULL) {
            assert(cur->next->prev == cur); // if not last block, check that forward/backward links are consistent
            assert((char*)cur + cur->size == (char*)cur->next); // check that the block size is correctly set
        }
    }
    printf("NULL\n");
}

