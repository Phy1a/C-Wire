#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "data.h"


Data *initData() {
    Data *d = malloc(sizeof(Data));
    if (d==NULL)
        exit(1);
    d->id = 0;
    d->capacity = 0;
    d->load= 0;
    
    return d;
}


void printData(Data d){
    printf("%d;%llu;%llu\n", d.id, d.capacity, d.load);
}


void addCharToStr(char* sentence, char c){
    int n = strlen(sentence);
    sentence[n]=c;
    sentence[n+1]='\0';
}


int fillData(Data *data ,int number,unsigned long long value){ // fill a data struct arguments n°number with value
    switch(number){
        case 0: data->id = value; break;
        case 1: data->capacity = value; break;
        case 2: data->load = value; break;
        default : printf("Error wrong argument\n"); break;
    }
}


Data *transcript(FILE *file, char *line){
    int cursor = 0; // to "read" the line
    int count = 0; // number of data's argument
    char futureInt[50] = ""; // char* to be converted into int
    Data *data = initData(); // return value

    unsigned long long value;
    char *end;

    while (line[cursor] != '\0' && count<2){
        if(line[cursor] == '0' && line[cursor-1] == ';'){
            cursor++;
            count++;
        }

        else if(line[cursor] == ';'){ // separator of the data
            if(strlen(futureInt)){ // futureInt == 0 shouldn't be possible except error in the file
                value = strtoull(futureInt, &end, 10);
                if (*end != '\0'){
                    printf("Error: invalid value : %s\n", futureInt);
                    free(data);
                    return NULL;
                }
                fillData(data,count,value);
                futureInt[0] = '\0'; // reset str
            }
            count++;
        }

        else{
            addCharToStr(futureInt,line[cursor]);
        }

        cursor++; // to check
    }

    while (line[cursor+1] != '\0'){ // +1 because of the space at the end of each line
        addCharToStr(futureInt,line[cursor]);
        cursor++;
    }
    value = strtoull(futureInt, &end, 10);
    if (*end != '\0'){
        printf("Error: invalid value : %s\n", futureInt);
        free(data);
        return NULL;
    }
    fillData(data, 2, value);
    
    return data;
}