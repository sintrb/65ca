#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2014-05-06 01:08:18
# @Author  : Robin
# @Version : 1.0

'''
自动生成6502汇编语法规则。
依赖于../doc/instructions.txt文件，该文件从../doc/instructions.xls文件中复制得到。
'''

import re

f = open("../doc/instructions.txt")
ls = f.readlines()
f.close()


def getngram():
	addrmap = {
		"byte" : ["byte", "{ M_WRITEBYTE(%s); }"],
		"addr" : ["addr", "{ M_WRITEWORD(%s); }"],
		"zpaddr" : ["zpaddr", "{ M_WRITEBYTE(%s); }"],
		"xzpaddr" : ["xzpaddr", "{ M_WRITEBYTE(%s); }"],
		"yzpaddr" : ["yzpaddr", "{ M_WRITEBYTE(%s); }"],
		"xaddr" : ["xaddr", "{ M_WRITEWORD(%s); }"],
		"yaddr" : ["yaddr", "{ M_WRITEWORD(%s); }"],
		"idiraddr" : ["idiraddr", "{ M_WRITEWORD(%s); }"],
		"xidiraddr" : ["xidiraddr", "{ M_WRITEBYTE(%s); }"],
		"yidiraddr" : ["yidiraddr", "{ M_WRITEBYTE(%s); }"],
		"readdr" : ["addr", "{ M_WRITEREL(%s); }"],
		"" : ["", "{ M_WRITECMD(%s); }"],
	}

	flag = True

	print 'instruction'
	for l in ls:
		rs = re.findall("([A-Z]{3})\t.*\t(0x[0-9a-f]{1,2})\t[0-9]\t([A-Z]*)", l)
		if not rs:
			continue
		ins = rs[0][0].upper()
		addr = rs[0][2].lower()
		ccode = addrmap[addr][1]%rs[0][1]
		print flag and "\t:" or "\t|",ins,addrmap[addr][0],ccode
		flag = False

	print ';'


if __name__ == '__main__':
	getngram()