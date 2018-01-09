.include "base.inc"
@ Exercise 10
.text
        RPI3
        mov r0, #0
        ADDEXC 0x18, irq_handler

        @ stack inits
        mov r0, #0b11010010
        msr cpsr_c, r0
        mov sp, #0x8000
        mov r0, #0b11010011
        msr cpsr_c, r0
        mov sp, #0x8000000
        @ Configuring 9, 10. 11. 17, 22 and 27 gpios as output
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        ldr r2, =0b00000000001000000000000000001001
        ldr r3, =0b00000000001000000000000001000000
        str r1, [r0, #GPFSEL0]
        str r2, [r0, #GPFSEL1]
        str r3, [r0, #GPFSEL2]
@ 9 10 11 17 22 27
        ldr r0, =STBASE
        ldr r1, [r0, #STCLO]
        add r1, #0x80000 @aprox 0.52 secs
        str r1, [r0, #STC1]

        @ enable CI interruption
        ldr r0, =INTBASE
        mov r1, #0b010
        str r1, [r0, #INTENIRQ1]
        mov r0, #0b01010011
        msr cpsr_c, r0
loop:   b loop

irq_handler:
        push {r0, r1, r2}
        ldr r0, =GPFBASE
        ldr r1, =onoff
        ldr r2, [r1]
        eors r2, #1
        str r2, [r1]

    @ bit Mask: =0b10987654321098765432109876543210
        ldr r1, =0b00001000010000100000111000000000
        strne r1, [r0, #GPFSET0]
        streq r1, [r0, #GPCLR0]
        @ clear timer interrupt
        ldr r0, =STBASE
        mov r1, #0b0010
        str r1, [r0, #STCS]
        @program timer to interrupt in 0.52 secs
        ldr r1, [r0, #STCLO]
        add r1, #0x80000
        str r1, [r0, #STC1]

        pop {r0, r1, r2}
        subs pc, lr, #4

onoff: .word 1
