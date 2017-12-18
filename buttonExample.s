    .set GPBASE, 0x3f200000
    .set GPSEL0, 0x00
    .set GPSEL1, 0x04
    .set GPSET0, 0x1c
    .set GPLEV0, 0x34
    .set GPCLR0, 0x28

.text
        ldr r0, =GPBASE
    @ BIT MASK: 0bxx999888777666555444333222111000
        mov r1, 0b00001000000000000000000000000000
        str r1, [r0, #GPSEL0]
    @ BIT MASK: 0b10987654321098765432109876543210
        mov r1, 0b00000000000000000000001000000000
        str r1, [r0, #GPSET0]
    @ BIT MASK: 0bxx999888777666555444333222111000
        mov r1, 0b00000000000000000000000000000001
        str r1, [r0, #GPSEL1]
    @ BIT MASK: 0b10987654321098765432109876543210
        mov r1, 0b00000000000000000000010000000000
        str r1, [r0, #GPSET0]
    @ mask for GPIO2 input
        mov r2, 0b00000000000000000000000000000100
        mov r3, 0b00000000000000000000000000001000
loop:
        ldr r4, [r0, #GPLEV0]
        tst r4, r2
        bl shutDownL
        tst r4, r3
        bl shutDownR
inf:    b inf


shutDownL:
        push {lr, r4}
        mov r1, 0b00000000000000000000010000000000
        str r1, [r0, #GPCLR0]
        pop {lr, r4}
        bx lr

shutDownR:
        push {lr, r4}
        mov r1, 0b00000000000000000000001000000000
        str r1, [r0, #GPSET0]
        pop {lr, r4}
        bx lr
