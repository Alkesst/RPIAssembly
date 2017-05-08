@We simulate a dice roll with this code. We'll use WiringPi (found at http://www.wiringpi.com) and libberry.s
@I'll put some music when you push the botton to give more tension
.data
ledssec:    .word   0b000001,0b000011,0b000111,0b001111,0b011111,0b111111
notassec:   .word   3822, 3034, 2551, 2025, 1607, 1351
tam:        .word   6
.include "wiringPi.s"
.text
.global main
main:



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

roll:
        push {lr}
        mov r4, #BUTTON1
while:
        mov r0, r4
        bl digitalRead
        cmp r0, #0
        bne while
        bl random
        bl setLeds
bucl:
        mov r0, r4
        bl digitalRead
        cmp r0, #0
        beq bucl
        ldr r0, =7500
        bl delayMicroseconds
        bne while
end2:
