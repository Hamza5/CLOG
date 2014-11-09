#ifndef TS
#define TS
typedef struct elements {char nom[40]; char type; char nature; unsigned short taille;} element;
// nom : AND 25.5 (-2) ; Idf "Programme" 'Y' ...
// type : K (Mot-clé), I (Identificateur), S (Séparateur), O (Opérateur), N (Entier), F (Décimal), C (Caractère), T (Chaîne de caractères)
// nature : C (Constante), V (Variable)
// taille : en octets

typedef struct r{
   element elm;
struct r *svt;}liste;

liste * rechercher(const char * entite);
void inserer(const char * entite, const char type, const char nature, const unsigned short taille);
void afficher();
#endif