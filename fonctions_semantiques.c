#include <stdio.h>
#include "TS.h"
#include "fonctions_semantiques.h"
extern unsigned short errors;
void declaration_variable(const char * entite, const char type, const char nature, const short taille){
	if(rechercher(entite)){
		errors++;
		fprintf(stderr, "Erreur sémantique : %s a été déja déclarée !\n", entite);
	}
	else{
		if(nature=='T' && taille<1){
			errors++;
			fprintf(stderr, "Erreur sémantique : %s vecteur de taille inférieur à 1 !\n", entite);
			return;
		}
		inserer(entite, type, nature, taille);
	}
}
