%{
#include "test.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}


%%
"<>".* 				
"<<"\n*.*\n*">>" 	

[0-9]+ 				{ yylval = atoi(yytext); return INT;}
"("|")"|"{"|"}"		{ return *yytext;		}
_if					{ return IFS;		}
_else				{ return ELSE; 		}
minus				{ return MINUS;		}
plus 				{ return PLUS;		}	
mul 				{ return MULTIPLY; 	}
div					{ return DIV;		}
pow 				{ return POWER; 	}
assign				{ return ASSIGN;    }
equals				{ return EQUALS;    }
greater[ ]than		{ return GREATER;   }
less[ ]than			{ return LESSER;	}
fac 				{ return FAC; 		}
_show				{ return SHOW;		}
sine				{ return SIN; 		}
cosine 				{ return COS;		}
tangent				{ return TAN;		}
logbaseE			{ return LOG;		}
[.] 				{ return *yytext; 	}
[a-zA-Z]			{ yylval = *yytext;  return VAR;}
[ \t]
[\n]
. yyerror("Unknown to me!");
%%


int yywrap(void) {
return 1;
}

int main(void) {
	yyin = fopen("input", "r");
	yyparse();
}
