@ Exerise 8
.include "base.inc"

.text
        @ Init RTI
        RPI3
        mov r0, #0
        ADDEXC 0x18, irq_handler
        ADDEXC 0x1C, fiq_handler
        @ Init stack for FIQ mode
        mov r0, #0b11010001
        msr cpsr_c, r0
        mov sp, #0x4000
        @ Init stack for IRQ mode
        mov r0, #0b11010010
        msr cpsr_c, r0
        mov sp, #0x8000
        @ Init stack for SPC mode
        mov r0, #0b11010011
        msr cpsr_c, r0
        mov sp, #0x8000000
        @ Code
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        str r1, [r0, #GPFSEL0]
        @ ENABLE FE ints through GPIO2
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000000000000100
        str r1, [r0, #GPFEN0]
        @ Allow interruptions from any GPIO pin
        ldr r0, =INTBASE
        mov r1, #0b00000000000100000000000000000000
        str r1, [r0, #INTENIRQ2]
        @ PROGRAM TIMER TO INTERRUPT IN 4 SECS
        ldr r0, =STBASE
        ldr r1, [r0, #STCLO]
        add r1, #0x400000
        str r1, [r0, #STC1]
        @ ENABLE CI INTERRUPTION
        ldr r0, =INTBASE
        mov r1, #0b00000010
        str r1, [r0, #INTENIRQ1]
        @ ENABLE FIQ FOR GPIO_int3
        mov r1, #0b10110100
        str r1, [r0, #INTFIQCON]
        @ set SVC mode enabling irq and fiq
        mov r0, #0b00010011
        msr cpsr_c, r0
loop:   b loop

fiq_handler:
        push {r0, r1, r2}
        ldr r0, =GPFBASE
        ldr r1, =onoff
        ldr r2, [r1]
        eors r2, #1
        str r2, [r1]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        streq r1, [r0, #GPCLR0]
        strne r1, [r0, #GPFSET0]
        mov r1, #0b00000000000000000000000000000100
        str r1, [r0, #GPEDS0]
        pop {r0, r1, r2}
        bx lr

irq_handler:
        push {r0, r1, r2}
        ldr r0, =GPFBASE
        ldr r1, =onoff
        ldr r2, [r1]
        eors r2, #1
        str r2, [r1]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
        strne r1, [r0, #GPFSET0]
        streq r1, [r0, #GPCLR0]
        @ CLEAR TIMER INTERRUPT
        ldr r0, =STBASE
        mov r1, #0b0010
        str r1, [r0, #STCS]
        @ PROGRAM TIMER TO INTERRUPT IN 4 SECS
        ldr r1, [r0, #STCLO]
        add r1, #0x400000
        str r1, [r0, #STC1]
        pop {r0, r1, r2}
        bx lr


 onoff: .word 0
