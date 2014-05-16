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
#include "segment.h"


// t_value curval = 0x00;
// t_value curaddr = 0x0000;
char * curfile = "test.asm";
char curident[256];

FILE *fp = NULL;

const char *ofile = "output.bin";



void init(){
	instab_init();
	segment_init();
	label_init();
}

void destory(){
	if(fp){
		fclose(fp);
		fp = NULL;
	}
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


struct label * cmd_label(const char *name, struct valobj *val){
	struct mapnode * node = map_get(labels, name);
	struct label *lab = NULL;
	struct valobj *newval = NULL;
	if(node){
		// already define
		lab = (struct label *)node->data;
		if(lab->status == LABEL_STATUS_KNOWN){
			M_ERROR("label \"%s\" defined at %s(%d)", lab->name, lab->filepos.filename, lab->filepos.lineno);
		}
		else{
			lab->filepos = filepos_curpos();
			lab->status = LABEL_STATUS_KNOWN;
			valobj_retain(val);
			lab->val = val;
			label_dotask(lab);
		}
	}
	else{
		if(!val){
			// lab:
			// address label
			newval = label_newval(ADDR, CURADDR);
		}
		else{
			newval = label_newval(val->token, val->value);
		}
		
		lab = label_new();
		lab->val = newval;
		lab->name = str_clone(name);
		lab->filepos = filepos_curpos();

		newval->label = lab;

		node = map_put(labels, name, lab);
		return lab;
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
	if(val && val && val->label && val->label->status != LABEL_STATUS_KNOWN){
		if(val->token == ADDR){
			// add task
			D("PRE(%s)", val->label->name);
		}
		else{
			M_ERROR("unknown name:%s", val->label->name);
		}
	}
	io = instab_get(ins, !val? NONE: val->token);
	if(!io && val && val->token == ADDR){
		io = instab_get(ins, READDR);
	}
	if(!io){
		M_ERROR("sys error ins:%d", ins);
	}
	M_CHECKCURSEG();
	switch(io->addr){
		case NONE:{
			segment_write(curseg, io->code);
			break;
		}
		case NUM:
		case ZPADDR:
		case XZPADDR:
		case YZPADDR:
		case XIDIRADDR:
		case YIDIRADDR:{
			segment_write(curseg, io->code);
			if(!val->label || val->label->status == LABEL_STATUS_KNOWN){
				segment_write(curseg, val->value);
			}
			else{
				// add task
				label_addtask(val->label, label_newtask());
				segment_skip(curseg, 1);
			}
			break;
		}
		case ADDR:
		case XADDR:
		case YADDR:
		case IDIRADDR:{
			segment_write(curseg, io->code);
			if(!val->label || val->label->status == LABEL_STATUS_KNOWN){
				segment_write(curseg, val->value&0x00ff);
				segment_write(curseg, val->value>>8);
			}
			else{
				// add task
				label_addtask(val->label, label_newtask());
				segment_skip(curseg, 2);
			}
			break;
		}
		case READDR:{
			segment_write(curseg, io->code);
			if(!val->label || val->label->status == LABEL_STATUS_KNOWN){
				segment_write(curseg, cal_readdr(CURADDR,val->value));
			}
			else{
				// add task
				label_addtask(val->label, label_newtask());
				segment_skip(curseg, 1);
			}
			break;
		}
		default:{
			M_ERROR("unknow addr token(%d)", io->addr);
		}
	}
}

void cmd_end_defseg(){
	int i;
	if(!curdefseg){
		M_ERROR("some thing wrong: no defseg, but enter cmd_end_defseg");
	}
	if(!curdefseg->name){
		M_ERROR("segment name is invalid");
	}
	
	if(curdefseg->size<=0){
		M_ERROR("segment size is invalid");
	}
	if(curdefseg->start<0){
		M_ERROR("segment start is invalid");
	}
	struct mapnode * node = map_get(segments, curdefseg->name);
	if(node){
		M_ERROR("segment \"%s\" defined at %s(%d)", curdefseg->name, curdefseg->filepos.filename, curdefseg->filepos.lineno);
	}
	// data
	curdefseg->data = (unsigned char*)MALLOC(curdefseg->size);
	for(i=0; i<curdefseg->size; ++i){
		curdefseg->data[i] = curdefseg->fill;
	}
	// flag
	curdefseg->flag = (enum segmentflag*)MALLOC(curdefseg->size*sizeof(enum segmentflag));
	for(i=0; i<curdefseg->size; ++i){
		curdefseg->flag[i] = SEGMENT_FLAG_RAW;
	}
	node = map_put(segments, curdefseg->name, curdefseg);
	if(curseg==NULL){
		curseg =  curdefseg;
	}
	curdefseg = NULL;
}


void cmd_info(const char *name){
	struct mapnode * node = NULL;
	node = map_get(segments, name);
	if(node)
		segment_detail((struct segment*)node->data);

	node = map_get(labels, name);
	if(node)
		label_detail((struct label*)node->data);
}

void cmd_seg(const char *name){
	struct mapnode * node = map_get(segments, name);
	if(node)
		curseg = (struct segment*)node->data;
	else{
		M_ERROR("no such segment %s", name);
	}
}


