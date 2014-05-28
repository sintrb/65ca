.inc def.asm

// 使用代码段
.seg ROM




// 地址标签


lda go,x
go:
.dat #$ff "i love you"

.info ROM

