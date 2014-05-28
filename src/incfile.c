/**
incfile.h
Robin 2014-05-28
**/

#include "incfile.h"

t_stack files = NULL;

void incfile_init(){
	files = stack_newstack();
}
