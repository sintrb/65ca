/**
define.h
Robin 2014-05-05
**/

#ifndef DEFINE_H
#define DEFINE_H

#include <stdio.h>
#include <stdlib.h>


#define DEBUG_MODE 1

#define YYINPUT()	yyinput()


#ifdef DEBUG_MODE
	#define D printf
#else
	#define D 
#endif


extern char *yytext;

typedef unsigned int t_val;



// trans
#define M_BETWEEN(_v, _min, _max) ((_v)>=(_min) && (_v)<=(_max))
#define M_HEXV(_h) (M_BETWEEN(_h,'0','9')?((_h)-'0'):(M_BETWEEN(_h,'a','f')?((_h)-'a'+10):(M_BETWEEN(_h,'A','F')?(_h)-'A'+10:0)))
#define M_BYTE(_s) (((M_HEXV(*(_s)) & 0x000f)<<4) | (M_HEXV(*((_s)+1)) & 0x000f))
#define M_WORD(_s) ((M_BYTE(_s)<<8) | (M_BYTE(_s+2)))
#endif

