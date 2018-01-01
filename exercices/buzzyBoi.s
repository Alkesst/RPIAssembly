.include "base.inc"
@ Exercise 5
.text
        ldr sp, =0x8000000
        ldr r4, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r5, #0b00000000000000000001000000000000
        str r5, [r4, #GPFSEL0]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r5, #0b00000000000000000000000000010000
        ldr r0, =STBASE
        ldr r1, =1136
loop:
        bl wait
        str r5, [r4, #GPFSET0]
        bl wait
        str r5, [r4, #GPCLR0]
        b loop
wait:
        push {r4-r5}
        ldr r4, [r0, #STCLO]
        add r4, r1
muchFun:
        ldr r5, [r0, #STCLO]
        cmp r5, r4
        blo muchFun
        pop {r4-r5}
        bx lr
