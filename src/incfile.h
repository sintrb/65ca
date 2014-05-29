/**
incfile.h
Robin 2014-05-28
**/

#ifndef INCFILE_H
#define INCFILE_H

#include "define.h"
#include "basefuns.h"
#include "functions.h"
#include "segment.h"
#include "lex.yy.h"



struct filestate
{
	char *name;
	FILE *file;
	YY_BUFFER_STATE state;
};

extern t_stack files;


void incfile_init();












#endif
