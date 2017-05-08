@We simulate a dice roll with this code. We'll use WiringPi (found at http://www.wiringpi.com) and libberry.s
@I'll put some music when you push the botton to give more tension
.data
ledssec:    .word   0b000001,0b000011,0b000111,0b001111,0b011111,0b111111, 0b011111, 0b001111, 0b000111, 0b000011, 0b000001
            .word
notassec:   .word   3822, 3034, 2551, 2025, 1911, 1351, 1911, 2025, 2551, 3034, 3822
tam:        .word   11
str:        .string "s"
.include "wiringPiPins.s"
.text
.global main
main:
        push {lr}
        bl initBerry
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
        bl random
        mov r5, r0
        bl soundleds
        bl soundleds
        mov r0, r5
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
