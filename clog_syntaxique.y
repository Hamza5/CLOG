%{
#include <stdio.h>
extern FILE * yyin;
extern ts;
extern unsigned short line, column;
%}
%union{
	int entier;
	float decimal;
	char * entite;
}
%token INTEGER FLOAT CHAR STRING TYPE COMP_OPERATOR ARITH_OPERATOR LOGIC_OPERATOR FUNCTION IF ELSE FOR END IDENTIFIER CONST VECTOR
%token SEMICOLON OPEN_ACO CLOSE_ACO OPEN_PARENT CLOSE_PARENT EQUAL DOUBLE_DOT OPEN_BRACE CLOSE_BRACE COMMA AT PIPE
%start S
%%
S : IDENTIFIER OPEN_ACO OPEN_ACO var_dec CLOSE_ACO OPEN_ACO code CLOSE_ACO CLOSE_ACO;
var_dec :
			TYPE DOUBLE_DOT IDENTIFIER sep | /* Variable */
			CONST DOUBLE_DOT IDENTIFIER EQUAL value SEMICOLON var_dec | /* Constante */
			VECTOR DOUBLE_DOT TYPE DOUBLE_DOT IDENTIFIER OPEN_BRACE INTEGER COMMA INTEGER CLOSE_BRACE SEMICOLON var_dec /* Tableau */
			|;
sep : PIPE IDENTIFIER sep | SEMICOLON var_dec;
value : INTEGER | FLOAT | CHAR | STRING;
code : ;
%%
int yyerror(char * message){
	printf("Erreur syntaxique : ligne %u colonne %u\n", line, column);
}
int main(int argc, char * argv[]){
	if(argc > 1){
		int i;
		for(i=1; i<argc; i++){
			printf("\nAnalyse lexical & syntaxique du fichier %s\n", argv[i]);
			yyin = fopen(argv[i],"r");
			yyparse();
			afficher();
		}
	}
	else printf("Usage : %s 'Chemin_du_fichier'\n", argv[0]);
	return 0;
}