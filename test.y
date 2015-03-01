%{
#include <stdio.h>
#include <math.h>
void yyerror(char *);
int yylex(void);
int Variable[255];
%}

%token MINUS PLUS MULTIPLY POWER PAREN INT DIV FAC VAR SHOW
%right VAR 
%nonassoc ASSIGN
%left PLUS MINUS
%left MULTIPLY DIV

%%
program: program statement 				
|		 /* NULL */							
;
statement: 	exp '.'
|			SHOW VAR '.' 					{printf("%d\n", Variable[$2]);}								
;
exp: 		INT											
| 			exp MULTIPLY exp 				{ $$ = $1 * $3; }
|			VAR MULTIPLY exp                { $$ = Variable[$1] * $3;}
|			VAR MULTIPLY VAR                { $$ = Variable[$1] * Variable[$3];}
|			VAR ASSIGN exp					{ Variable[$1] = $3; printf("value of %c is %d\n",$1, Variable[$1]);}																	
|			VAR ASSIGN VAR                  { Variable[$1] = Variable[$3]; printf("value of %c is %d\n",$1, Variable[$1]);} 
;
%%
void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}