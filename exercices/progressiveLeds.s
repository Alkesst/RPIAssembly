.include "base.inc"
@ Exercise 6
.text
        ldr sp, =0x8000000
        ldr r4, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r5, #0b00001000000000000000000000000000
        str r5, [r4, #GPFSEL0]
        ldr r8, =STBASE
loop:
        ldr r4, [r8, #STCLO]
        mov r0, r4
        bl nextTime
        mov r0, r4
        bl change_led
        b loop

change_led:
@ working
        @ r0: program time
        push {r4-r6, lr}
        ldr r4, =last_time2
        ldr r5, [r4]
        ldr r6, =actual_pos
        ldr r6, [r6]
        mov r1, #4
        mul r2, r6, r1
        ldr r3, =times
        ldr r3, [r3, r2]
        sub r1, r0, r5
        cmp r1, r3
        blt notChanging
        str r0, [r4]
        ldr r4, =is_it_on
        ldr r5, [r4]
        eor r5, r5, #0b1
        str r5, [r4]
        cmp r5, #0b1
        bleq turnOffLed
        blne turnOnLed
notChanging:
        pop {r4-r6, lr}
        bx lr

turnOffLed:
@ working
        push {r6}
        ldr r1, =GPFBASE
        mov r6, #0b00000000000000000000001000000000
        str r6, [r1, #GPCLR0]
        pop {r6}
        bx lr

turnOnLed:
@ working
        push {r6}
        ldr r1, =GPFBASE
        @       #0b10987654321098765432109876543210
        mov r6, #0b00000000000000000000001000000000
        str r6, [r1, #GPFSET0]
        pop {r6}
        bx lr

nextTime:
        @ r0: program time.
        push {r4-r5}
        ldr r4, =last_time1
        ldr r5, [r4]
        sub r1, r0, r5
        ldr r2, =5000000
        cmp r1, r2
        blt tryAgain
        str r0, [r4]
        ldr r4, =actual_pos
        ldr r5, [r4]
        add r5, r5, #1
        ldr r1, =size
        ldr r2, [r1]
        cmp r2, r5
        moveq r5, #0
        str r5, [r4]
tryAgain:
        pop {r4-r5}
        bx lr

@ circular array of times. We will visit them progressively
times:      .word 1000000, 750000, 500000, 250000, 100000, 75000, 50000, 25000
size:       .word 8
last_time1: .word 0
is_it_on:   .word 0b0
last_time2: .word 0
actual_pos: .word 0 
