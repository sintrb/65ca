/**
label.c
Robin 2014-05-07
**/

#include "label.h"


struct label * label_new(){
	struct label *lab = (struct label *)malloc(sizeof(struct label));
	lab->name = NULL;
	lab->filepos = filepos_curpos();
	return lab;
}
