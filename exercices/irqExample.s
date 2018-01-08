.include "base.inc"
@ Exercise 8
.text
        RPI3
        mov r0, #0
        ADDEXC 0x18, irq_handler
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        ldr r1, =0b00001000000000000000000000000000
        str r1, [r0, #GPFSEL0]
        ldr r0, =STBASE
        ldr r1, [r0, #STCLO]
        add r1, #0x400000
        str r1, [r0, #STC1]
        ldr r0, =INTBASE
        mov r1, #0b0010
        str r1, [r0, #INTENIRQ1]
        mov r0, #0b01010011
        msr cpsr_c, r0
loop:   b loop

irq_handler:
        push {r0, r1}
        ldr r0, =GPFBASE
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        str r1, [r0, #GPFSET0]
        pop {r0, r1}
        subs pc, lr, #4
