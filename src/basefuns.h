/**
basefuns.h
Robin 2014-05-06
**/

#ifndef BASEFUNS_H
#define BASEFUNS_H

// begin link

struct linknode
{
	struct linknode *next;
};

typedef struct linknode t_linknode;
typedef struct linknode *t_link;


t_link link_newlink(int size);
struct linknode * link_newnode(int size);
struct linknode * link_addnew(t_link link, int size);


#define link_find(_type, _link, _pname, _cond) \
	_pname = (_type)(((t_link)_link)->next); \
	while(_pname){ \
		if(_cond) \
			break; \
		_pname = (_type)(((t_link)_pname)->next); \
	}

#define link_each(_type, _link, _pname, _handle) \
	_pname = (_type)(((t_link)_link)->next); \
	while(_pname){ \
		_handle;\
		_pname = (_type)(((t_link)_pname)->next); \
	}
// end link










// begin string
int str_hash(const char *s);
char *str_clone(const char *s);


// end string


// begin str-value
struct mapnode
{
	struct linknode *link;
	char * key;
	void * data;
};

typedef struct mapnode * t_map;

t_map map_newmap();
struct mapnode * map_put(t_map map, const char *key, void * data);
struct mapnode * map_get(t_map map, const char *key);


// begin map






#endif
