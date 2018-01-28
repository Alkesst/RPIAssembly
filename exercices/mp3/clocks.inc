

.set CORCHEA, 192308 @ Corchea a 130bpm

@ Clocks tiene una armadura de bemoles: LA SI RE MI (La b Mayor)

.set DO3,  3822
.set DO3S, 3608
.set RE3,  3608@3405
.set RE3S, 3214
.set MI3,  3214@3034
.set FA3,  2863
.set FA3S, 2703
.set SOL3, 2551
.set SOL3S,2408
.set LA3,  2408@2273
.set LA3S, 2145
.set SI3,  2145@2025

.set DO4,  1911
.set DO4S, 1804
.set RE4,  1804@1703
.set RE4S, 1607
.set MI4,  1604@1517
.set FA4,  1432
.set FA4S, 1351
.set SOL4, 1276
.set LA4,  1276@1136
.set LA4S, 1073
.set SI4,  1073@1012

ckNotas:
    .word MI4
    .word SI3
    .word SOL3
    .word MI4
    .word SI3
    .word SOL3
    .word MI4
    .word SI3

    .word RE4
    .word SI3
    .word FA3
    .word RE4
    .word SI3
    .word FA3
    .word RE4
    .word SI3

    .word RE4
    .word SI3
    .word FA3
    .word RE4
    .word SI3
    .word FA3
    .word RE4
    .word SI3

    .word DO4
    .word LA3
    .word FA3
    .word DO4
    .word LA3
    .word FA3
    .word DO4
    .word LA3

    .WORD SILEN


ckDurat:
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA

    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA

    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA

    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA

    .WORD 3076923 @REDONDA a 130bpm
