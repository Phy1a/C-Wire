#include <stdio.h>
#include <stdlib.h>

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


Data transcript (FILE *file, int line){

}

void main(){
    //FILE* fopen("c-wire00.dat", "r+");
}