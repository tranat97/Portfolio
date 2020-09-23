typedef struct tree {
	int data;
	struct tree *left;
	struct tree *right;
};

void freetree(struct tree *);

void randominsert(struct tree *, struct tree *);

void printtree(struct tree *);

void test1();

int comp(const void *, const void *);

void test2();