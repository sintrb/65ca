/**
label.h
Robin 2014-05-15
**/
#include "segment.h"

t_map segments = NULL;

struct segment * curdefseg = NULL;
struct segment * curseg = NULL;
void segment_init(){
	segments = map_newmap();
}

struct segment *segment_new(){
	struct segment * seg = (struct segment *)MALLOC(sizeof(struct segment));
	seg->filepos = filepos_curpos();
	seg->name = NULL;
	seg->fill = 0;
	seg->start = 0;
	seg->size = 0;
	seg->index = 0;

	seg->data = NULL;
	seg->flag = NULL;

	return seg;
}


t_value segment_write(struct segment *seg, t_value val){
	if(seg->index>=seg->size){
		M_ERROR("out of segment(%s) size(%d)", seg->name, seg->size);
	}
	seg->data[seg->index] = (unsigned char)(0x00ff&val);
	seg->flag[seg->index] = 1;
	++seg->index;
}

void segment_setaddr(struct segment *seg, t_value addr){
	if(addr<seg->start || addr>=(seg->start+seg->size)){
		M_ERROR("out of segment(%s) address(%04x-%04x)", seg->name, seg->start, seg->start+seg->size-1);
	}
	seg->index = addr-seg->start;
}

void segment_detail(struct segment *seg){
	int i;
	O("{%s st:%04x sz:%d fil:%02x ix:%d addr:%04x}\n\t", seg->name, seg->start, seg->size, seg->fill, seg->index, seg->start+seg->index);
	for(i=0; i<seg->size; ++i){
		if(i!=0 && i%16==0)
			O("\n\t");
		if(i==seg->index)
			O("|");
		else
			O(" ");
		if(seg->flag[i])
			O("%02x", seg->data[i]);
		else
			O("xx");
	}
	O("\n");
}
