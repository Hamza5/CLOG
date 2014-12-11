%{
#include <stdio.h>
#include "fonctions_semantiques.h"
#include <string.h>
extern FILE * yyin;
extern ts;
extern unsigned short line, column;
extern unsigned short errors;
extern int yyleng;
char type;
char identifier[9];
%}
%union{
	int entier;
	float decimal;
	char * entite;
}
%token <entite> IDENTIFIER
%token <entier> INTEGER
%type <entite> type
%left OR
%left AND
%left NOT
%left COMP_OPERATOR
%left PLUS MINUS
%left STAR SLASH
%left OPEN_PARENT CLOSE_PARENT
%token FLOAT CHAR STRING CONST VECTOR TYPE_INTEGER TYPE_FLOAT TYPE_CHAR TYPE_STRING IF ELSE FOR END READ DISPLAY SEMICOLON OPEN_ACO CLOSE_ACO EQUAL DOUBLE_DOT OPEN_BRACE CLOSE_BRACE COMMA AT PIPE
%start S
%%
S : IDENTIFIER OPEN_ACO OPEN_ACO var_dec CLOSE_ACO OPEN_ACO code CLOSE_ACO CLOSE_ACO;
var_dec :
			beginning_var sep /* Variables */
			| beginning_const SEMICOLON var_dec /* Constante */
			| beginning_vector CLOSE_BRACE SEMICOLON var_dec /* Tableau */
			|;
beginning_var : type DOUBLE_DOT IDENTIFIER  { type = $1[0]; declaration_variable($3, type, 'V', 1); };
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
					type = $3[0];
				};
sep : center_var sep | SEMICOLON var_dec;
value : INTEGER | FLOAT | CHAR | STRING;
type : TYPE_INTEGER { $$ = "N"; }| TYPE_FLOAT { $$ = "F"; } | TYPE_CHAR { $$ = "C"; } | TYPE_STRING { $$ = "T"; };
code : instruction code | ;
instruction : affectation | function | condition | loop ;
function :
			READ OPEN_PARENT STRING DOUBLE_DOT AT idf_vec CLOSE_PARENT SEMICOLON {
			} /* Fonction READ */
			| DISPLAY OPEN_PARENT STRING DOUBLE_DOT idf_vec CLOSE_PARENT SEMICOLON; /* Fonction DISPLAY */
loop : FOR OPEN_PARENT IDENTIFIER DOUBLE_DOT arithmetic_expression DOUBLE_DOT arithmetic_expression CLOSE_PARENT code END;
arithmetic_expression :
			OPEN_PARENT arithmetic_expression CLOSE_PARENT |
			arithmetic_expression PLUS arithmetic_expression | arithmetic_expression MINUS arithmetic_expression | /* A + B | A - B */
			arithmetic_expression STAR arithmetic_expression | arithmetic_expression SLASH arithmetic_expression | /* A * B | A / B */
			INTEGER | FLOAT | idf_vec;
idf_vec : IDENTIFIER | IDENTIFIER OPEN_BRACE arithmetic_expression CLOSE_BRACE ;
condition : IF OPEN_PARENT logic_expression CLOSE_PARENT DOUBLE_DOT code else; /* IF avec ou sans ELSE */
else : ELSE DOUBLE_DOT code END | END;
logic_expression :
			OPEN_PARENT logic_expression CLOSE_PARENT | logic_expression OR logic_expression | /* (L) | L OR M */
			logic_expression AND logic_expression | NOT logic_expression | comparison; /* L AND M | NOT L */
comparison : expression COMP_OPERATOR expression; /* C < D | C <= D | C > D | C >= D | C == D | C != D */
affectation : idf_vec EQUAL expression SEMICOLON;
expression : arithmetic_expression | CHAR | STRING;
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