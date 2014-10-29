#include <TS.h>
typedef struct {char nom[10]; char type; char nature; unsigned short taille;} element;
element TS[500]; // Le tableau de symbols
unsigned short fin = 0;
int rechercher(const char * entite){
	for(int i=0; i<fin && strcmp(TS[i].nom,entite)!=0; i++); // Parcourir le tableau de début jusqu'à le dernière entité
	if(i==fin) return -1; // Entité non trouvée
	else return i; // L'indice de l'entité
}
void inserer(const char * entite){
	int position = rechercher(entite);
	if(position==-1){ // Nouvelle entité
		fin++;
		strcpy(TS[fin].nom,entite); // Insérer l'entité
	}
	else{}
}
