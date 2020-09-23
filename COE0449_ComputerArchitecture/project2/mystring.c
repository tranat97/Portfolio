#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    FILE *filename = fopen(argv[1], "rb");
    unsigned char c;
    int i = 0, size = 100;
    char buf[5];
    buf[4]='\0';
    fread(&c, sizeof(char), 1, filename);

    while(!feof(filename)) {
        if (((int)c>=32 && (int)c<=126) || (int)c==9) {
            if(i<4) {
                buf[i++] = c;
            }else{
                i++;
                printf("2%c", c);
            }

            if(i==4){
                printf("2%s", buf);
            }

        }
        else {
            printf("\n");
            buf[0] = '\0';
            i=0;
        }


        fread(&c, sizeof(char), 1, filename);
        printf("%c\n", c);
    }
}