

.set REDONDA,   2000000
.set BLANCAP,   1500000
.set SEMICORCHEA,125000
.set NEGRAP,     750000

.set LA3,  2273
.set LA3S, 2145
.set SI3,  2025

.set DO4,  1911
.set DO4S, 1804
.set RE4,  1703
.set RE4S, 1607
.set MI4,  1517
.set FA4,  1432
.set SOL4, 1276
.set LA4,  1136
.set LA4S, 1073
.set SI4,  1012

upNotas:
    .word SILEN

    .word SILEN

    .word LA4

    .word FA4
    .word LA3

    .word LA3S @Si Bemol
    .word SILEN
    .word DO4
    .word LA3S @Si Bemol

    .word LA3

    .word LA4
    .word MI4

    .word DO4S
    .word LA3

    .word LA4S @Si Bemol !
    .word SILEN
    .word 952 @Do 5
    .word LA4S @Si Bemol !

    .word LA4

    .word LA4
    .word FA4
    .word RE4
    .word LA3

    .word RE4
    .word FA4
    .word LA4
    .word RE4

    .word LA4S @Si Bemol !
    .word SILEN
    .word LA4
    .word SOL4

    .word LA4

    .word LA4
    .word MI4
    .word DO4S
    .word LA3

    .word DO4S
    .word MI4
    .word LA4
    .word MI4

    .word SOL4
    .word SILEN
    .word FA4
    .word MI4

    .word FA4
    .word RE4
    .word RE4

    .word RE4

upDurat:
    .word REDONDA

    .word REDONDA

    .word REDONDA

    .word BL
    .word BL

    .word BLANCAP
    .word COR
    .word SEMICORCHEA
    .word SEMICORCHEA

    .word REDONDA

    .word BL
    .word BL

    .word BL
    .word BL

    .word BLANCAP @Si Bemol !
    .word COR
    .word SEMICORCHEA @Do 5
    .word SEMICORCHEA @Si Bemol !

    .word REDONDA

    .word NG
    .word NG
    .word NG
    .word NG

    .word NG
    .word NG
    .word NG
    .word NG

    .word BLANCAP @Si Bemol !
    .word COR
    .word SEMICORCHEA
    .word SEMICORCHEA

    .word REDONDA

    .word NG
    .word NG
    .word NG
    .word NG

    .word NG
    .word NG
    .word NG
    .word NG

    .word BLANCAP
    .word COR
    .word SEMICORCHEA
    .word SEMICORCHEA

    .word BLANCAP
    .word NEGRAP
    .word SEMICORCHEA

    .word REDONDA
