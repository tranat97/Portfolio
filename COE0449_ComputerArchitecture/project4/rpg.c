#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

struct player
{
    char name[50];
    char armor[25];
    char weapon[25];
    int wID;
    int aID;
    int AC;
    int DMG;
    int n; //number of dice
    int HP;
    int lvl;
    int exp;
    int unique; //1=player, 2=unique npcs, 0=randomized npcs
};


void assignAC(struct player *, int);
void assignDMG(struct player *, int);
int roll (int, int);
void fight(struct player *, struct player *);
void attack(struct player *, struct player *);
void init();
void load(FILE *);
void save();
void updatearmor(int);
void updateweapon(int);
void respawn(struct player *);
void print(struct player *);
void look();
void levelup(struct player *, struct player *);
int pow(int, int);
void earthquake();

struct player p1;
struct player npc[10];
int dice;

int main()
{
    int quit=0;
    dice =  open("/dev/dice", O_RDWR);
    FILE *inFile = fopen("rpg.save", "rb");
    char ans = 'n';

    if (inFile != NULL) {
        printf("Save file detected. Continue? (y/n): ");
        scanf("%c", &ans);
    }
    if (ans == 'y') {
        load(inFile);
    } else {
        p1.unique = 1;
        npc[0].unique = 2; //Luke Skywalker
        npc[9].unique = 3; //Ewok
        int i;
        for (i = 1; i < 9; i++) {
            npc[i].unique = 0; //Rebels
        }
        init();
    }

    look();
    signal(SIGINT, save);
    signal(SIGTERM, save);
    signal(SIGRTMIN, earthquake);
    do {
        char command[25];
        printf("command >> ");
        scanf("%s", command);
        if(strcmp(command, "quit")==0) {
            save();
        }
        else if(strcmp(command, "stats")==0) {
            print(&p1);
        }
        else if(strcmp(command, "look")==0) {
            look(&p1,npc);
        }
        else if(strcmp(command, "fight")==0) {
            int target;
            printf("Who do you want to fight? ");
            scanf("%d", &target);
            fight(&p1, &npc[target]);
        }
    }while(1);
}

//------------------

void init () {
    printf("What is your name?\n");
    scanf("%s", p1.name);
    //Choose armor
    int choice;

    printf("\nList of available armors:\n");
    printf("0: Leather Vest(AC = 10)\n");
    printf("1: Pilot's Outfit (AC = 12)\n");
    printf("2: Storm Trooper Armor (AC = 14)\n");
    printf("3: Bounty Hunter Armor (AC = 16)\n");
    printf("4: Heavy Armor (AC = 18)\n");

    do
    {
        printf("Choose %s's Armor: ", p1.name);
        scanf("%d", &choice);
    }while (choice <0 || choice > 4);
    assignAC(&p1, choice);

    //Choose weapons
    printf("\nList of available weapons:\n");
    printf("0: Stone Sling (damage = 1d4)\n");
    printf("1: Blaster Pistol (damage = 1d6)\n");
    printf("2: Blaster Rifle (damage = 1d8)\n");
    printf("3: Bowcaster (damage = 2d6)\n");
    printf("4: Missile Tube (damage = 1d12)\n");

    do
    {
        printf("Choose %s's Weapon: ", p1.name);
        scanf("%d", &choice);
    }while (choice < 0 || choice > 4);
    assignDMG(&p1, choice);

    //Initialize HP
    p1.lvl=1;
    p1.exp=pow(2,p1.lvl)*1000;
    p1.HP = 20+(p1.lvl-1)*5;

    printf("Player setting complete:\n");
    print(&p1);

    //initialize unique characters
    strcpy(npc[0].name,"Luke Skywalker");
    npc[0].lvl = 20;
    npc[0].exp=pow(2,npc[0].lvl)*1000;
    npc[0].HP = 20+(npc[0].lvl-1)*5;
    assignAC(&npc[0], 4);
    assignDMG(&npc[0], 4);
    strcpy(npc[0].weapon, "Lightsaber");
    strcpy(npc[0].armor, "Jedi Robes");

    strcpy(npc[9].name,"Ewok");
    npc[9].lvl = 1;
    npc[9].exp=pow(2,npc[9].lvl)*1000;
    npc[9].HP = 10;
    assignAC(&npc[9], 0);
    assignDMG(&npc[9], 0);

    int i;
    for(i=1;i<9;i++) {
        strcpy(npc[i].name,"Rebel");
        npc[i].lvl = 1;
        npc[i].exp=pow(2,npc[i].lvl)*1000;
        npc[i].HP = 20+(npc[i].lvl-1)*5;
        assignAC(&npc[i], roll(5,0));
        assignDMG(&npc[i], roll(5,0));
    }

}

void look() {
    int i;
    printf("\nIn a galaxy far far away...\n");
    printf("Luke Skywalker and his rebels are blissfully rebelling against the Galactic Empire!\n");
    for(i=0;i<10;i++) {
        printf("%d: ", i);
        print(&npc[i]);
    }
    printf("Also at the scene are some bounty hunters looking for trouble\n0: ");
    print(&p1);
}

void print(struct player *p) {
    printf("[%s: hp=%d, armor=%s(%d), weapon=%s(%dd%d), level=%d, xp=%d]\n",p->name, p->HP, p->armor, p->AC, p->weapon, p->n, p->DMG, p->lvl, p->exp);
}

void assignAC(struct player *p, int choice)
{
    switch (choice) {
        case 0:
            strcpy(p->armor, "Leather Vest");
            p->AC = 10;
            break;
        case 1:
            strcpy(p->armor, "Pilot's Outfit");
            p->AC = 12;
            break;
        case 2:
            strcpy(p->armor, "Storm Trooper Armor");
            p->AC = 14;
            break;
        case 3:
            strcpy(p->armor, "Bounty Hunter Armor");
            p->AC = 16;
            break;
        case 4:
            strcpy(p->armor, "Heavy Armor");
            p->AC = 18;
            break;
    }
    p->aID = choice;
}

void assignDMG (struct player *p, int choice)
{
    switch (choice) {
        case 0:
            strcpy(p->weapon, "Stone Sling");
            p->DMG = 4;
            p->n = 1;
            break;
        case 1:
            strcpy(p->weapon, "Blaster Pistol");
            p->DMG = 6;
            p->n = 1;
            break;
        case 2:
            strcpy(p->weapon, "Blaster Rifle");
            p->DMG = 8;
            p->n = 1;
            break;
        case 3:
            strcpy(p->weapon, "Bowcaster");
            p->DMG = 6;
            p->n = 2;
            break;
        case 4:
            strcpy(p->weapon, "Missile Tube");
            p->DMG = 12;
            p->n = 1;
            break;
    }
    p->wID = choice;
}

int roll (int high, int low)
{
    char r, max=(char)high;
    write(dice, &max, 1);
    read(dice, &r, 1);
    return (int)r+low;
}

//returns the damage done by attacker (0 if a miss)
void attack(struct player *attacker, struct player *target) {
    int hit = roll(20, 1);

    if (target->AC <= hit) {
        int i;
        int dmg=0;
        for(i=0;i<attacker->n; i++) {
            dmg += roll(attacker->DMG, 1);
        }
        target->HP -= dmg;
        printf("%s hit %s for %d damage (Attack roll: %d)\n",attacker->name, target->name, dmg, hit);
    }
    else {
        printf("%s misses %s (Attack roll: %d)\n",attacker->name, target->name, hit);
    }
}

void fight(struct player *p, struct player *npc) {
    printf("\n");
    do
    {
        //player 1 attacks
        attack(p, npc);
        //NPC attacks
        attack(npc, p);
    }while(p->HP>0 && npc->HP>0);

    if(p->HP<=0 && npc->HP<=0) {
        printf("\nBoth %s and %s have fallen.\n", p->name, npc->name);
        respawn(p);
        respawn(npc);
    }
    else if(p->HP<=0) {
        printf("\n%s is killed by %s.\n", p->name, npc->name);
        levelup(npc, p);
        respawn(p);
    }
    else {
        printf("\n%s is killed by %s.\n", npc->name, p->name);
        levelup(p, npc);
        char ans='n';
        printf("Get %s's %s, exchanging %s's current %s? (y/n): ", npc->name, npc->armor, p->name, p->armor);
        scanf(" %c", &ans);
        if(ans=='y')
            updatearmor(npc->aID);
        printf("Get %s's %s, exchanging %s's current %s? (y/n): ", npc->name, npc->weapon, p->name, p->weapon);
        scanf(" %c", &ans);
        if(ans=='y')
            updateweapon(npc->wID);
        respawn(npc);
    }
}

void earthquake() {
    printf("\nEARTHQUAKE!!!\n");
    int i;
    for(i=0;i<10;i++) {
        npc[i].HP -= 20;
        if(npc[i].HP<=0) {
            printf("%s suffers -20 damage and dies.\n", npc[i].name);
            respawn(&npc[i]);
        }
        else {
            printf("%s suffers -20 damage but survives.\n", npc[i].name);
        }
    }

    p1.HP -= 20;
    if(p1.HP<=0) {
        printf("%s suffers -20 damage and dies.\n", p1.name);
        respawn(&p1);
    }
    else {
        printf("%s suffers -20 damage but survives.\n", p1.name);
    }
    printf("\ncommand >> ");
    fflush(stdout);
}

//Respawn has special cases: rebels spawn with randomized gear, ewok always has 10 health
void respawn(struct player *dead) {
    printf("%s placed in Bacta tank for revival\n", dead->name);

    switch(dead->unique) {
        case 0: //rebels
            dead->lvl = roll(p1.lvl, 1);
            dead->exp=pow(2,dead->lvl)*1000;
            dead->HP = 20+(dead->lvl-1)*5;
            assignAC(dead, roll(5,0));
            assignDMG(dead, roll(5,0));
            break;
        case 1:
        case 2:
            dead->exp=pow(2,dead->lvl)*1000;
            dead->HP = 20+(dead->lvl-1)*5;
            break;
        case 3: //ewok
            dead->HP = 10;
            dead->exp=pow(2,dead->lvl)*1000;
            break;
    }
    print(dead);
    printf("\n");
}

//Only player can level up
void levelup(struct player *p, struct player *victim) {
    p->exp += victim->lvl*2000;
    while(p->exp >= pow(2,p->lvl+1)*1000) {
        p->lvl++;
        printf("%s LEVELS UP! (lvl %d)\n", p->name, p->lvl);
    }
    switch (p->unique) {
        case 0:
        case 1:
            p->HP = 20+(p1.lvl-1)*5;
            break;
        case 3:
            p->HP = 10;
    }


}

void updatearmor(int new) {
    assignAC(&p1, new);
}

void updateweapon(int new) {
    assignDMG(&p1, new);
}

int pow(int x, int y) {
    if (y==0) return 1;
    int i=1;
    while(y!=0) {
        i = i*x;
        y--;
    }
     return i;
}

//loads given save file
void load(FILE *infile) {
    fread(&p1, sizeof(struct player), 1, infile);
    fread(npc, sizeof(struct player), 10, infile);
}

//saves file
void save() {
    FILE *outfile = fopen("rpg.save", "wb");
    fwrite(&p1, sizeof(struct player), 1, outfile);
    fwrite(npc, sizeof(struct player), 10, outfile);
    printf("\nSave Successful\n");
    exit(0);
}

