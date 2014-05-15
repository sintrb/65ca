/**
define.c
Robin 2014-05-05
**/
#include "define.h"
#include "functions.h"

enum linetype curlinetype = LINETYPE_NORMAL;

void yyerror(const char *err)
{
	M_ERROR("%s",err);
}




