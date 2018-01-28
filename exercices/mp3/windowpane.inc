

.set CORCHEA, 301205 @ Corchea a 83bpm
.set SEMICORCHEA, 150602 @ Semicorchea a 83bpm

@ Windowpane es lentillo en verdad, pero repetitivo al principio
@ Todas las notas desplazadas una escala hacia arriba para que se pueda oir en
@ el zumbador
@ https://www.jellynote.com/en/sheet-music-tabs/opeth/windowpane/504a0ea2d2235a3ff94a9da2

.set DO3,  3822
.set DO3S, 3608
.set RE3,  3405
.set RE3S, 3214
.set MI3,  3034
.set FA3,  2863
.set FA3S, 2703
.set SOL3, 2551
.set SOL3S,2408
.set LA3,  2273
.set LA3S, 2145
.set SI3,  2025

.set DO4,  1911
.set DO4S, 1804
.set RE4,  1703
.set RE4S, 1607
.set MI4,  1517
.set FA4,  1432
.set FA4S, 1351
.set SOL4, 1276
.set LA4,  1136
.set LA4S, 1073
.set SI4,  1012

wpNotas:
    .word FA3S
    .word DO4S
    .word FA4S @ La de abajo del acorde
    .word DO4
    .word FA3
    .word DO4
    .word FA4 @ La de abajo del acorde

    .word FA3S
    .word DO4S
    .word FA4S
    .word DO4
    .word FA3S
    .word DO4
    .word MI4
    .word LA4
    .word MI4
    .word FA4

wpDurat:
    .word CORCHEA
    .word SEMICORCHEA
    .word CORCHEA
    .word SEMICORCHEA
    .word CORCHEA
    .word CORCHEA
    .word CORCHEA

    .word CORCHEA
    .word SEMICORCHEA
    .word CORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
    .word SEMICORCHEA
