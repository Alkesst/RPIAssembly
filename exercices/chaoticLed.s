.include "base.inc"
@ Exercise 3
.text
        ldr sp, =0x8000000
        ldr r0, =GPFBASE
    @ BIT MASK: #0bxx999888777666555444333222111000
        mov r1, #0b00001000000000000000000000000000
        str r1, [r0, #GPFSEL0]
    @ BIT MASK: #0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000001000000000
loop:
        str r1, [r0, #GPFSET0]
        str r1, [r0, #GPCLR0]
        b loop
@ Notice that this code is not correct due to the program does not wait
@ to make visible the blinking. The program really turns on and off the led
@ but the processor can execute this really fast making the blink not visible
@ for humans. This "error" is fixed in exercise 4.
