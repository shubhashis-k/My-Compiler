%{
#include "test.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}


%%
[0-9]+ 				{ yylval = atoi(yytext); return INT;}

"("|")"|"{"|"}"		{ return *yytext;		}
_if					{ return IFS;		}
_else				{ return ELSE; }
minus				{ return MINUS;		}
plus 				{ return PLUS;		}	
mul 				{ return MULTIPLY; 	}
div					{ return DIV;		}
pow 				{ return POWER; 	}
assign				{ return ASSIGN;    }
equals				{ return EQUALS;    }
fac 				{ return FAC; 		}
_show				{ return SHOW;		}
sine				{ return SIN; 		}
cosine 				{ return COS;		}
tangent				{ return TAN;		}
logbaseten			{ return LOG;		}
[.] 				{ return *yytext; 	}
[a-z]				{ yylval = *yytext;  return VAR;}
[ \t]
[\n]
. yyerror("It's a mystory.");
%%


int yywrap(void) {
return 1;
}

int main(void) {
	//yyin = fopen("input", "r");
	yyparse();
}
