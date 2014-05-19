/**
fileio.c
Robin 2014-05-19
**/

#include "fileio.h"
#include "functions.h"

FILE *fileio_open(const char *filename, const char *type){
	FILE *fp = fopen(filename, type);
	if(!fp){
		M_ERROR("open %s failed", filename);
	}
	return fp;
}
