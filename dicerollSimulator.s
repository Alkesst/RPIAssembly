@We simulate a dice roll with this code. We'll use WiringPi (found at http://www.wiringpi.com) and libberry.s
@I'll put some music when you push the botton to give more tension
.data
ledssec:    .word   0b000001,0b000011,0b000111,0b001111,0b011111,0b111111
notassec:   .word   3822, 3034, 2551, 2025, 1607, 1351
tam:        .word   6
.include "wiringPiPins.s"
.text
.global main
main:
        push {lr}
        bl roll
        pop {lr}
        bx lr



random:
        push {lr}
        bl millis
getrand:
        cmp r0, #6
        ble end
        lsl r0, r0, #1
        b getrand
end:
        pop {lr}
        bx lr

roll:
        push {r4, lr}
        mov r4, #BUTTON1
        mov r0, r4
while:
        bl digitalRead
        cmp r0, #0
        beq end2
        b while
end2:
        bl random
        push {r0}
        bl soundleds
        pop {r0}
        bl setLeds
        pop {r4, lr}
        bx lr

soundleds:
        push {r4-r6, lr}
        ldr r1, =tam
        ldr r2, [r1]
        ldr r5, =ledssec
for:
        cmp r2, #0
        beq outfor
        ldr r6, [r5], #4
        mov r0, r6
        bl setLeds
note:
        ldr r3, =notassec
        ldr r0, [r3], #4
        mov r1, #250
        bl playNote
        sub r2, r2, #1
        b for
outfor:
        pop {r4-r6, lr}
        bx lr
