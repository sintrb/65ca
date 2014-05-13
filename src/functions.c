/**
functions.c
Robin 2014-05-05
**/

#include <stdio.h>

#include "define.h"
#include "basefuns.h"
#include "functions.h"
#include "label.h"
#include "instab.h"


// t_value curval = 0x00;
t_value curaddr = 0x0000;
char * curfile = "test.asm";
char curident[256];

FILE *fp = NULL;

const char *ofile = "output.bin";


t_map labels = NULL;


void init(){
	instab_init();
	labels = map_newmap();
}

void destory(){
	if(fp){
		fclose(fp);
		fp = NULL;
	}
}


void writeout(t_value v){
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



t_value cal_readdr(t_value nowaddr, t_value tagaddr){
	t_value bt;
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


struct label * cmd_label(struct valobj *nval, struct valobj *val){
	struct mapnode * node = NULL;
	struct label *lab = NULL;
	if(!nval->name){
		M_ERROR("sys err");
	}
	else if(nval->status == VALOBJ_STATUS_KNOWN){
		// already define
		node = map_get(labels, nval->name);
		lab = (struct label *)node->data;
		D("OO");
		M_ERROR("label \"%s\" defined at %s(%d)", lab->name, lab->filepos.filename, lab->filepos.lineno);
	}
	else{
		lab = label_new();
		lab->name = str_clone(nval->name);
		lab->filepos = filepos_curpos();
		valobj_retain(val);
		node = map_put(labels, lab->name, lab);
	}
}

struct filepos filepos_curpos(){
	struct filepos pos;
	pos.filename = str_clone(curfile);
	pos.lineno = curlineno;
	return pos;
}

void ins_compile(t_token ins, struct valobj *val){
	struct insobj * io = NULL;
	if(val && val->status != VALOBJ_STATUS_KNOWN){
		M_ERROR("unknown name:%s", val->name?val->name:"");
	}
	io = instab_get(ins, !val? NONE: val->token);
	if(!io && val->token == ADDR)
		io = instab_get(ins, READDR);
	if(!io){
		M_ERROR("sys error ins:%d", ins);
	}
	switch(io->addr){
		case NONE:{
			M_WRITE_CMD(io->code);
			break;
		}
		case NUM:
		case ZPADDR:
		case XZPADDR:
		case YZPADDR:
		case XIDIRADDR:
		case YIDIRADDR:{
			M_WRITE_BYTE(io->code, val->value);
			break;
		}
		case ADDR:
		case XADDR:
		case YADDR:
		case IDIRADDR:{
			M_WRITE_WORD(io->code, val->value);
			break;
		}
		case READDR:{
			M_WRITE_REL(io->code, val->value);
			break;
		}
		default:{
			M_ERROR("unknow addr(%d)", io->addr);
		}
	}
}




