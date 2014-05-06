#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2014-05-05 12:08:18
# @Author  : Robin
# @Version : 1.0

import re
import random

f = open("../doc/instructions.txt")
ls = f.readlines()
f.close()

hex='0123456789ABCDEF'
def byte():
	return '%s%s'%(random.choice(hex), random.choice(hex))

def word():
	return '%s%s'%(byte(), byte())

def genasms():
	for l in ls:
		rs = re.findall("([A-Z]{3})\t(.*)\t0x[0-9a-f]{1,2}\t[0-9]\t[A-Z]*", l)
		if not rs:
			continue
		ins = rs[0][0]
		addr = rs[0][1].lower()
		
		if '$xxxx' in addr:
			addr = addr.replace('$xxxx', '$%s'%word())
		elif '$xx' in addr:
			addr = addr.replace('$xx', '$%s'%byte())
		print '%s %s'%(ins.lower(), addr.lower())

if __name__ == '__main__':
	genasms()