#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

typedef struct {
    short central_id;
    short hvb_id;
    short hva_id;
    short lv_id;
    int company_id;
    int individual_id; // individual consummer only
    int capacity;
    int load; // either consumption or production depending on the entity (central or consummer)
} Data;


Data *initData() {
    Data *d = malloc(sizeof(Data));
    if (d==NULL)
        exit(1);

    d->central_id = -1;
    d->hvb_id = -1;
    d->hva_id = -1;
    d->lv_id = -1;
    d->company_id = -1;
    d->individual_id = -1;
    d->capacity = -1;
    d->load= -1;
    
    return d;
}


void printData(Data d){
    printf("%d;%d;%d;%d;%d;%d;%d;%d\n", d.central_id,d.hvb_id,d.hva_id,d.lv_id, d.company_id, d.individual_id, d.capacity, d.load);
}

void addCharToStr(char* sentence, char c){
    int n = strlen(sentence);
    sentence[n]=c;
    sentence[n+1]='\0';
}

//TO FIX
void fillData(Data *data ,int number, int value){ // fill a data struct arguments n°number with value
    switch(number){
        case 0: data->central_id = value; break;
        case 1: data->hvb_id = value; break;
        case 2: data->hva_id = value; break;
        case 3: data->lv_id = value; break;
        case 4: data->company_id = value; break;
        case 5: data->individual_id = value; break;
        case 6: data->capacity = value; break;
        case 7: data->load = value; break;
        default : printf("Error too many argument\n"); break;
    }
}


Data *transcript(FILE *file, char *line){
    printf("%s\n", line);
    int cursor = 0; // to "read" the line
    int count = 0; // number of data's argument
    char futureInt[50] = ""; // char* to be converted into int
    Data *data = initData(); // return value

    while (line[cursor] != '\0'){


        printf("%c\n", line[cursor]);
        if(line[cursor] == '-'){ //case undifined
            if (count>7){
                printf("Error too many argument\n");
                free(data);
                exit(2);
            }
            cursor++;
            count++;
        }


        else if(line[cursor] == ';'){ // separator of the data
            if(strlen(futureInt) != 0){ // shouldn't be possible except error in the file
                char *end;
                long value = strtol(futureInt, &end, 10); // transform str ito int
                printf("To put value %d \n", value);
                if (*end != '\0' || value < 0) {
                    printf("Error: invalid value : %s\n", futureInt);
                    free(data);
                    exit(3);
                }

                if (count>7){
                    printf("Error too many argument\n");
                    free(data);
                    exit(2);
                }

                fillData(data,count,value); 
                futureInt[0] = '\0'; // reset str
            }
            count++;
        }


        else{
            addCharToStr(futureInt,line[cursor]);
            printf("Debug ;     %s\n",futureInt);
            }

        cursor++;
        printData(*data);

        }

    // Last data without ; at the end
    if (strlen(futureInt) > 0) {
        char *end;
        long value = strtol(futureInt, &end, 10);
        if (*end != '\0' || value < 0) {
            printf("Error: invalid value: %s\n", futureInt);
            free(data);
            exit(3);
        }
        fillData(data, count, value);
    }

    return data;
    }


void main(){
    FILE* file = NULL;
    file = fopen("C:/Users/PC/Downloads/c-wire00.dat", "r+");
    if (file == NULL){
        printf("Imposible to open file\n");
        printf("Error code = %d \n", errno );
        printf("Error message = %s \n", strerror(errno) );
        exit(1);
    }
    char sentence[85];
    fgets(sentence,83,file); // first line is 83 caracteres long
    fgets(sentence,49,file);

    Data *test1 = transcript(file, sentence);
    printData(*test1);

    fclose(file);
}