%{
#include <stdio.h>
#include <math.h>

#define PI 3.14159265

void yyerror(char *);
int yylex(void);
int values[255];
%}

%token MINUS PLUS MULTIPLY POWER PAREN INT DIV FAC VAR SHOW IFS ELSE EQUALS SIN COS TAN LOG GREATER LESSER

%nonassoc ASSIGN
%left PLUS MINUS
%left MULTIPLY DIV
%left POWER
%left FAC
%nonassoc IFS
%nonassoc EQUALS GREATER LESSER

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
|			LOG exp '.'						{double x = log($2); printf("Value of ln (%d) is %lf\n", $2, x);}								
;
exp: 		INT											
| 			exp MULTIPLY exp 							{  	$$ = $1 * $3; 																			}
|			Variable MULTIPLY exp                		{  	$$ = values[$1] * $3;																	}
|			Variable MULTIPLY Variable                	{  	$$ = values[$1] * values[$3];															}
|			exp MULTIPLY Variable                		{  	$$ = $1 * values[$3];																	}
| 			exp PLUS exp 								{  	$$ = $1 + $3; 																			}
|			Variable PLUS exp                			{  	$$ = values[$1] + $3;																	}
|			Variable PLUS Variable                		{  	$$ = values[$1] + values[$3];															}
|			exp PLUS Variable                			{  	$$ = $1 + values[$3];																	}
| 			exp MINUS exp 								{  	$$ = $1 - $3; 																			}
|			Variable MINUS exp                			{   $$ = values[$1] - $3;																	}
|			Variable MINUS Variable                		{   $$ = values[$1] - values[$3];															}
|			exp MINUS Variable                			{   $$ = $1 - values[$3];																	}
| 			exp DIV exp 								{   $$ = $1 / $3; 																			}
|			Variable DIV exp                			{   $$ = values[$1] / $3;																	}
|			Variable DIV Variable                		{   $$ = values[$1] / values[$3];															}
|			exp DIV Variable                			{   $$ = $1 / values[$3];																	}
|			Variable ASSIGN exp							{   values[$1] = $3; $$ = $1;																}																	
|			Variable ASSIGN Variable                 	{   values[$1] = values[$3]; $$ = $1;														}
| 			exp EQUALS exp 								{  	$$ = ($1 == $3); 																		}
|			Variable EQUALS exp                			{  	$$ = (values[$1] == $3); 																}
|			Variable EQUALS Variable                	{  	$$ = (values[$1] == values[$3]); 														}
|			exp EQUALS Variable                			{  	$$ = ($1 == values[$3]); 																}
| 			exp GREATER exp 							{  	$$ = ($1 > $3); 																		}
|			Variable GREATER exp                		{  	$$ = (values[$1] > $3); 																}
|			Variable GREATER Variable                	{  	$$ = (values[$1] > values[$3]); 														}
|			exp GREATER Variable                		{  	$$ = ($1 > values[$3]); 																}
| 			exp LESSER exp 								{  	$$ = ($1 < $3); 																		}
|			Variable LESSER exp                			{  	$$ = (values[$1] < $3); 																}
|			Variable LESSER Variable                	{  	$$ = (values[$1] < values[$3]); 														}
|			exp LESSER Variable                			{  	$$ = ($1 < values[$3]); 																}
|			FAC exp										{	int x = $2; int result = 1; while (x > 0) {result = result * x; x--;} $$ = result; 		} 
|			FAC Variable								{	int x = values[$2]; int result = 1; while (x > 0) {result = result * x; x--;} $$ = result; }
|			POWER exp exp 								{   $$ = pow($2, $3); }
|			POWER exp Variable 							{   $$ = pow($2, values[$3]); }
|			POWER Variable exp 							{   $$ = pow(values[$2], $3); }
|			POWER Variable Variable 					{   $$ = pow(values[$2], values[$3]); }
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