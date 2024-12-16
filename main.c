#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "avl.h"
#include "data.h"

int main(){
    FILE* file = NULL;
    //file = fopen("C:/Users/PC/Downloads/c-wire00.dat", "r+");
    file = fopen("C:/Users/PC/Downloads/002.dat", "r+");
    //file = fopen("c-wire00.dat", "r+");
    if (file == NULL){
        printf("Imposible to open file\n");
        printf("Error code = %d \n", errno );
        printf("Error message = %s \n", strerror(errno) );
        exit(1);
    }

    
    char sentence[85];
    //creer fichier sorti
    
    fgets(sentence,83,file); // first line is 83 caracteres long and useless

    Data *d;
    AVL *a = NULL;

    while (fgets(sentence,49,file) != NULL){
        d = transcript(file, sentence);
        if (d==NULL)
            return 1;
        if(insertAVL(&a,*d)) // error detected
            return 2;
    }
    
    //recup donner dans arbre et mettre dans le fihier de sorti
    //fermer fichier de sorti
    parcourInfixe(a); // view results
    deleteTree(&a);
    
    fclose(file);
    return 0;
}