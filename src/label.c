/**
label.c
Robin 2014-05-07
**/

#include "label.h"

t_map labels = NULL;

void label_init(){
	labels = map_newmap();
}

struct valobj *label_newval(t_token tk, t_value val){
	t_valobj* to = ((t_valobj*)malloc(sizeof(t_valobj)));
	to->token = tk;
	to->value = val;
	to->label = NULL;
	to->refcount = 1;
	return to;
}

struct label * label_new(){
	struct label *lab = (struct label *)malloc(sizeof(struct label));
	lab->name = NULL;
	lab->filepos = filepos_curpos();
	lab->val = NULL;
	lab->status = LABEL_STATUS_KNOWN;
	return lab;
}

struct labeltask *label_newtask(){
	struct labeltask * tsk =(struct labeltask *)MALLOC(sizeof(struct labeltask));
	tsk->filepos = filepos_curpos();
	tsk->segment = curseg;
	tsk->addr = curseg->start + curseg->index;
	return tsk;
}

struct label * label_get(const char *name, t_bool autoadd){
	struct mapnode * node = map_get(labels, name);
	struct label *lab = NULL;
	if(!node){
		if(autoadd){
			lab = label_new();
			lab->name = str_clone(name);
			lab->filepos = filepos_curpos();
			lab->status = LABEL_STATUS_UNKNOWN;

			lab->val = label_newval(ADDR, 0);
			lab->val->label = lab;
			node = map_put(labels, name, lab);
		}
		else{
			M_ERROR("unknow labale: %s", name);
		}
	}
	else{
		lab = (struct label *)node->data;
	}
	return lab;
}

void label_addtask(struct label *lab, struct labeltask *tsk){
	if(!lab->tasks){
		lab->tasks = list_newlist();
	}
	list_add(lab->tasks, tsk);
}

void label_detail(struct label * lab){
	O("{%s v:%04x ref:%d kwn:%c}\n", lab->name, lab->val->value, lab->val->refcount, lab->status == LABEL_STATUS_KNOWN?'Y':'N');
	if(lab->tasks){
		struct listnode * next;
		struct labeltask * task;
		list_each(struct labeltask *, lab->tasks, next, task, D("\tseg:%s addr:$%04x %s(%d)\n", task->segment->name, task->addr, task->filepos.filename, task->filepos.lineno));
		O("\n");
	}
}
