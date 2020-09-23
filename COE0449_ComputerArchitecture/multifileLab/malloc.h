//replace malloc here with the appropriate version of mymalloc
#define MALLOC malloc
//replace free here with the appropriate version of myfree
#define FREE free
//define DUMP_HEAP() to be the dump_heap() function that you write
#define DUMP_HEAP()

//Whether to turn on verbose heap debug output
#define HEAP_DEBUG

//You can adjust how many things are allocated
#define TIMES 100

//If you want to make times bigger than 100, remove the call to qsort and do something else.
//Then remove this check.
#if TIMES >= 1000
	#error "TIMES is too big, qsort will switch to mergesort which requires a temporary malloc()ed array"
#endif