/**
define.c
Robin 2014-05-05
**/
#include "define.h"
#include "functions.h"

linetype curlinetype = LINETYPE_NORMAL;

void yyerror(const char *err)
{
	M_ERROR("%s",err);
}

struct valobj *valobj_new(t_token tk, t_value val){
	t_valobj* to = ((t_valobj*)malloc(sizeof(t_valobj)));
	to->token = tk;
	to->value = val;
	to->name = NULL;
	to->label = NULL;
	to->status = VALOBJ_STATUS_KNOWN;
	to->refcount = 1;
	return to;
}

