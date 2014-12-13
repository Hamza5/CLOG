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
beginning_var : type DOUBLE_DOT IDENTIFIER  { type = $1; declaration_variable($3, type, 'V', 1); };
center_var : PIPE IDENTIFIER { declaration_variable($2, type, 'V', 1); };
beginning_const : suite_const EQUAL value {
						declaration_variable(identifier, '\0', 'C', 1);
					};
suite_const : CONST DOUBLE_DOT IDENTIFIER { strcpy(identifier, $3); };
beginning_vector : suite_vector OPEN_BRACE INTEGER COMMA INTEGER {
						declaration_variable(identifier, type, 'T', $5);
					};
suite_vector : VECTOR DOUBLE_DOT type DOUBLE_DOT IDENTIFIER {
					strcpy(identifier,$5);
					type = $3;
				};
sep : center_var sep | SEMICOLON var_dec;
value : INTEGER | FLOAT | CHAR | STRING;
type : TYPE_INTEGER { $$ = 'N'; }| TYPE_FLOAT { $$ = 'F'; } | TYPE_CHAR { $$ = 'C'; } | TYPE_STRING { $$ = 'T'; };
code : instruction code | ;
instruction : affectation | function | condition | loop ;
function :
			beginning_read DOUBLE_DOT AT idf_vec CLOSE_PARENT SEMICOLON { validerFormatRead($1, $4); } /* Fonction READ */
			| DISPLAY OPEN_PARENT STRING DOUBLE_DOT idf_vec CLOSE_PARENT SEMICOLON; /* Fonction DISPLAY */
beginning_read : READ OPEN_PARENT STRING { $$ = $3; };
loop : FOR OPEN_PARENT IDENTIFIER DOUBLE_DOT arithmetic_expression DOUBLE_DOT arithmetic_expression CLOSE_PARENT code END;
arithmetic_expression :
			OPEN_PARENT arithmetic_expression CLOSE_PARENT { $$ = $2; }
			| arithmetic_expression PLUS arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; $$ = typeResultat; }
			| arithmetic_expression MINUS arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; $$ = typeResultat; }
			| arithmetic_expression STAR arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; $$ = typeResultat; }
			| arithmetic_expression SLASH arithmetic_expression { char typeResultat = verifierCompatibiliteArithmetique($1, $3); if(typeResultat=='\0') return; $$ = typeResultat; }
			| INTEGER { $$ = 'N';} | FLOAT { $$ = 'F'; } | idf_vec { $$ = $1; };
idf_vec : beginning_idf_vec { $$ = $1; } | suite_idf_vec CLOSE_BRACE { $$ = $1; } ;
suite_idf_vec : beginning_idf_vec OPEN_BRACE arithmetic_expression {
				verifierIndiceVecteur($3);
				$$ = $1;
			};
beginning_idf_vec : IDENTIFIER { if(!verifierDeclaration($1)) return; $$ = rechercher($1)->elm.type; };
condition : IF OPEN_PARENT logic_expression CLOSE_PARENT DOUBLE_DOT code else; /* IF avec ou sans ELSE */
else : ELSE DOUBLE_DOT code END | END;
logic_expression :
			OPEN_PARENT logic_expression CLOSE_PARENT | logic_expression OR logic_expression | /* (L) | L OR M */
			logic_expression AND logic_expression | NOT logic_expression | comparison; /* L AND M | NOT L */
comparison : expression COMP_OPERATOR expression; /* C < D | C <= D | C > D | C >= D | C == D | C != D */
affectation : idf_vec EQUAL expression SEMICOLON { verifierCompatibiliteAffectation($1, $3); };
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
			}
		}
	}
	else printf("Usage : %s 'Chemin_du_fichier'\n", argv[0]);
	return 0;
}