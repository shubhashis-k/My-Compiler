%{
#include "test.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}


%%
[0-9]+ 				{ yylval = atoi(yytext); return INT;}

"("|")"|"{"|"}"		{ return *yytext;		}
minus				{ return MINUS;		}
plus 				{ return PLUS;		}	
mul 				{ return MULTIPLY; 	}
div					{ return DIV;		}
pow 				{ return POWER; 	}
assign				{ return ASSIGN;    }
fac 				{ return FAC; 		}
_show				{ return SHOW;		}
[.] 				{ return *yytext; 	}
[a-z]				{ yylval = *yytext;  return VAR;}
[ \t]
[\n]
. yyerror("Unknown ");
%%


int yywrap(void) {
printf("called yywrap\n");
return 1;
}

int main(void) {
	yyin = fopen("input", "r");
	yyparse();
}
