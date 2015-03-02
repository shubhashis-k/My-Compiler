%{
#include <stdio.h>
#include <math.h>
void yyerror(char *);
int yylex(void);
int values[255];
%}

%token MINUS PLUS MULTIPLY POWER PAREN INT DIV FAC VAR SHOW IFS

%left ASSIGN
%left PLUS MINUS
%left MULTIPLY DIV
%nonassoc IFS

%%
program: program statement 				
|		 /* NULL */							
;
statement: 	exp '.'
|			SHOW VAR '.' 					{printf("%d\n", values[$2]);}
|			IfStatement '.'					{printf("if executed\n");}								
;
exp: 		INT											
| 			exp MULTIPLY exp 							{printf("1\n"); $$ = $1 * $3; }
|			Variable MULTIPLY exp                		{printf("2\n"); $$ = values[$1] * $3;}
|			Variable MULTIPLY Variable                	{printf("3\n"); $$ = values[$1] * values[$3];}
|			exp MULTIPLY Variable                		{printf("4\n"); $$ = $1 * values[$3];}
| 			exp PLUS exp 								{printf("5\n"); $$ = $1 + $3; }
|			Variable PLUS exp                			{printf("6\n"); $$ = values[$1] + $3;}
|			Variable PLUS Variable                		{printf("7\n"); $$ = values[$1] + values[$3];}
|			exp PLUS Variable                			{printf("8\n"); $$ = $1 + values[$3];}
| 			exp MINUS exp 								{printf("9\n"); $$ = $1 - $3; }
|			Variable MINUS exp                			{printf("10\n"); $$ = values[$1] - $3;}
|			Variable MINUS Variable                		{printf("11\n"); $$ = values[$1] - values[$3];}
|			exp MINUS Variable                			{printf("12\n"); $$ = $1 - values[$3];}
| 			exp DIV exp 								{printf("13\n"); $$ = $1 / $3; }
|			Variable DIV exp                			{printf("14\n"); $$ = values[$1] / $3;}
|			Variable DIV Variable                		{printf("15\n"); $$ = values[$1] / values[$3];}
|			exp DIV Variable                			{printf("16\n"); $$ = $1 / values[$3];}
|			Variable ASSIGN exp							{printf("17\n"); values[$1] = $3; printf("value of %c is %d\n",$1, values[$1]);}																	
|			Variable ASSIGN Variable                 	{printf("18\n"); values[$1] = values[$3]; printf("value of %c is %d\n",$1, values[$1]);} 
;
Variable:		VAR
;
IfStatement:	IFS '(' exp ')' '{' statement '}'		{if($3) {$$}}
%%
void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}