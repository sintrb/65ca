/**
label.h
Robin 2014-05-15
**/
#ifndef SEGMENT_H
#define SEGMENT_H

#include "define.h"
#include "basefuns.h"
#include "functions.h"



struct segment
{
	char * name;
	t_value start;
	t_value size;
	t_value fill;
	

	struct filepos filepos;

	unsigned char * data;
};


// 新建代码段
struct segment *segment_new();



extern struct segment * curdefseg;

#endif

