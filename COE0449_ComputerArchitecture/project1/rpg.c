#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct player
{
	char *armor;
	char *weapon;
	int AC;
	int DMG;
	int n; //number of dice
	int HP;
}p1,p2;

void assignAC(struct player *, int);
void assignDMG(struct player *, int);
int roll (int, int);
int attack(struct player *, struct player *);

int main()
{
	//seed RNG
	srand((unsigned int)time(NULL));

	//Choose armor
	int choice;
	char fight;

	printf("\nList of available armors:\n");
	printf("0: cloth (AC = 10)\n");
	printf("1: studded leather (AC = 12)\n");
	printf("2: ring mail (AC = 14)\n");
	printf("3: chain mail (AC = 16)\n");
	printf("4: plate (AC = 18)\n\n");

	do
	{
		printf("Choose Player 1 Armor: ");
		scanf("%d", &choice);
	}while (choice <0 || choice > 4);
	assignAC(&p1, choice);

	do
	{
		printf("Choose Player 2 Armor: ");
		scanf("%d", &choice);
	}while (choice < 0 || choice > 4);
        assignAC(&p2, choice);

	//Choose weapons
	printf("\nList of available weapons:\n");
	printf("0: dagger (damage = 1d4)\n");
        printf("1: short sword (damage = 1d6)\n");
        printf("2: long sword (damage = 1d8)\n");
        printf("3: great sword (damage = 2d6)\n");
        printf("4: great axe (damage = 1d12)\n\n");

	do
	{
		printf("Choose Player 1 Weapon: ");
        	scanf("%d", &choice);
	}while (choice < 0 || choice > 4);
        assignDMG(&p1, choice);

	do
	{
        	printf("Choose Player 2 Weapon: ");
        	scanf("%d", &choice);
	}while (choice < 0 || choice > 4);
        assignDMG(&p2, choice);
	
	//Initialize HP
	p1.HP = 20;
	p2.HP = 20;

	printf("Player setting complete:\n");
	printf("[Player 1: hp=%d, armor=%s(AC=%d), weapon=%s(DMG=%dd%d)]\n", p1.HP, p1.armor, p1.AC, p1.weapon, p1.n, p1.DMG);
	printf("[Player 2: hp=%d, armor=%s(AC=%d), weapon=%s(DMG=%dd%d)]\n", p2.HP, p2.armor, p2.AC, p2.weapon, p2.n, p2.DMG);

    do
    {
        printf("\nFight? (y/n): ");
        scanf("%c", &fight);
    }while (fight!='y' && fight!='Y' && fight!='n' && fight!='N');

	do
    {
		if (fight == 'y' || fight == 'Y')
		{
			int round = 1;
			//reinitialize HP
			p1.HP = 20;
			p2.HP = 20;
			do
			{
			    printf("\n------ Round %d ------\n", round++);
                //player 1 attack
                int hp = p2.HP;
                int hit = attack(&p1, &p2);
                if(hp==p2.HP)
                {
                    printf("Player 1 missed Player 2 (Attack roll: %d)\n", hit);
                }
                else
                {
                    printf("Player 1 hit Player 2 for %d damage (Attack roll: %d)\n", hp-p2.HP, hit);
                }
                //player 2 attack
                hp = p1.HP;
                hit = attack(&p2, &p1);
                if(hp==p1.HP)
                {
                    printf("Player 2 missed Player 1 (Attack roll: %d)\n", hit);
                }
                else
                {
                    printf("Player 2 hit Player 1 for %d damage (Attack roll: %d)\n", hp-p1.HP, hit);
                }

                printf("[Player 1: hp=%d, armor=%s(AC=%d), weapon=%s(DMG=%dd%d)]\n", p1.HP, p1.armor, p1.AC, p1.weapon, p1.n, p1.DMG);
                printf("[Player 2: hp=%d, armor=%s(AC=%d), weapon=%s(DMG=%dd%d)]\n", p2.HP, p2.armor, p2.AC, p2.weapon, p2.n, p2.DMG);
			}while(p1.HP>0 && p2.HP>0);

			if(p1.HP<=0 && p2.HP<=0)
			    printf("\nDRAW!\n");
			else if(p1.HP<=0)
			    printf("\nPlayer 2 WINS!\n");
			else
			    printf("\nPlayer 1 WINS\n");
		}

        do
        {
            printf("\nFight again? (y/n): ");
            scanf("%c", &fight);
        }while (fight!='y' && fight!='Y' && fight!='n' && fight!='N');

 	} while (fight == 'y' || fight == 'Y');
}

void assignAC(struct player *p, int choice)
{
	switch (choice)
	{
		case 0:
			p->armor = "Cloth";
			p->AC = 10;
			break;
		case 1:
			p->armor = "Studded Leather";
			p->AC = 12;
			break;
		case 2:
			p->armor = "Ring Mail";
			p->AC = 14;
			break;
		case 3:
			p->armor = "Chain Mail";
			p->AC = 16;
			break;
		case 4:
			p->armor = "Plate";
			p->AC = 18;
			break;
	}
}

void assignDMG (struct player *p, int choice)
{
	switch (choice)
	{
		case 0:
			p->weapon = "Dagger";
			p->DMG = 4;
			p->n = 1;
			break;
		case 1:
			p->weapon = "Short Sword";
                        p->DMG = 6;
                        p->n = 1;
			break;
		case 2:
			p->weapon = "Long Sword";
                        p->DMG = 8;
                        p->n = 1;
			break;
		case 3:
			p->weapon = "Great Sword";
                        p->DMG = 6;
                        p->n = 2;
			break;
		case 4:
			p->weapon = "Great Axe";
                        p->DMG = 12;
                        p->n = 1;
			break;
		}
}

int roll (int high, int low)
{
    int value = rand() % (high - low + 1) + low;
    return value;
}

//returns the damage done by attacker (0 if a miss)
int attack(struct player *attacker, struct player *target)
{
    int hit = roll(20, 1);

    if (target->AC <= hit)
    {
        int dmg = roll(attacker->DMG*attacker->n, attacker->n);
        target->HP -= dmg;
    }
    return hit;
}

