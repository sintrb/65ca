/**
functions.c
Robin 2014-05-05
**/

#include <stdio.h>

#include "define.h"
#include "basefuns.h"
#include "functions.h"
#include "label.h"


t_val curval = 0x00;
t_val curaddr = 0x0000;
char * curfile = "test.asm";
char curident[256];

FILE *fp = NULL;

const char *ofile = "output.bin";


t_map labels = NULL;


void init(){
	labels = map_newmap();
}

void destory(){
	if(fp){
		fclose(fp);
		fp = NULL;
	}
}


void writeout(t_val v){
	unsigned char buf[1];
	v &= 0x00ff;
	if(!fp){
		fp = fopen(ofile, "wb");
		if(!fp){
			fprintf(stderr, "open %s for write fail\n", ofile);
			exit(1);
		}
	}


	D("[%02x]", v);

	buf[0] = (unsigned char)v;
	fwrite(buf, 1, 1,  fp);

	++curaddr;
}



t_val cal_readdr(t_val nowaddr, t_val tagaddr){
	t_val bt;
	if(tagaddr > nowaddr && (tagaddr - nowaddr) <= 256){
		bt = tagaddr - nowaddr - 1;
	}
	else if(tagaddr <= nowaddr && (nowaddr - tagaddr) <= 255){
		bt = 0x00ff - (nowaddr - tagaddr);
	}
	else{
		M_ERROR("%04x out of address range %04x-%04x", tagaddr, nowaddr-128, nowaddr+128);
	}
}


struct label * cmd_label(const char *name, t_val val, yytokentype token){
	struct mapnode * node = map_get(labels, name);
	struct label *lab = NULL;
	// D("cmd_label(%s) ", name);
	if(node){
		lab = (struct label *)node->data;
		M_ERROR("label \"%s\" defined at %s(%d)", name, lab->filepos.filename, lab->filepos.lineno);
	}
	else{
		lab = label_new();
		lab->name = str_clone(name);
		lab->token = token;
		lab->val = val;
		node = map_put(labels, name, lab);
	}
}


yytokentype token_label(const char *name){
	struct label * lab = (struct label *) map_val(labels, name);
	if(!lab){
		return IDENT;
	}
	else{
		D("has %s",name);
		curval = lab->val;
		return lab->token;
	}
}

struct filepos filepos_curpos(){
	struct filepos pos;
	pos.filename = str_clone(curfile);
	pos.lineno = curlineno;
	return pos;
}





