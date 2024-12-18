#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "avl.h"
#include "data.h"

int main(){
    FILE* file = NULL;
    //file = fopen("C:/Users/PC/Downloads/c-wire00.dat", "r+");
    file = fopen("tmp/fichier_filtre.csv", "r+");
    if (file == NULL){
        printf("Imposible to open file\n");
        printf("Error code = %d \n", errno );
        printf("Error message = %s \n", strerror(errno) );
        return 1 ;
    }

    
    char sentence[85];
    //creer fichier sorti

    Data *d;
    AVL *a = NULL;

    while (fgets(sentence,49,file) != NULL){
        d = transcript(file, sentence);
        if (d==NULL)
            return 1;
        if(insertAVL(&a,*d)) // error detected
            return 1;
    }
    
    //recup donner dans arbre et mettre dans le fihier de sorti
    //fermer fichier de sorti

    FILE* result_file;
    result_file = fopen("result.txt", "w");
    if (file == NULL) {
        printf("Imposible to open file\n");
        printf("Error code = %d \n", errno );
        printf("Error message = %s \n", strerror(errno) );
        return 1;
    }

    fclose(file);

    AVLtoFile(a, result_file); // view results
    deleteTree(&a);
    
    fclose(result_file);
    return 0;
}
