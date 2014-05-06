# 65ca
A 6502CPU Assembler.
一个6502系列处理器的汇编程序。

## 说明

### 环境说明
目前整个项目都是在Windows上面开发的

* Windows 上面所需的flex bison gcc 可以去这下载[http://pan.baidu.com/s/1hqHt4OG](http://pan.baidu.com/s/1hqHt4OG)
* 大部分自动工具都使用Python编写，如果需要运行请安装Python 2.x （推荐2.7.3） [https://www.python.org/downloads/](https://www.python.org/downloads/)
 
### 结构说明

* make.bat 自动执行flex、bison、gcc来生成编译器65ca.exe，并使用test/test.asm来测试生成的编译器
* clean.bat 自动清除执行不必要的中间文件
* bin/ 该目录存放生成的65ca.exe
* doc/ 该目录存放开发相关的文档
* gen/ 该目录存放一些自动化的工具脚本（主要是Python的）
* lex/ 该目录存放词法文件65ca.l 和 语法文件65ca.y
* src/ 该目录存放C语言写的一些源代码
* test/ 该目录存放测试相关的文件、脚本

