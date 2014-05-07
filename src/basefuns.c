/**
basefuns.c
Robin 2014-05-06
**/

#include "basefuns.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MALLOC
#define MALLOC malloc
#endif

// begin link
t_link link_newlink(int size){
	return link_newnode(size);
}
struct linknode * link_newnode(int size){
	struct linknode * node = (struct linknode *)MALLOC(size);
	node->next = NULL;
	return node;
}
struct linknode * link_addnew(t_link link, int size){
	struct linknode * node = (struct linknode *)MALLOC(size);
	node->next = link->next;
	link->next = node;
	return node;
}

// end link


// begin string

int str_hash(const char *s)
{
	int hash = 0;
	while(*s){
		hash += *((unsigned char*)s);
		++s;
	}
	return hash;
}


char *str_clone(const char *s){
	char *ns = (char*)MALLOC(strlen(s)+1);
	strcpy(ns, s);
	return ns;
}

// end string


// begin trans
int btoi(const char *s){
	int ret = 0;
	while(*s){
		ret <<= 1;
		if(*s == '1')
			ret |= 0x01;
		else if(*s != '0')
			break;
		++s;
	}
	return ret;
}

int htoi(const char *s){
	int ret = 0;
	while(*s){
		ret <<= 4;
		if(*s >= '0' && *s <= '9')
			ret |= (*s)-'0';
		else if(*s >= 'a' && *s <= 'f')
			ret |= (*s)-'a' + 10;
		else if(*s >= 'A' && *s <= 'F')
			ret |= (*s)-'A' + 10;
		else
			break;
		++s;
	}
	return ret;
}
// end trans



// begin map
t_map map_newmap(){
	return (t_map)link_newlink(sizeof(struct mapnode));
}
struct mapnode * map_put(t_map map, const char *key, void * data){
	struct mapnode * node = map_get(map, key);
	if(!node){
		node = (struct mapnode*)link_addnew((t_link)map, sizeof(struct mapnode));
		node->key = str_clone(key);
	}
	node->data = data;
	return node;
}
struct mapnode * map_get(t_map map, const char *key){
	struct mapnode * next;
	link_find(t_map, map, next, strcmp(key, next->key)==0);
	return next;
}
void * map_val(t_map map, const char *key){
	struct mapnode * next;
	link_find(t_map, map, next, strcmp(key, next->key)==0);
	return next != NULL ? next->data : NULL;
}
// end map
