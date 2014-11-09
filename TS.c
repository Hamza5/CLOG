#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include "TS.h"

liste * tete = NULL;
liste *p;
liste * rechercher(const char * entite){
    liste *q;
	q=tete;
    for(;q!=NULL && strcmp(q->elm.nom,entite);q=q->svt);
	return  q; // Entité trouvée ou NULL
}
char * type_str(char t);
void inserer(const char * entite, const char type, const char nature, const unsigned short taille){
    liste *q;
    liste * position = rechercher(entite);
   if(position==NULL){ // Nouvelle entité

         if(tete==NULL){
                p=(liste*)malloc(sizeof(liste));
                strcpy(p->elm.nom,entite); // Insérer le nom de l'entité
                p->elm.type = type; // Insérer le type de l'entité
                p->elm.nature = nature; // Insérer la nature de l'entité
                p->elm.taille = taille; // Insérer la taille de l'entité
                tete=p;
                p->svt=NULL;
       }
         else { q=(liste*)malloc(sizeof(liste));
                p->svt=q;
                strcpy(q->elm.nom,entite); // Insérer le nom de l'entité
                q->elm.type = type; // Insérer le type de l'entité
                q->elm.nature = nature; // Insérer la nature de l'entité
                q->elm.taille = taille; // Insérer la taille de l'entité
                q->svt=NULL;
                p=q;
                 }  // Insérer l'entité


	}


}
void afficher(){
    liste *v;
    v=tete;
	printf("---------------------------------------.---------------------.-------.\n");
	printf("|%-39s|%-21s|%s|\n","Nom","Type","Taille");
	printf("---------------------------------------.---------------------.-------.\n");
	while(v!=NULL){
        printf("|%-39s|%-21s|%7d|\n", v->elm.nom, type_str(v->elm.type), v->elm.taille);
		printf("---------------------------------------.---------------------.-------.\n");
        v=v->svt;
    }
}
char * type_str(char t){
	switch(t){
		case 'K':
			return "Mot-clé";
		case 'I':
			return "Identificateur";
		case 'S':
			return "Séparateur";
		case 'O':
			return "Opérateur";
		case 'N':
			return "Entier";
		case 'F':
			return "Décimal";
		case 'C':
			return "Caractère";
		case 'T':
			return "Chaine de caractères";
	}
}