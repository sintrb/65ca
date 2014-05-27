/**
fileio.h
Robin 2014-05-19
**/

#ifndef FILEIO_H
#define FILEIO_H
#define MAX_FILEPATH 512
#include "define.h"
#include "functions.h"

// 打开文件
FILE *fileio_open(const char *filename, const char *type);

// 获取绝对路径
char *fileio_abspath(const char *base, const char *relative);
#endif
