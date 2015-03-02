%{
#include <stdio.h>
#include <math.h>

#define PI 3.14159265

void yyerror(char *);
int yylex(void);
int values[255];
%}

%token MINUS PLUS MULTIPLY POWER PAREN INT DIV FAC VAR SHOW IFS ELSE EQUALS SIN COS TAN LOG

%nonassoc ASSIGN
%left PLUS MINUS
%left MULTIPLY DIV
%left FAC
%nonassoc IFS
%nonassoc EQUALS

%%
program: program statement 				
|		 /* NULL */							
;
statement: 	exp '.'
|			SHOW VAR '.' 					{printf("Value of %c is %d\n", $2, values[$2]);}
|			IfStatement '.'	
|			SIN exp '.'						{double x = sin ($2*PI/180); printf("Value of sin(%d) is %lf\n", $2, x);}
|			COS exp '.'						{double x = cos ($2*PI/180); printf("Value of cos(%d) is %lf\n", $2, x);}
|			TAN exp '.'						{double x = tan ($2*PI/180); printf("Value of tan(%d) is %lf\n", $2, x);}
|			LOG exp '.'						{double x = log10($2); printf("Value of log10 (%d) is %lf\n", $2, x);}								
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
|			Variable ASSIGN exp							{printf("17\n"); values[$1] = $3; printf("value of %c is %d\n",$1, values[$1]); $$ = $1;}																	
|			Variable ASSIGN Variable                 	{printf("18\n"); values[$1] = values[$3]; printf("value of %c is %d\n",$1, values[$1]); $$ = $1;}
| 			exp EQUALS exp 								{printf("1\n"); $$ = ($1 == $3); }
|			Variable EQUALS exp                			{printf("2\n"); $$ = (values[$1] == $3); }
|			Variable EQUALS Variable                	{printf("3\n"); $$ = (values[$1] == values[$3]); }
|			exp EQUALS Variable                			{printf("4\n"); $$ = ($1 == values[$3]); }
|			FAC exp										{int x = $2; int result = 1; while (x > 0) {result = result * x; x--;} $$ = result; } 
|			FAC Variable								{int x = values[$2]; int result = 1; while (x > 0) {result = result * x; x--;} $$ = result; } 
;
Variable:		VAR
;
IfStatement:	IFS '(' exp ')' '{' statement '}'									{if(!($3)){values[$6] = 0;}}
|				IFS '(' exp ')' '{' statement '}' ELSE '{' statement '}'			{if(($3)){values[$10] = 0;}else{values[$6] = 0;}}
;
%%
void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}