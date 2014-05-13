#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2014-05-13 17:48:18
# @Author  : Robin
# @Version : 1.0

'''
自动生成6502汇编指令表赋值语句
'''

import re

f = open("../doc/instructions.txt")
ls = f.readlines()
f.close()

def getngram():
	print '/* BEGIN: Gen by geninstable.py */'
	for l in ls:
		rs = re.findall("([A-Z]{3})\t.*\t(0x[0-9a-f]{1,2})\t[0-9]\t([A-Z]*)", l)
		if not rs:
			continue
		ins = rs[0][0].upper()
		addr = rs[0][2].upper()
		ccode = rs[0][1]
		if not addr:
			addr = 'NONE'
		print 'INIT_INS(%s,%s,%s);\t//%s'%(ins,addr,ccode,l.replace('\t', ' ').strip('\n'))
	print '/* END: Gen by geninstable.py */'
if __name__ == '__main__':
	getngram()