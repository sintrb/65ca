/**
basefuns.c
Robin 2014-05-06
**/

#include "basefuns.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// begin link
t_link link_newlink(int size){
	return link_newnode(size);
}
struct linknode * link_newnode(int size){
	struct linknode * node = (struct linknode *)malloc(size);
	node->next = NULL;
	return node;
}
struct linknode * link_addnew(t_link link, int size){
	struct linknode * node = (struct linknode *)malloc(size);
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
	char *ns = (char*)malloc(strlen(s)+1);
	strcpy(ns, s);
	return ns;
}

// end string





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
	link_each(t_map, map, next, printf("%s\n", next->key));

	link_find(t_map, map, next, strcmp(key, next->key)==0);

	
	return next;
}

// end map
