%option noyywrap yylineno

%{
#include<stdio.h>
#include "65ca.tab.h"
#define YYINPUT()	yyinput()

%}



%%

\n[\t\n\r]* {
	printf("\n");
}

\"[^\"]*\" {
	// printf("S");
	return STRING;
}

"/*" {
	int c1=0, c2=0;
	for(;;) {
		c2 = YYINPUT();
		if(c2 == EOF)
			break;
		if(c1 == '*' && c2 == '/')
			break;
		c1 = c2;
	}
}

"//" {
	int c = 0;
	while(c != '\n' && c != EOF)
		c = YYINPUT();
}

".define" {
	// printf("DF(%d)", yylineno);
	return DEFINE;
}

[ \t]*=[ \t]* {
	// printf(" EQ ");
	return EQU;
}

\$[0-9a-fA-F]{4} {
	// printf("ADDR");
	return ADDR;
}

\$[0-9a-fA-F]{2} {
	// printf("ZPADDR");
	return ZPADDR;
}

[a-zA-Z][a-zA-Z0-9_]* {
	// printf("LABEL");
	return LABEL;
}


%%

