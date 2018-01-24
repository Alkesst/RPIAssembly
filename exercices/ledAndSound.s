.include "base.inc"
@ exercise 13
.text
        RPI3
        mov r0, #0
        ADDEXC 0x18, irq_handler
        ADDEXC 0x1c, fiq_handler
        @stack init
        mov r0, #0b11010010
        msr cpsr_c, r0
        mov sp, #0x8000
        mov r0, #0b11010001
        msr cpsr_c, r0
        mov sp, #0x4000
        mov r0, #0b11010011
        msr cpsr_c, r0
        mov sp, #0x08000000 @ init stack in svc mode

    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r5, #0b00001000000000000000000000000000
        @ Configuring 4, 9, 10. 11. 17, 22 and 27 gpios as output
        @ Leds and buzzer
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        ldr r1, =0b00001000000000000001000000000000
        ldr r2, =0b00000000001000000000000000001001
        ldr r3, =0b00000000001000000000000001000000
        str r1, [r0, #GPFSEL0]
        str r2, [r0, #GPFSEL1]
        str r3, [r0, #GPFSEL2]
        ldr r0, =STBASE
        @ C1 and C3 timer
        ldr r1, [r0, #STCLO]
        add r1, #0x100 @aprox 0.52 secs
        str r1, [r0, #STC1]
        str r1, [r0, #STC3]
        ldr r0, =INTBASE
        mov r1, #0b10   @ allows c1 interruptions
        str r1, [r0, #INTENIRQ1]
        mov r1, #0b10000011 @ fiq
        str r1, [r0, #INTFIQCON]  @ allow c3 interrupt through fiq
        mov r0, #0b00010011
        msr cpsr_c, r0
loop:   b loop

irq_handler:
        push {r0-r3, lr}
        bl next_led

        ldr r1, =onoff
        ldr r2, [r1]
        eors r2, #1
        str r2, [r1]
        ldr r3, =GPFBASE
        strne r0, [r3, #GPFSET0]
        streq r0, [r3, #GPCLR0]

        @ clear timer interrupt
        ldr r0, =STBASE
        mov r1, #0b010
        str r1, [r0, #STCS]
        @program timer to interrupt in 0.52 secs
        add r1, #0x80000
        pop {r0-r3, lr}
        subs pc, lr, #4

fiq_handler:
        push {r0-r3}

        ldr r1, =buzzer
        ldr r2, [r1]
        eors r2, #1
        str r2, [r1]
        ldr r3, =GPFBASE
    @ bit mask: #0b10987654321098765432109876543210
        mov r0, #0b00000000000000000000000000010000
        strne r0, [r3, #GPFSET0] @ turns on buzzer
        streq r0, [r3, #GPCLR0] @ turns off buzzer
        @ #0b1000 clear c3 timer
        ldr r0, =STBASE
        mov r1, #0b1000
        str r1, [r0, #STCS]
        @program timer to interrupt in 1136 microsecs (G Note)
        ldr r1, [r0, #STCLO]
        ldr r2, =1136
        add r1, r1, r2
        str r1, [r0, #STC3]
        pop {r0-r3}
        subs pc, lr, #4

next_led:
        @ get the next pos of an array
        ldr r0, =current_pos
        ldr r1, [r0]
        add r1, r1, #1
        ldr r2, =size
        ldr r3, [r2]
        cmp r1, r3
        moveq r1, #0
        str r1, [r0]
        ldr r2, =seq
        ldr r0, [r2, r1, LSL #2]
        bx lr

buzzer: .word 0
onoff:  .word 0
    @BIT MASK 0b10987654321098765432109876543210
seq:    .word 0b00000000000000000000001000000000
        .word 0b00000000000000000000001000000000
        .word 0b00000000000000000000010000000000
        .word 0b00000000000000000000010000000000
        .word 0b00000000000000000000100000000000
        .word 0b00000000000000000000100000000000
        .word 0b00000000000000100000000000000000
        .word 0b00000000000000100000000000000000
        .word 0b00000000010000000000000000000000
        .word 0b00000000010000000000000000000000
        .word 0b00001000000000000000000000000000
        .word 0b00001000000000000000000000000000
size:   .word 12
current_pos: .word -1
