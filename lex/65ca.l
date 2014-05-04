%option noyywrap yylineno nodefault

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
	printf("S");
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
	printf("DF(%d)", yylineno);
}

[ \t]*=[ \t]* {
	printf(" EQ ");
}

\$[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] {
	printf("GA");
}

\$[0-9a-fA-F][0-9a-fA-F] {
	printf("ZA");
}

[a-zA-Z][a-zA-Z0-9_]* {
	printf("NAME");
}





%%

