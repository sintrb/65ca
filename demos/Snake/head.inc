.defseg  name = HEAD size = 16 start = 0 fill = 0
.defseg  name = ROM size = 16*1024-6 start = $c000 fill = 0
.defseg  name = VECTOR size = 6 start = $fffa fill = 0
.defseg  name = VROM size = $2000 start = 0 fill = 0

.seg HEAD
.dat #$4e #$45 #$53 #$1A
.dat #$01
.dat #$01

.seg VROM
.incbin "ascii_2.chr"


.seg VECTOR
.dat start start start

.seg ROM
