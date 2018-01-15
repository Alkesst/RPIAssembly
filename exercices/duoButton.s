.include "base.inc"
@ Exercise 12
.text
        RPI3
        @ INIT
        mov r0, #0
        ADDEXC 0x18, irq_handler

        @ stack inits
        mov r0, #0b11010010
        msr cpsr_c, r0
        mov sp, #0x8000

        mov r0, #0b11010011
        msr cpsr_c, r0
        mov sp, #0x8000000

        @ program.
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        mov r2, #0b00000000000000000000000000000001
        str r1, [r0, #GPFSEL0]
        str r2, [r0, #GPFSEL1]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000011000000000
        str r1, [r0, #GPFSET0]

        @ ENABLE FE ints through GPIO2
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000000000001100
        str r1, [r0, #GPFEN0]
        ldr r0, =INTBASE
        mov r1, #0b00000000000100000000000000000000
        str r1, [r0, #INTENIRQ2]

        mov r0, #0b01010011
        msr cpsr_c, r0
loop:   b loop

irq_handler:
        push {r0, r1, r2}
        ldr r0, =GPFBASE
        ldr r2, [r0, #GPEDS0]
    @ BIT MASK:  #0b10987654321098765432109876543210
        ands r2, #0b00000000000000000000000000000100
        movne r1,#0b00000000000000000000010000000000
        strne r1, [r0, #GPCLR0]
        movne r1, #0b00000000000000000000000000000100
        strne r0, [r0, #GPEDS0]
        ldr r2, [r0, #GPEDS0]
    @ BIT MASK:  #0b10987654321098765432109876543210
        ands r2, #0b00000000000000000000000000001000
        movne r1,#0b00000000000000000000001000000000
        strne r1, [r0, #GPCLR0]
        movne r1, #0b00000000000000000000000000001000
        strne r1, [r0, #GPEDS0]
        pop {r0, r1, r2}
        subs pc, lr, #4
