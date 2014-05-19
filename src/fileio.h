/**
fileio.h
Robin 2014-05-19
**/

#ifndef FILEIO_H
#define FILEIO_H

#include "define.h"
#include "functions.h"

FILE *fileio_open(const char *filename, const char *type);

#endif