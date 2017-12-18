.include "base.inc"
@ Exercise 3
.text
        ldr sp, =0x8000000
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        str r1, [r0, #GPFSEL0]
        ldr r2, =500000 @ DELAY
        ldr r3, =STBASE
loop:
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        str r1, [r0, #GPFSET0]
        bl wait
        str r1, [r0, #GPCLR0]
        bl wait
        b loop

wait:
        push {r4-r5}
        ldr r4, [r3, #STCLO]
        add r4, r2
muchFun:
        ldr r5, [r3, #STCLO]
        cmp r5, r4
        blo muchFun
        pop {r4-r5}
        bx lr
