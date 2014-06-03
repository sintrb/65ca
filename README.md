# 65ca
A 6502CPU Assembler.
一个6502系列处理器的汇编程序。

## 说明

### 环境说明
目前整个项目都是在Windows上面开发的

* Windows 上面所需的flex bison gcc 可以去这[下载](http://pan.baidu.com/s/1hqHt4OG)
* 大部分自动工具都使用Python编写，如果需要运行请安装Python 2.x （推荐2.7.3） [下载](https://www.python.org/downloads/)
 
### 结构说明

* make.bat 自动执行flex、bison、gcc来生成编译器65ca.exe，并使用test/test.asm来测试生成的编译器
* clean.bat 自动清除执行不必要的中间文件
* bin/ 该目录存放生成的65ca.exe
* doc/ 该目录存放开发相关的文档
* gen/ 该目录存放一些自动化的工具脚本（主要是Python的）
* lex/ 该目录存放词法文件65ca.l 和 语法文件65ca.y
* src/ 该目录存放C语言写的一些源代码
* test/ 该目录存放测试相关的文件、脚本


## 版本说明

### V1.1.2

时间：2014-06-03

说明：

* 修改计算相对路径bug
* 添加包含二进制文件 .incbin

用例：

```
.defseg name=HEAD size=16 fill=#$00 start=0 //HEAD
.defseg name=PROM size=32*1024 fill=#$00 start=0 // PROM, 32K
.defseg name=VROM size=8*1024 fill=#$00 start=0 // PROM, 32K
.inc "common.asm"
.seg HEAD
.dat $#4E $#45 $#53 $#1A $#02 $#01 $#03 $#00 $#00 $#00 $#00 $#00 $#00 $#00 $#00 $#00

.seg PROM // 选择PROM
start:
 lda #$0
 sta $00
 jmp start

.org $fffa
.dat start start


.seg VROM // 选择VROM
.incbin "ascii.chr" // 保护二进制文件
```


### V1.1.2

时间：2014-05-30

说明：

* 增加指定参数的功能（-h 查看帮助）
* 文件包含功能 .inc
* 代码段定义 .defseg
* 使用功能 .seg
* 显示信息 .info [标签/代码段]
* 标签提前使用功能
* 写数据功能 .dat 标签/字符串/值 [, 标签/字符串/值] ..
* 其他很多....


### V1.1

时间：2014-05-07

说明：

* 增加.ORG的支持
* 增加标签的支持
* 标签使用前必须先申明(也就是现在暂时不能跳转到后面的地址标签)
* 标签使用举例

用例：

```
.org $8000 // 起始地址为$8000

.lab REG = $2000 // 直接寻址地址
.lab OFF = #$00 // 立即数寻址与%00000000(二进制)、0(十进制)相等
.lab ON = %00001111 // 立即数寻址，二进制

loop: // 地址标签
lda OFF
sta REG
lda ON
sta REG
jmp loop

```

=

### V1.0

时间：2014-05-06

说明：

* 完成对6502汇编的最基本支持
* 没有支持代码起始位置定义功能，从$0000地址开始
* 编译后的机器码输出到output.bin中
* 已对全部6502汇编指令进行编译，并与nesa的编译结果对比确认无误
