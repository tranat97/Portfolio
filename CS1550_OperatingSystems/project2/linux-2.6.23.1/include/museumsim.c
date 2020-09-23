#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <linux/unistd.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/time.h>
//Add your struct cs1550_sem type declaration below
#include "sem.h"

void down(struct cs1550_sem *sem) {
  syscall(__NR_cs1550_down, sem);
}

void up(struct cs1550_sem *sem) {
  syscall(__NR_cs1550_up, sem);
}

struct shared_mem {
    int visitorNum; //id number of visitors who have entered the museum
    int guideNum; //id number of guides who has entered the museum
    int currentVisitors; // number of visitors in the museum, when the last visitor leaves, call up() to allow guides to leave
    struct cs1550_sem guideSem; //Number of tour guides in the museum (2 at a time)
    struct cs1550_sem waitV; //number of waiting visitors, checked by guides to see if they can open the museum
    struct cs1550_sem waitOpen; //Number of visitors waiting to enter the museum, used by visitors, if the visitor can enter the museum
    struct cs1550_sem waitClose; //Wait for all visitors to leave before the guides leave
    struct timeval time; //start time

    struct cs1550_sem guideMutex; //mutex for the guide variables
    struct cs1550_sem visitorMutex; //mutex for the visitor variables
};

void VisitorArrivalProcess(struct shared_mem *, int, int, int, int); 
void TourGuideArrivalProcess(struct shared_mem *, int, int, int, int);
int visitorArrives(struct shared_mem *);
int tourGuideArrives(struct shared_mem *);
void tourMuseum(struct shared_mem *, int);
void openMuseum(struct shared_mem *, int);
void visitorLeaves(struct shared_mem *, int);
void tourGuideLeaves(struct shared_mem *, int);
long time_elapsed(struct shared_mem *);

int main (int argc, char *argv[])
{
    int visitorCount = 1, guideCount = 1,
    pv = 0, //probability of a visitor immediately following another visitor
    dv = 0, //delay in seconds when a visitor foes not immediately follow another visitor
    sv = 0, //random seed for the visitor arrival process
    pg = 0, //probability of a tour guide immediately following another tour guide
    dg = 0, //delay in seconds when a tour guide does not immediately follow another tour guide
    sg = 0; //random seed for the tour guide arrival process
    
    if (argc%2!=1) {
        printf("Invalid number of arguments!\n");
        fflush(stdout);
        exit(0);
    }
    //parse values from cmd line arguments
    int i;
    for (i=1; i<argc; i=i+2) {
        char *arg = argv[i];
        char *val = argv[i+1];
        if (strcmp("-m", arg)==0) {
            visitorCount = atoi(val);
        } else if (strcmp("-k", arg)==0) {
            guideCount = atoi(val);
        } else if (strcmp("-pv", arg)==0) {
            pv = atoi(val);
        } else if (strcmp("-dv", arg)==0) {
            dv = atoi(val);
        } else if (strcmp("-sv", arg)==0) {
            sv = atoi(val);
        } else if (strcmp("-pg", arg)==0) {
            pg = atoi(val);
        } else if (strcmp("-dg", arg)==0) {
            dg = atoi(val);
        } else if (strcmp("-sg", arg)==0) {
            sg = atoi(val);
        } else {
            printf("Invalid argument!\n");
            fflush(stdout);
            exit(0);
        }
    }

    //set up shared memory
    struct shared_mem *mem = (struct shared_mem *)mmap(NULL, sizeof(struct shared_mem), PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, 0, 0);
    mem->guideSem.value = 2; //max 2 guides in the museum at a time
    mem->waitV.value = 0;
    mem->waitOpen.value = 0;
    mem->waitClose.value = 0;
    mem->guideMutex.value = 1; //only 1 guide can access the guide variables at a time
    mem->visitorMutex.value = 1; //same as above
    gettimeofday(&mem->time, NULL); //get current time

    printf("The museum is now empty.\n");
    fflush(stdout);
    
    int pid = fork(); //fork a child process which will call the visitor arrival process (parent calls the guide arrival process)
    if (pid==0) {
        VisitorArrivalProcess(mem, visitorCount, pv, dv, sv);
    } else {
        TourGuideArrivalProcess(mem, guideCount, pg, dg, sg);
        // printf("The museum is now empty again...\n");
    }
}

void VisitorArrivalProcess(struct shared_mem *mem, int visitorCount, int pv, int dv, int sv) 
{
    srand(sv);
    int i;
    for (i=0; i<visitorCount; i++){
        int pid  = fork();
        if(pid == 0) {
            int visitorNum;
            //visitor arrives
            visitorNum = visitorArrives(mem);
            //visitor takes a tour
            tourMuseum(mem, visitorNum);
            //visitor leaves
            visitorLeaves(mem, visitorNum);
            exit(0);
        } else {
            int value = rand() % 100 + 1;
            if (value > pv) {
                sleep(dv);
            }
        }
    }

    for (i=0; i<visitorCount; i++) {
        wait(NULL);
    }
}

void TourGuideArrivalProcess(struct shared_mem *mem, int guideCount, int pg, int dg, int sg) 
{
    srand(sg);
    int i;
    for (i=0; i<guideCount; i++){
        int pid  = fork();
        if(pid == 0) {
            int guideNum;
            //guide arrives
            guideNum = tourGuideArrives(mem);
            //open museum
            openMuseum(mem, guideNum);
            //guide leaves
            tourGuideLeaves(mem, guideNum);
            exit(0);
        } else {
            int value = rand() % 100 + 1;
            if (value > pg) {
                sleep(dg);
            }
        }
    }

    for (i=0; i<guideCount; i++) {
        wait(NULL);
    }
}

int visitorArrives(struct shared_mem *mem)
{
    int temp;

    down(&mem->visitorMutex); //one visitor at a time to prevent data races
        mem->visitorNum++; //increment the number of visitors that have entered and save it (this will be the visitor's id num)
        temp = mem->visitorNum;
    up(&mem->visitorMutex);

    printf("Visitor %d arrives at time %d.\n", temp, (int)time_elapsed(mem));
    fflush(stdout);

    up(&mem->waitV); //signal a visitor is waiting
    down(&mem->waitOpen); //Wait for a guide to open the museum
    
    down(&mem->visitorMutex); //one visitor at a time to prevent data races
        mem->currentVisitors++;
    up(&mem->visitorMutex);

    return temp;
}

int tourGuideArrives(struct shared_mem *mem)
{
    int temp;

    down(&mem->guideMutex); //one guide at a time to prevent data races
        mem->guideNum++;  //increment the number of guides that have entered and save it (this will be the guide's id num)
        temp = mem->guideNum;
    up(&mem->guideMutex);
    printf("Tour guide %d arrives at time %d.\n", temp, (int)time_elapsed(mem));
    fflush(stdout);

    down(&mem->guideSem);

// printf("\tguide %d enters; spots left: %d\n", temp, mem->guideSem.value);

    down(&mem->waitV); //wait for a visitor to arrive
    return temp;
}

void tourMuseum(struct shared_mem *mem, int visitorNum)
{
    printf("Visitor %d tours the museum at time %d.\n", visitorNum, (int)time_elapsed(mem));
    fflush(stdout);
    sleep(2); //take the tour
}

void openMuseum(struct shared_mem *mem, int guideNum)
{
    printf("Tour guide %d opens the museum for tours at time %d.\n", guideNum, (int)time_elapsed(mem));
    fflush(stdout);
    int i;
    for(i=0; i<10; i++) {
        up(&mem->waitOpen); //Open the museum, wake up max 10 visitors waiting for open
    }
    
// printf("\tvisitors allowed: %d\n", mem->visitorSem.value);
}

void visitorLeaves(struct shared_mem *mem, int visitorNum)
{
    printf("Visitor %d leaves at time %d.\n", visitorNum, (int)time_elapsed(mem));
    fflush(stdout);
    down(&mem->visitorMutex);
    mem->currentVisitors--;
    up(&mem->visitorMutex);
    if (mem->currentVisitors==0) {
        up(&mem->waitClose);
    }
// printf("\tvisitors allowed: %d\n", mem->visitorSem.value);
    
}

void tourGuideLeaves(struct shared_mem *mem, int guideNum)
{
    down(&mem->waitClose); //wait until there are no visitors in the museum
    printf("Tour guide %d leaves at time %d.\n", guideNum, (int)time_elapsed(mem));
    fflush(stdout);
    up(&mem->guideSem); //give back resource, allow more tour guides to enter
// printf("\tguide %d leaves; spots left: %d; visitors allowed: %d\n", guideNum, mem->guideSem.value, mem->visitorSem.value);
}

long time_elapsed(struct shared_mem *mem)
{
    struct timeval startTime = mem->time;
    struct timeval currentTime;
    gettimeofday(&currentTime, NULL);
    long elapsed = (currentTime.tv_sec-startTime.tv_sec) + ((currentTime.tv_usec-startTime.tv_usec)/1000000);
    return elapsed;
}