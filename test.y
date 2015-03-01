%{
#include <stdio.h>
#include <math.h>
void yyerror(char *);
int yylex(void);
int Variable[255];
%}

%token MINUS PLUS MULTIPLY POWER PAREN INT DIV FAC VAR SHOW

%left ASSIGN
%left PLUS MINUS
%left MULTIPLY DIV VAR


%%
program: program statement 				
|		 /* NULL */							
;
statement: 	exp '.'
|			SHOW VAR '.' 					{printf("%d\n", Variable[$2]);}								
;
exp: 		INT											
| 			exp MULTIPLY exp 				{printf("1\n"); $$ = $1 * $3; }
|			VAR MULTIPLY exp                {printf("2\n"); $$ = Variable[$1] * $3;}
|			VAR MULTIPLY VAR                {printf("3\n"); $$ = Variable[$1] * Variable[$3];}
|			exp MULTIPLY VAR                {printf("4\n"); $$ = $1 * Variable[$3];}
| 			exp PLUS exp 					{printf("5\n"); $$ = $1 + $3; }
|			VAR PLUS exp                	{printf("6\n"); $$ = Variable[$1] + $3;}
|			VAR PLUS VAR                	{printf("7\n"); $$ = Variable[$1] + Variable[$3];}
|			exp PLUS VAR                	{printf("8\n"); $$ = $1 + Variable[$3];}
| 			exp MINUS exp 					{printf("9\n"); $$ = $1 - $3; }
|			VAR MINUS exp                	{printf("10\n"); $$ = Variable[$1] - $3;}
|			VAR MINUS VAR                	{printf("11\n"); $$ = Variable[$1] - Variable[$3];}
|			exp MINUS VAR                	{printf("12\n"); $$ = $1 - Variable[$3];}
| 			exp DIV exp 					{printf("13\n"); $$ = $1 / $3; }
|			VAR DIV exp                		{printf("14\n"); $$ = Variable[$1] / $3;}
|			VAR DIV VAR                		{printf("15\n"); $$ = Variable[$1] / Variable[$3];}
|			exp DIV VAR                		{printf("16\n"); $$ = $1 / Variable[$3];}
|			VAR ASSIGN exp					{printf("17\n"); Variable[$1] = $3; printf("value of %c is %d\n",$1, Variable[$1]);}																	
|			VAR ASSIGN VAR                  {printf("18\n"); Variable[$1] = Variable[$3]; printf("value of %c is %d\n",$1, Variable[$1]);} 
;
%%
void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}