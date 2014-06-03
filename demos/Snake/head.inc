.defseg  name = HEAD size = 16 start = 0 fill = 0
.defseg  name = ROM size = 16*1024 start = $c000 fill = 0
.defseg  name = VECTOR size = 6 start = $fffa fill = 0
.defseg  name = VROM size = $2000 start = 0 fill = 0

.seg HEAD
.dat #$4e #$45 #$53 #$1A	//"NES^Z"
.dat #$01	//
.dat #$01 //

.seg VROM	//选择代码段为字模
.incbin "ascii_2.chr"	//包含二进制字模数据ascii.chr


.seg VECTOR	//设置代码段为中断向量的代码段
.info
.dat start start start
