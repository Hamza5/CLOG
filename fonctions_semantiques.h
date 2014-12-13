#ifndef fs
#define fs
void declaration_variable(const char * entite, const char type, const char nature, const short taille);
int verifierDeclaration(const char * variable);
char verifierCompatibiliteArithmetique(char type1, char type2);
int verifierCompatibiliteAffectation(char type1, char type2);
int verifierIndiceVecteur(char type);
int validerFormatRead(char * format, char type);
int validerFormatDisplay(char * format, char type);
int verifierCompatibiliteComparaison(char type1, char type2);
#endif
