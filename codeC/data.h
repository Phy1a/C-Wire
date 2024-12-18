#ifndef Data_H
#define Data_H

#include <stdio.h>

typedef struct {
    short id;
    unsigned long long capacity;
    unsigned long long load;
} Data;

Data *initData();
void printData(Data d);
void addCharToStr(char* sentence, char c);
int fillData(Data *data ,int number,unsigned long long value);
Data *transcript(FILE *file, char *line);

#endif // Data_H
