.include "base.inc"
@ Exercise 2
.text
        ldr sp, =0x8000000
        ldr r0, =GPFBASE
    @ BIT MASK:  0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        str r1, [r0, #GPFSEL0]
    @ BIT MASK:  0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        str r1, [r0, #GPFSET0]
    @ BIT MASK:  0bxx999888777666555444333222111000
        mov r1, #0b00000000000000000000000000000001
        str r1, [r0, #GPFSEL1]
    @ BIT MASK:  0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000010000000000
        str r1, [r0, #GPFSET0]
        mov r3, #0b00000000000000000000000000001000
        mov r2, #0b00000000000000000000000000000100
loop:
        ldr r4, [r0, #GPLEV0]
        tst r4, r2
        bleq shutDownL
        tst r4, r3
        bleq shutDownR
        b loop

shutDownL:
        push {r4}
        ldr r0, =GPFBASE
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        str r1, [r0, #GPCLR0]
        pop {r4}
        bx lr

shutDownR:
        push {r4, lr}
        ldr r0, =GPFBASE
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000010000000000
        str r1, [r0, #GPCLR0]
        pop {r4, lr}
        bx lr
