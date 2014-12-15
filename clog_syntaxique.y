%{
#include <stdio.h>
#include "fonctions_semantiques.h"
#include "TS.h"
#include <string.h>
extern FILE * yyin;
extern ts;
extern unsigned short line, column;
extern unsigned short errors;
extern int yyleng;
char type;
char identifier[9];
char * format;
char buff[100];
%}
%union{
	int entier;
	float decimal;
	char * entite;
	char caractere;
}
%token <entite> IDENTIFIER
%token <entier> INTEGER
%token <caractere> FLOAT
%token <entite> STRING
%type <caractere> type
%type <caractere> idf_vec
%type <caractere> suite_idf_vec
%type <caractere> beginning_idf_vec
%type <caractere> arithmetic_expression
%type <caractere> expression
%type <entite> beginning_read
%type <entite> beginning_display
%left OR
%left AND
%left NOT
%left COMP_OPERATOR
%left PLUS MINUS
%left STAR SLASH
%left OPEN_PARENT CLOSE_PARENT
%token CHAR CONST VECTOR TYPE_INTEGER TYPE_FLOAT TYPE_CHAR TYPE_STRING IF ELSE FOR END READ DISPLAY SEMICOLON OPEN_ACO CLOSE_ACO EQUAL DOUBLE_DOT OPEN_BRACE CLOSE_BRACE COMMA AT PIPE
%start S
%%
S : IDENTIFIER OPEN_ACO OPEN_ACO var_dec CLOSE_ACO OPEN_ACO code CLOSE_ACO CLOSE_ACO;
var_dec :
			beginning_var sep /* Variables */
			| beginning_const SEMICOLON var_dec /* Constante */
			| beginning_vector CLOSE_BRACE SEMICOLON var_dec /* Tableau */
			|;
beginning_var : type DOUBLE_DOT IDENTIFIER  { type = $1; /* Sauvegarder le type dans la variable globale type */ declaration_variable($3, type, 'V', 1); }; // $3 = le non terminal type, et sa valeur vient de la règle type. $1 = IDENTIFIER.
center_var : PIPE IDENTIFIER { declaration_variable($2, type, 'V', 1); }; // $2 = IDENTIFIER . C'est le cas de plusieurs variables avec le même type.
beginning_const : suite_const EQUAL value { // La partie affectation d'une constante.
						declaration_variable(identifier, '\0', 'C', 1); // La variable global identifier contient le nom de la constante, elle prend sa valeur dans la règle suite_const.
					};
suite_const : CONST DOUBLE_DOT IDENTIFIER { strcpy(identifier, $3); }; // $3 = IDENTIFIER . Sauvegarder le nom de la constante dans la variable identifier.
beginning_vector : suite_vector OPEN_BRACE INTEGER COMMA INTEGER { // $5 = le 2ème INTEGER qui représente la taille du vecteur.
						declaration_variable(identifier, type, 'T', $5); // La valeur de identifier vient de la règle suite_vector.
					};
suite_vector : VECTOR DOUBLE_DOT type DOUBLE_DOT IDENTIFIER {
					strcpy(identifier,$5); // Sauvegarder le nom du vecteur dans la variable identifier
					type = $3; // Sauvegarder le type du vecteur dans la variable type
				};
sep : center_var sep | SEMICOLON var_dec; // La 1ère règle pour ajouter un autre variable avec le même type, la 2ème pour mettre un point-virgule et retourner à la déclaration des variables.
value : INTEGER | FLOAT | CHAR | STRING; // Les valeurs : soit entier, soit décimal, soit caractère, ou bien chaine de caractères.
type : TYPE_INTEGER { $$ = 'N'; }| TYPE_FLOAT { $$ = 'F'; } | TYPE_CHAR { $$ = 'C'; } | TYPE_STRING { $$ = 'T'; }; // type = 'N' si entier, 'F' si décimal, 'C' si caractère, 'T' si chaine de caractères.
code : instruction code | ;
instruction : affectation | function | condition | loop ;
function :
			beginning_read DOUBLE_DOT AT idf_vec CLOSE_PARENT SEMICOLON { validerFormatRead($1, $4); /* La valeur $1 vient de la règle beginning_read, $4 vient de la règle idf_vec */ } /* Fonction READ */
			| beginning_display DOUBLE_DOT idf_vec CLOSE_PARENT SEMICOLON { validerFormatDisplay($1, $3); /* Idem pour DISPLAY */ }; /* Fonction DISPLAY */
beginning_read : READ OPEN_PARENT STRING { $$ = $3; }; // On affecte la valeur du STRING à beginning_read.
beginning_display : DISPLAY OPEN_PARENT STRING { $$ = $3; }; // Idem pour beginning_display
loop : FOR OPEN_PARENT IDENTIFIER DOUBLE_DOT arithmetic_expression DOUBLE_DOT arithmetic_expression CLOSE_PARENT code END; // Boucle FOR.
arithmetic_expression : // Expression arithmétique
			OPEN_PARENT arithmetic_expression CLOSE_PARENT { $$ = $2; } // expression arithmétique entre parenthèses.
			| arithmetic_expression PLUS arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; /* '\0' est retourné si les 2 opérands sont incompatibles. 'return' pour arrêter l'analyseur sémantique */ Quad("+","cx","bx","cx");$$ = typeResultat; }
			| arithmetic_expression MINUS arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; Quad("-","cx","bx","cx"); $$ = typeResultat; }
			| arithmetic_expression STAR arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3);if(typeResultat=='\0') return; Quad("*","cx","bx","cx");  $$ = typeResultat; }
			| arithmetic_expression SLASH arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; Quad("/","cx","bx","cx"); $$ = typeResultat; }
			| INTEGER { sprintf(buff,"%d",yylval.entier); Quad(":=",buff,"v","bx"); $$ = 'N';}
			| FLOAT { sprintf(buff,"%.2f",yylval.decimal); Quad(":=",buff,"v","bx"); $$ = 'F';}
			| idf_vec { $$ = $1; Quad(":=",buff,"v","bx");};
idf_vec : beginning_idf_vec { $$ = $1; } | suite_idf_vec CLOSE_BRACE { $$ = $1; } ; // 1ère règle pour un identificateur simple, 2ème pour référencer un élément d'un vecteur.
suite_idf_vec : beginning_idf_vec OPEN_BRACE arithmetic_expression {
				verifierIndiceVecteur($3); // Vérifier si le type de l'indice d'un vecteur est un entier.
				$$ = $1;
			};
beginning_idf_vec : IDENTIFIER { if(!verifierDeclaration($1)) return; /* Arrêter l'analyseur si la variable n'est pas déclararée */ sprintf(buff,"%s",yylval.entite); $$ = rechercher($1)->elm.type; };
condition : IF OPEN_PARENT logic_expression CLOSE_PARENT DOUBLE_DOT code else; /* L'instruction de condition IF */
else : ELSE DOUBLE_DOT code END | END; /* Avec ou sans ELSE */
logic_expression : // Expression logique
			OPEN_PARENT logic_expression CLOSE_PARENT | logic_expression OR logic_expression | /* (L) | L OR M */
			logic_expression AND logic_expression | NOT logic_expression | comparison; /* L AND M | NOT L */
comparison : expression COMP_OPERATOR expression { verifierCompatibiliteComparaison($1, $3); }; /* C < D | C <= D | C > D | C >= D | C == D | C != D */
affectation : idf_vec EQUAL expression SEMICOLON { if(!verifierCompatibiliteAffectation($1, $3)) return; Quad(":=",buff,"v","bx"); };
expression : arithmetic_expression { $$ = $1; } | CHAR { $$ = 'C'; } | STRING { $$ = 'T'; };
%%
int yyerror(char * message){
	errors++;
	printf("Erreur syntaxique : ligne %u colonne %u : %s\n", line, column, yylval.entite);
	return 1;
}
int main(int argc, char * argv[]){
	if(argc > 1){
		int i;
		for(i=1; i<argc; i++){
			printf("\nAnalyse lexical & syntaxique du fichier %s\n", argv[i]);
			yyin = fopen(argv[i],"r");
			yyparse();
			if(errors==0){
				printf("Analyse terminée. Aucune erreur n'est trouvée.\n");
				afficher();
				afficher_quadr();
			}
		}
	}
	else printf("Usage : %s 'Chemin_du_fichier'\n", argv[0]);
	return 0;
}
