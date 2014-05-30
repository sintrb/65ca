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
#include "fileio.h"
#include "incfile.h"

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
	incfile_init();
	if(infile)
		cmd_inc(infile);
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
	if(!val){
		// lab:
		// address label
		newval = label_newval(ADDR, CURADDR);
	}
	else{
		newval = label_newval(val->token, val->value);
	}
	if(node){
		// already define
		lab = (struct label *)node->data;
		if(lab->status == LABEL_STATUS_KNOWN){
			M_ERROR("label \"%s\" defined at %s(%d)", lab->name, lab->filepos.filename, lab->filepos.lineno);
		}
		else{
			lab->filepos = filepos_curpos();
			lab->status = LABEL_STATUS_KNOWN;
			lab->val = newval;
			label_dotask(lab);
		}
	}
	else{
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
	struct filestate * top = (struct filestate *)stack_top(files);
	pos.filename = top?top->name:NULL;
	pos.lineno = curlineno;
	return pos;
}

void ins_compile(t_token ins, struct valobj *val){
	struct insobj * io = NULL;
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
				label_addtask(val->label, label_newtask(io->addr));
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
				label_addtask(val->label, label_newtask(io->addr));
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
				label_addtask(val->label, label_newtask(io->addr));
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
	if(name==NULL){
		struct filepos pos = filepos_curpos();
		O("file:%s line:%d segment:%s\n", pos.filename, pos.lineno, curseg?curseg->name:"NONE");
		return;
	}
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


void cmd_dat(t_list list){
	struct listnode * next;
	struct valobj * val;
	char * str;
	M_CHECKCURSEG();
	list_each(struct valobj *, list, next, val, {
		D("%04x ", val->value);
		switch(val->token){
			case NUM:
			case ZPADDR:{
				if(!val->label || val->label->status == LABEL_STATUS_KNOWN){
					segment_write(curseg, val->value);
				}
				else{
					// add task
					label_addtask(val->label, label_newtask(val->token));
					segment_skip(curseg, 1);
				}
				break;
			}
			case ADDR:{
				if(!val->label || val->label->status == LABEL_STATUS_KNOWN){
					segment_write(curseg, val->value&0x00ff);
					segment_write(curseg, val->value>>8);
				}
				else{
					// add task
					label_addtask(val->label, label_newtask(val->token));
					segment_skip(curseg, 2);
				}
				break;
			}
			case STR:{
				str = val->label->name + 1;
				while(*(str+1)){
					segment_write(curseg, *str&0x00ff);
					++str;
				}
				segment_write(curseg, 0);
				break;
			}
			default:{
				M_ERROR("unknow data token(%d)", val->token);
			}
		}
	});
	O("\n");
}


void cmd_inc(const char *name){
	struct filestate * fs = NULL;
	struct filestate * top = (struct filestate *)stack_top(files);
	fs = (struct filestate*)MALLOC(sizeof(struct filestate));
	fs->name = fileio_abspath(top?top->name:NULL, name);
	fs->file = fileio_open(fs->name, "r");
	fs->state = yy_create_buffer(fs->file, YY_BUF_SIZE);
	fs->lineno = 1;
	
	if(top){
		top->lineno = yyget_lineno();
	}
	yyset_lineno(fs->lineno);
	yy_switch_to_buffer(fs->state);
	yyrestart(fs->file);

	stack_push(files, fs);
}

void cmd_eof(){
	struct filestate * fs = (struct filestate *)stack_pop(files);
	if(fs){
		fclose(fs->file);
		yy_delete_buffer(fs->state);
		FREE(fs->name);
		FREE(fs);
	}
	fs = (struct filestate *)stack_top(files);
	if(fs){
		// back to file
		yyset_lineno(fs->lineno);
		yy_switch_to_buffer(fs->state);
		yyin = fs->file;
	}
	else{
		// end
		char *name = fileio_abspath(NULL, outfile);
		FILE *fp = fileio_open(name, "wb");
		FREE(name);
		struct mapnode * next;
		struct segment *seg;
		link_each(t_map, segments, next, {
			seg = (struct segment *)(next->data);
			fwrite(seg->data, 1, seg->size, fp);
			D("--->%s\n", seg->name);
		});
		fclose(fp);


		FREE(infile);
		FREE(outfile);
		printf("compile success!!!\n");
		exit(0);
	}
}
