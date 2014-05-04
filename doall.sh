#!/bin/bash


rm -rf lex
mkdir lex
cd lex
wget http://172.16.0.100:8000/lex/65ca.l
wget http://172.16.0.100:8000/lex/65ca.y