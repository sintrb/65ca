/**
label.c
Robin 2014-05-07
**/

#include "label.h"

t_map labels = NULL;


struct label * label_new(){
	struct label *lab = (struct label *)malloc(sizeof(struct label));
	lab->name = NULL;
	lab->filepos = filepos_curpos();
	return lab;
}



struct label * label_get(const char *name, t_bool autoadd){
	struct mapnode * node = map_get(labels, name);
	struct label *lab = NULL;
	if(!node){
		lab = label_new();
		lab->name = str_clone(name);
		lab->filepos = filepos_curpos();
		node = map_put(labels, name, lab);
	}
	else{
		lab = (struct label *)node->data;
	}
	return lab;
}

