.include "base.inc"
.include "notas.inc"

.text
    RPI3

    ADDEXC 0x18, irq_handler @Se añade el manejador de los IRQ
    ADDEXC 0x1C, fiq_handler @Se añade el manejador del FIQ

    @Inicializando la pila en el modo IRQ, FIQ y SVC (sin interrupciones)
    mov R0, #0b11010001 @FIQ
    msr cpsr_c, R0
    mov sp, #0x4000
    mov R0, #0b11010010 @IRQ
    msr cpsr_c, R0
    mov sp, #0x8000
    mov R0, #0b11010011 @SVC
    msr cpsr_c, R0
    mov sp, #0x8000000

    ldr r0, =GPFBASE
    ldr r1, =0b00001000000000000001000000000000
    str r1, [r0, #GPFSEL0]
    ldr r1, =0b00000000001000000000000000001001
    str r1, [r0, #GPFSEL1]
    ldr r1, =0b00000000001000000000000001000000
    str r1, [r0, #GPFSEL2]


    @Se programa el contador C1 (leds) y C3 (buzzer), para las ints
    ldr r0, =STBASE
    ldr r1, [r0, #STCLO]
    add r1, #5 @Encender los leds en 5 microsegundos :)
    str r1, [r0, #STC1]
    add r1, #5
    str r1, [r0, #STC3] @Encender el altavoz con los leds :))

    @Se habilitan las interrupciones para C1
    ldr r0, =INTBASE
    mov r1, #0b0010
    str r1, [r0, #INTENIRQ1]

    @Se habilitan las interrupciones para C3
    mov r1, #0b10000011
    str r1, [r0, #INTFIQCON]

    @Se activan las interrupciones globales
    mov r0, #0b00010011 @SVC + IRQ enabled
    msr cpsr_c, r0

    ldr r0, =GPFBASE
pollLoop:
    mov r1, #10000
    bl wait
    ldr r1, [r0]
    ldr r1, [r0, #GPLEV0]
    tst r1, #0b0100
    beq pause_song
    tst r1, #0b1000
    beq pass_song
    b pollLoop

pause_song:
    ldr r3, =pause
    ldr r1, [r3]
    mov r2, #1
    eor r1, r2
    cmp r1, r2
    str r1, [r3]
    bne playing

    ldr r8, =STBASE
    mov r9, #0
    str r9, [r8, #STC3]
    str r9, [r8, #STC1]

    b eee

playing:
    ldr r8, =STBASE

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 440Hz
    add r9, #50
    str r9, [r8, #STC3]

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 1000ms
    add r9, #50 @STC1 = ValorActualDelSTClock = duratFS[indiceNota]
    str r9, [r8, #STC1]
eee:
    mov r1, #10000
    bl wait
    mov r2, #0b00000000000000000000000000000100
    ldr r1, [r0, #GPLEV0]
    tst r1, r2
    beq eee
    b pollLoop

pass_song:
    ldr r1, =pause
    mov r2, #0
    str r2, [r1]
    ldr r1, =song_index
    ldr r2, [r1]
    ldr r3, =songs_size
    ldr r3, [r3]
    add r2, #1
    cmp r2, r3
    moveq r2, #0
    str r2, [r1]
    ldr r1, =indiceNota
    mov r2, #0
    str r2, [r1]

    ldr r8, =STBASE
    mov r9, #0b1000      @Con esto reiniciamos el estado de la interrupcion
    str r9, [r8, #STCS]  @End Of Interrupt from System Timer

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 440Hz
    add r9, #50
    str r9, [r8, #STC3]

    mov r9, #0b0010      @Con esto reiniciamos el estado de la interrupcion
    str r9, [r8, #STCS]  @End Of Interrupt from System Timer

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 1000ms
    add r9, #50 @STC1 = ValorActualDelSTClock = duratFS[indiceNota]
    str r9, [r8, #STC1]

ee:
    mov r2, #0b00000000000000000000000000001000
    ldr r1, [r0, #GPLEV0]
    tst r1, r2
    beq ee
    b pollLoop

infinito: b infinito


fiq_handler:
    push {r0-r1,lr}
    bl get_notes
    mov r10, r0
	ldr r9, =indiceNota
    ldr r9, [r9]
    ldr r10, [r10, r9, LSL #2] @ R2 <- notaFS[indiceNota]
	ldr r11, =SILEN
	cmp r10, r11
	beq .fend

    ldr r9, =GPFBASE
    ldr r12, =estadoBuzzer
    ldr r11, [r12]
    eors r11, #1
    str r11, [r12]

    mov r11, #0b10000
    streq r11, [r9, #GPCLR0]
    strne r11, [r9, #GPFSET0]

.fend:
    ldr r8, =STBASE
    mov r9, #0b1000      @Con esto reiniciamos el estado de la interrupcion
    str r9, [r8, #STCS]  @End Of Interrupt from System Timer

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 440Hz
    add r9, r10
    str r9, [r8, #STC3]

    pop {r0-r1,lr}
    subs pc, lr, #4

irq_handler:
    push {r0-r4, lr}
    bl get_numNotas
    mov r4, r0
	ldr r1, =indiceNota @Cargamos el puntero indiceNota
    ldr r2, [r1]        @Cargamos el valor del puntero de indiceNota
    add r2, #1
    cmp r2, r4
    moveq r2, #0
    str r2, [r1] @indiceNota = indiceNota++ % NUMNOTAS

    ldr r0, =GPFBASE   @Cargamos dirección base para los GPIO
    @ldr r3, =estadoLed @Cargamos el puntero de estadoLed
    @ldr r1, [r3]       @Cargamos el valor del puntero estadoLed
    @ leds   0b10987654321098765432109876543210
    ldr r1, =0b00001000010000100000111000000000
    str r1, [r0, #GPCLR0]
    ldr r1, =indiceNota
    ldr r1, [r1]            @ cargamos indice nota
    mov r2, #7              @ 6 pq los leds que tenemos chaval Buenas tardes gerardo
    mul r1, r2, r1          @ multiplicamos por las notas * 6 total
    udiv r1, r4             @ dividimos entre el total de noutes * 6

    ldr r2, =leds      @Cargamos el puntero de leds
    /*add r1, #1
    cmp r1, #6
    moveq r1, #0
    str r1, [r3] @estadoLed = estadoLed++ % 6*/

    ldr r4, [r2, r1, LSL #2] @ R4 <- leds[estadoLed]
    str r4, [r0, #GPFSET0]

.end:
    bl get_durats
    mov r3, r0
    ldr r1, =indiceNota @Cargamos el puntero indiceNota
    ldr r2, [r1]        @Cargamos el valor del puntero de indiceNota
    ldr r3, [r3, r2, LSL #2] @ R4 <- duratFS[indiceNota]

    ldr r0, =STBASE
    mov r1, #0b0010      @Con esto reiniciamos el estado de la interrupcion
    str r1, [r0, #STCS]  @End Of Interrupt from System Timer

    ldr r1, [r0, #STCLO] @Reprogramamos el STC1 para 1000ms
    add r1, r3 @STC1 = ValorActualDelSTClock = duratFS[indiceNota]
    str r1, [r0, #STC1]

    pop {r0-r4, lr}
    subs pc, lr, #4

get_notes:
    @ returns the notesPointer
    ldr r1, =song_index
    ldr r1, [r1]
    ldr r0, =songs
    ldr r0, [r0, r1, lsl #4]
    bx lr

get_durats:
    @ returns the duratsPointer
    ldr r1, =song_index
    ldr r1, [r1]
    ldr r0, =songs
    lsl r1, r1, #4
    add r0, r1
    add r0, #4
    ldr r0, [r0]
    bx lr

get_numNotas:
    @ returns the numnotas
    ldr r1, =song_index
    ldr r1, [r1]
    ldr r0, =songs
    lsl r1, r1, #4
    add r0, r1
    add r0, #8
    ldr r0, [r0]
    bx lr

wait:
        push {r4-r5}
        ldr r3, =STBASE
        ldr r4, [r3, #STCLO]   @ LOAD CLO TIMER
        add r4, r1             @ ADD WAITING TIME
muchFun:                       @ WHILE CURRENT TIME /= TIME TO WAIT DO
        ldr r5, [r3, #STCLO]   @ LOAD IN r5 CURRENT TIME
        cmp r5, r4             @ CMP r5, r4
        blo muchFun            @ OD
        pop {r4-r5}
        bx lr

.data

.word SILEN
.include "a-sight-to-behold.inc"
.include "weather-the-storm.inc"
.include "first-kill.inc"
.include "windowpane.inc"
.include "uprising.inc"
.include "clocks.inc"
.include "mpe.inc"
.include "stb.inc"


song_index: .word 0
songs_size: .word 8
indiceNota: .word 0
estadoBuzzer: .word 0
estadoLed: .word 0
pause:      .word 0
leds:
    .word 0b00000000000000000000000000000000
    .word 0b00000000000000000000001000000000
    .word 0b00000000000000000000011000000000
    .word 0b00000000000000000000111000000000
    .word 0b00000000000000100000111000000000
    .word 0b00000000010000100000111000000000
    .word 0b00001000010000100000111000000000

songs:
    .word ckNotas, ckDurat, 32, 0
    .word gjrNotas, gjrDurat, 103, 0
    .word wtsNotas, wtsDurat, 128, 0
    .word fkNotas, fkDurat, 16, 0
    .word wpNotas, wpDurat, 17, 0
    .word upNotas, upDurat, 48, 0
    .word mpeNotas, mpeDurat, 32, 0
    .word stbNotas, stbDurat, 44, 0
