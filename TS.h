#ifndef TS
#define TS
typedef struct elements {char nom[40]; char type; char nature; unsigned short taille;} element;
// nom : Identificateur
// type : N (Entier), F (Décimal), C (Caractère), T (Chaîne de caractères)
// nature : C (Constante), V (Variable), T (Vecteur)
// taille : 1 ou taille de tableau

typedef struct r{
	element elm;
	struct r *svt;
}liste;

liste * rechercher(const char * entite);
void inserer(const char * entite, const char type, const char nature, const unsigned short taille);
void afficher();
char * nature_str(char n);
char * type_str(char t);
#endif