/**
basefuns.h
Robin 2014-05-06
**/

#ifndef BASEFUNS_H
#define BASEFUNS_H

// 链表

struct linknode
{
	struct linknode *next;
};

typedef struct linknode t_linknode;
typedef struct linknode *t_link;

// 创建链表，size为单个链表节点大小
t_link link_newlink(int size);
// 创建新的链表节点
struct linknode * link_newnode(int size);
// 向链表中添加一个节点
struct linknode * link_addnew(t_link link, int size);

// 在链表中查找, _tpye为链表类型，_link为需要操作的链表，_pname为迭代用的变量名称，_cond为终止条件，找到之后节点保存在_pname中
#define link_find(_type, _link, _pname, _cond) \
	_pname = (_type)(((t_link)_link)->next); \
	while(_pname){ \
		if(_cond) \
			break; \
		_pname = (_type)(((t_link)_pname)->next); \
	}

// 对链表进行枚举, _tpye为链表类型，_link为需要操作的链表，_pname为迭代用的变量名称，_handle为需要执行的操作
#define link_each(_type, _link, _pname, _handle) \
	_pname = (_type)(((t_link)_link)->next); \
	while(_pname){ \
		_handle;\
		_pname = (_type)(((t_link)_pname)->next); \
	}
// end 链表










// begin 字符串操作
// 获取字符串哈希值
int str_hash(const char *s);

// 克隆字符串，需要手动释放
char *str_clone(const char *s);


// end 字符串操作


// begin 转换
// 二进制字符串转int
int btoi(const char *s);
// 十六进制转字符串int
int htoi(const char *s);
// 十进制转字符串int
#define otoi(_s) atoi(_s)
// end 转换

// begin Map
struct mapnode
{
	struct linknode *link;
	char * key;
	void * data;
};

typedef struct mapnode * t_map;

// 创建一个新的字符串为键的图
t_map map_newmap();
// 添加数据
struct mapnode * map_put(t_map map, const char *key, void * data);
// 获取节点
struct mapnode * map_get(t_map map, const char *key);
// 获取节点值
void * map_val(t_map map, const char *key);
// end Map


// begin List
struct listnode
{
	struct linknode *link;
	void *data;
};

typedef struct listnode * t_list;

// 创建新列表
t_list list_newlist();

// 添加一项
struct listnode * list_add(t_list list, void *data);


// 对列表中的数据进行枚举, _tpye为列表值类型，_list为需要操作的链表，_pname为迭代用的节点变量名称，_data为数据名称，_handle为需要执行的操作
#define list_each(_type, _link, _pname, _data, _handle) \
	_pname = (struct listnode *)(((t_link)_link)->next); \
	while(_pname){ \
		_data = (_type)_pname->data;\
		_handle;\
		_pname = (struct listnode *)(((t_link)_pname)->next); \
	}

// end List



#endif
