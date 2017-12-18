    .set GPBASE, 0x3f200000
    .set GPFSEL1, 0x04
    .set GPSET0, 0x1c

.text
        ldr r0, =GPBASE
    @ BIT MASK:  0bxx999888777666555444333222111000
        mov r1, #0b00000000000000000000000000000001 @ BIT MASK
        str r1, [r0, #GPSEL1]                       @ Sets the GPIO 10 as output
    @ BIT MASK:  0b10987654321098765432109876543210
        mov r1, #0b00000000000000000000010000000000 @ BIT MASK
        str r1, [r0, #GPSET0]                       @ Turns the 2nd red Led on
inf:    b inf                                       @ Makes the program run through infinite
