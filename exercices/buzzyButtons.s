.include "base.inc"
@ Exercise 7
.text
        ldr sp, =0x08000000
        ldr r3, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r5, #0b00000000000000000001000000000000
        str r5, [r3, #GPFSEL0]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r2, #0b00000000000000000000000000010000 @ r5 buzzer
        mov r6, #0b00000000000000000000000000001000 @ r6 left button
        mov r7, #0b00000000000000000000000000000100 @ r7 right button
        @ldr r1, =3822                               @ C4 period in microsecs
        @ldr r2, =2551                               @ G4 period in microsecs
loop:
        ldr r8, [r3, #GPLEV0]                       @ Did the user press the button?
        tst r8, r6
        bleq rightButton
        tst r8, r7
        bleq leftButton
        b loop

rightButton:
        ldr r0, =STBASE
        ldr r1, =2551
c4loop:
        bl wait
        str r2, [r3, #GPFSET0]
        bl wait
        str r2, [r3, #GPCLR0]
        b c4loop

leftButton:
        ldr r0, =STBASE
        ldr r1, =3822
g4loop:
        bl wait
        str r2, [r3, #GPFSET0]
        bl wait
        str r2, [r3, #GPCLR0]
        b g4loop

wait:
        push {r4, r5}
        ldr r4, [r0, #STCLO]
        add r4, r1
still:
        ldr r5, [r0, #STCLO]
        cmp r5, r4
        blo still
        pop {r4,r5}
        bx lr

@soundC:
@        push {r4-r5}
@        ldr r4, =GPFBASE
    @ BIT MASK: #0b10987654321098765432109876543210
@        mov r5, #0b00000000000000000000001000000000
@        str r5, [r4, #GPFSET0]
@        pop {r4-r5}
@        bx lr
@ soundG:
@        push {r4-r5}
@        ldr r4, =GPFBASE
    @ BIT MASK: #0b10987654321098765432109876543210
@        mov r5, #0b00000000000000000000010000000000
@        str r5, [r4, #GPFSET0]
@        pop {r4-r5}
@        bx lr
