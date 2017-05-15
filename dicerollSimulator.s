@We simulate a dice roll with this code. We'll use WiringPi (found at http://www.wiringpi.com) and libberry.s
@I'll put some music when you push the botton to give more tension
.data
ledssec:    .word   0b000001,0b000011,0b000111,0b001111,0b011111,0b111111, 0b011111, 0b001111, 0b000111, 0b000011, 0b000001
            .word
notassec:   .word   3822, 3405, 2551, 1911, 1803, 1276, 1803, 1911, 2551, 3405, 3822
tam:        .word   11
str:        .string "%d\n"
.include "wiringPiPins.s"
.text
.global main
main:
        push {lr}
        bl initBerry
buc:
        bl roll
        ldr r0, =#2500
        bl delay
        bl initBerry
        mov r0, #BUTTON2
        bl digitalRead
        bne buc
fin:        
        pop {lr}
        bx lr


random:
        push {lr}
        bl micros
getrand:
        and r2, r0, #0b111
        sub r0, r2, #1
        cmp r0, #-1
        bleq random
        cmp r0, #0
        bleq random
        pop {lr}
        bx lr

roll:
        push {r4-r5, lr}
while:
        mov r4, #BUTTON1
        mov r0, r4
        bl digitalRead
        cmp r0, #0
        beq end2
        mov r0, #1
        bl delay
        b while
end2:
        bl soundleds
        bl soundleds
        bl random
        bl setLeds
        pop {r4-r5, lr}
        bx lr

soundleds:
        push {r4-r8, lr}
        ldr r1, =tam
        ldr r8, [r1]
        ldr r5, =ledssec
        ldr r7, =notassec
for:
        cmp r8, #0
        beq outfor
        ldr r6, [r5], #4
        mov r0, r6
        bl setLeds
note:
        ldr r0, [r7], #4
        mov r1, #110
        bl playNote
        sub r8, r8, #1
        b for
outfor:
        pop {r4-r8, lr}
        bx lr
