/**
functions.c
Robin 2014-05-05
**/

#include "define.h"
#include "functions.h"


t_val curval = 0x00;

void writeout(t_val v){
	D("[%02x]", v&0x00ff);
}
