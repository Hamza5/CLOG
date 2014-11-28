%{
#include <stdio.h>
extern FILE * yyin;
extern ts;
extern unsigned short line, column;
extern unsigned short errors;
%}
%union{
	int entier;
	float decimal;
	char * entite;
}
%left OR
%left AND
%left NOT
%left COMP_OPERATOR
%left PLUS MINUS
%left STAR SLASH
%left OPEN_PARENT CLOSE_PARENT
%token INTEGER FLOAT CHAR STRING CONST VECTOR TYPE IDENTIFIER IF ELSE FOR END READ DISPLAY SEMICOLON OPEN_ACO CLOSE_ACO EQUAL DOUBLE_DOT OPEN_BRACE CLOSE_BRACE COMMA AT PIPE
%start S
%%
S : IDENTIFIER OPEN_ACO OPEN_ACO var_dec CLOSE_ACO OPEN_ACO code CLOSE_ACO CLOSE_ACO;
var_dec :
			TYPE DOUBLE_DOT IDENTIFIER sep | /* Variables */
			CONST DOUBLE_DOT IDENTIFIER EQUAL value SEMICOLON var_dec | /* Constante */
			VECTOR DOUBLE_DOT TYPE DOUBLE_DOT IDENTIFIER OPEN_BRACE INTEGER COMMA INTEGER CLOSE_BRACE SEMICOLON var_dec /* Tableau */
			|;
sep : PIPE IDENTIFIER sep | SEMICOLON var_dec;
value : INTEGER | FLOAT | CHAR | STRING;
code : instruction code | ;
instruction : affectation | function | condition | loop ;
function :
			READ OPEN_PARENT STRING DOUBLE_DOT AT IDENTIFIER CLOSE_PARENT SEMICOLON | /* Fonction READ */
			DISPLAY OPEN_PARENT STRING DOUBLE_DOT IDENTIFIER CLOSE_PARENT SEMICOLON; /* Fonction DISPLAY */
loop : FOR OPEN_PARENT IDENTIFIER DOUBLE_DOT arithmetic_expression DOUBLE_DOT arithmetic_expression CLOSE_PARENT code END;
arithmetic_expression :
			OPEN_PARENT arithmetic_expression CLOSE_PARENT |
			arithmetic_expression PLUS arithmetic_expression | arithmetic_expression MINUS arithmetic_expression | /* A + B | A - B */
			arithmetic_expression STAR arithmetic_expression | arithmetic_expression SLASH arithmetic_expression | /* A * B | A / B */
			IDENTIFIER | INTEGER | FLOAT;
condition : IF OPEN_PARENT logic_expression CLOSE_PARENT DOUBLE_DOT code else; /* IF avec ou sans ELSE */
else : ELSE DOUBLE_DOT code END | END;
logic_expression :
			OPEN_PARENT logic_expression CLOSE_PARENT | logic_expression OR logic_expression | /* (L) | L OR M */
			logic_expression AND logic_expression | NOT logic_expression | comparison; /* L AND M | NOT L */
comparison : expression COMP_OPERATOR expression; /* C < D | C <= D | C > D | C >= D | C == D | C != D */
affectation : IDENTIFIER EQUAL expression SEMICOLON;
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