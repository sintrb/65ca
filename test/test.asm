.org $8000

.lab REG = $2000 // 直接寻址地址
.lab OFF = #$00 // 立即数寻址

.lab ON = %00001111 // 立即数寻址，二进制

loop: // 地址标签
lda OFF
sta REG
lda ON
sta REG
jmp loop


lda >$1234
lda <$1234

lda >REG
lda <REG

// 快捷方式创建标签
REG2 = $2001

lda REG
sta REG2

