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

void segment_write_at(struct segment *seg, t_value val, t_value addr){
	t_value index;
	if(addr<seg->start || addr>=(seg->start+seg->size)){
		M_ERROR("$%04x out of segment(%s) address(%04x-%04x)", addr, seg->name, seg->start, seg->start+seg->size-1);
	}
	index = addr-seg->start;
	if(seg->flag[index] == SEGMENT_FLAG_WROTE){
		M_WARN("override at {%s $%04x}", seg->name, addr);
	}
	seg->data[index] = (unsigned char)(0x00ff&val);
	seg->flag[index] = SEGMENT_FLAG_WROTE;
}

void segment_write(struct segment *seg, t_value val){
	segment_write_at(seg,val,seg->start + seg->index);
	++seg->index;
}

void segment_setaddr(struct segment *seg, t_value addr){
	if(addr<seg->start || addr>(seg->start+seg->size)){
		M_ERROR("$%04x out of segment(%s) address(%04x-%04x)", addr, seg->name, seg->start, seg->start+seg->size-1);
	}
	seg->index = addr-seg->start;
}

void segment_skip(struct segment *seg, t_value cnt){
	t_value start = seg->index;
	segment_setaddr(seg, seg->start+seg->index+cnt);
	for(;start<seg->index;++start){
		seg->flag[start] = SEGMENT_FLAG_UNKNOWN;
	}
}

void segment_detail(struct segment *seg){
	int i;
	O("{%s st:$%04x sz:%d fil:#$%02x ix:%d addr:$%04x}\n\t", seg->name, seg->start, seg->size, seg->fill, seg->index, seg->start+seg->index);
	for(i=0; i<seg->size; ++i){
		if(i!=0 && i%16==0)
			O("\n\t");
		if(i==seg->index)
			O("|");
		else
			O(" ");
		if(seg->flag[i]==SEGMENT_FLAG_WROTE)
			O("%02x", seg->data[i]);
		else if(seg->flag[i]==SEGMENT_FLAG_RAW)
			O("xx");
		else if(seg->flag[i]==SEGMENT_FLAG_UNKNOWN)
			O("??");
	}
	O("\n");
}
