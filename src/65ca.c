/**
65ca.c
Robin 2014-05-07
**/

#include "define.h"
#include "functions.h"
int yyparse ();

int main(int arc, char *argv[])
{
	init();
	yyparse();
	destory();
	printf("compile success!!!\n");
	return 0;
}



