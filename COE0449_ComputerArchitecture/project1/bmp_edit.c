#define _CRT_SECURE_NO_WARNINGS
#pragma pack(1)
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

struct header
{
    unsigned char formatID[2];
    unsigned int size;
    unsigned char r1[2];
    unsigned char r2[2];
    unsigned long offset;
}h1;

struct DIB
{
    unsigned int headerSize;
    unsigned int width;
    unsigned int  height;
    unsigned short planes;
    unsigned short bpp;
    unsigned int comp;
    unsigned int imgSize;
    unsigned int hRes;
    unsigned int vRes;
    unsigned int pallete;
    unsigned int colors;
}h2;

struct pixel
{
    unsigned char blue;
    unsigned char green;
    unsigned char red;
};
/*
    BEGIN MAIN
*/
int main(int argc, char *argv[])
{
    printf("%s\n", argv[1]);
    if(argc!=3 || strcmp(argv[1], "-invert")!=0 && argv[1]!="-greyscale")
    {
        printf("Invalid arguments");
        exit(0);
    }

    _CRT_SECURE_NO_WARNINGS
    FILE *inFile = fopen(argv[2], "r+b");
    FILE *outFile = fopen(argv[2], "r+b");
    fread(&h1, sizeof(char), 14, inFile);
    fread(&h2, sizeof(char), 40, inFile);

    //error checks
    if(h1.formatID[0]!='B' || h1.formatID[1]!='M' || h2.headerSize!=40 || h2.bpp!=24)
    {
        printf("Image format not compatible\n");
        exit(0);
    }

    //set offset
    fseek(inFile, h1.offset, SEEK_SET);
    fseek(outFile, h1.offset, SEEK_SET);
    unsigned int height,width;
    struct pixel p;
    for (height = 0; height < h2.height; height++)
    {
        for (width = 0; width < h2.width; width++)
        {
            fread(&p, sizeof(char), 3, inFile);
            //fseek(inFile, -3, SEEK_CUR);
            p.blue = ~p.blue;
            p.green = ~p.green;
            p.red = ~p.red;
            fwrite(&p, sizeof(char), 3, outFile);
        }

        int rowOffset = 0;
        if (h2.width*3%4 != 0)
            rowOffset = 4-h2.width*3%4;
        fseek(inFile, rowOffset, SEEK_CUR);
    }

}