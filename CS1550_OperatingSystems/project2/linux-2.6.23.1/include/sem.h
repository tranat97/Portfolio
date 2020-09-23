struct task_node
{
	struct task_struct *task;
	struct task_node *next;
	int priority;
};

struct priority_queue
{
	int size;
	struct task_node *head;
	
};

struct cs1550_sem
{
	int value;
	struct priority_queue *pq;
};

void sem_push(struct cs1550_sem *sem, struct task_struct *newTask, int priority);

struct task_struct *sem_pop(struct cs1550_sem *sem);


