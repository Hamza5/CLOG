#include <stdio.h>
#include "TS.h"
#include "fonctions_semantiques.h"
extern unsigned short errors;
void declaration_variable(const char * entite, const char type, const char nature, const unsigned short taille){
	if(rechercher(entite)){
		errors++;
		printf("Erreur sémantique : %s a été déja déclarée !\n", entite);
	}
	else
		inserer(entite, type, nature, taille);
	}