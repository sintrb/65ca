/**
define.h
Robin 2014-05-05
**/

#ifndef DEFINE_H
#define DEFINE_H

#define DEBUG_MODE 1



#define MALLOC(_size) malloc(_size)
#define FREE(_size) free(_pointer)

typedef unsigned int t_value;
typedef unsigned char t_bool;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "basefuns.h"
#include "65ca.tab.h"

#define YYINPUT()	yyinput()

// 逻辑
#define FALSE	0
#define TRUE	(!FALSE)

#ifdef DEBUG_MODE
	#define D printf
#else
	#define D 
#endif

#define YYINPUT()	yyinput()
#define curlineno yylineno
extern char *yytext;
extern int yylineno;
int yylex();
void yyerror(const char *err);

#define M_ERROR(_fmt, _args...) {fprintf(stderr,"error: %s(%d): ", curfile, curlineno); fprintf(stderr, _fmt, ##_args); destory(); exit(1);}



enum linetype
{
	LINETYPE_NORMAL, // 正常状态
	LINETYPE_INSTRUCTION, // 指令
	LINETYPE_DEFSEG // 定义段
};

extern linetype curlinetype;
typedef yytokentype t_token;

// 值类型
struct valobj
{
	t_value value;
	t_token token;
};

typedef struct valobj t_valobj;



#define valobj_del(_vo) free(_vo);_vo=NULL;
struct valobj *valobj_new(t_token tk, t_value val);


#endif

