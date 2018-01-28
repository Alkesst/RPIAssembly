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
    ldr r1, [r0, #GPLEV0]
    tst r1, #0b0100
    beq modoTodos
    tst r1, #0b1000
    beq modoSecuencia
    b pollLoop

modoTodos:
    ldr r1, =tipoEncendidoLeds
    mov r2, #1
    str r2, [r1]
	ldr r1, =estadoLed
	mov r2, #0
	str r2, [r1]
    b pollLoop

modoSecuencia:
    ldr r1, =tipoEncendidoLeds
	ldr r3, [r1]
	cmp r3, #0
	beq pollLoop
    mov r2, #0
    str r2, [r1]
	ldr r1, =estadoLed
	mov r2, #-1
	str r2, [r1]
    b pollLoop

infinito: b infinito


fiq_handler:
	ldr r9, =indiceNota
    ldr r9, [r9]
    ldr r10, =notaFS
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
    @ldr r9, =indiceNota
    @ldr r9, [r9]
    @ldr r10, =notaFS
    @ldr r10, [r10, r9, LSL #2] @ R2 <- notaFS[indiceNota]

    ldr r8, =STBASE
    mov r9, #0b1000      @Con esto reiniciamos el estado de la interrupcion
    str r9, [r8, #STCS]  @End Of Interrupt from System Timer

    ldr r9, [r8, #STCLO] @Reprogramamos el STC1 para 440Hz
    add r9, r10
    str r9, [r8, #STC3]

    subs pc, lr, #4

irq_handler:
    push {r0-r4}

	ldr r1, =indiceNota @Cargamos el puntero indiceNota
    ldr r2, [r1]        @Cargamos el valor del puntero de indiceNota
    mov r4, #NUMNOTAS
    add r2, #1
    cmp r2, r4
    moveq r2, #0
    str r2, [r1] @indiceNota = indiceNota++ % NUMNOTAS

    ldr r0, =GPFBASE   @Cargamos dirección base para los GPIO
    ldr r3, =estadoLed @Cargamos el puntero de estadoLed
    ldr r1, [r3]       @Cargamos el valor del puntero estadoLed
    ldr r2, =tipoEncendidoLeds
    ldr r2, [r2]
    cmp r2, #1
    beq .todo

    ldr r2, =leds      @Cargamos el puntero de leds
    ldr r4, [r2, r1, LSL #2] @ R4 <- leds[estadoLed]
    str r4, [r0, #GPCLR0]   @Apagamos el led actual

    add r1, #1
    cmp r1, #6
    moveq r1, #0
    str r1, [r3] @estadoLed = estadoLed++ % 6

    ldr r4, [r2, r1, LSL #2] @ R4 <- leds[estadoLed]
    str r4, [r0, #GPFSET0]
    b .end

.todo:
    eors r1, #1  @estadoLed = !estadoLed
    str r1, [r3]
    /* GUIA     10987654321098765432109876543210 */
    ldr r10, =0b00001000010000100000111000000000
    streq r10, [r0, #GPCLR0]
    strne r10, [r0, #GPFSET0]

.end:
    ldr r1, =indiceNota @Cargamos el puntero indiceNota
    ldr r2, [r1]        @Cargamos el valor del puntero de indiceNota
    ldr r3, =duratFS
    ldr r3, [r3, r2, LSL #2] @ R4 <- duratFS[indiceNota]

    ldr r0, =STBASE
    mov r1, #0b0010      @Con esto reiniciamos el estado de la interrupcion
    str r1, [r0, #STCS]  @End Of Interrupt from System Timer

    ldr r1, [r0, #STCLO] @Reprogramamos el STC1 para 1000ms
    add r1, r3 @STC1 = ValorActualDelSTClock = duratFS[indiceNota]
    str r1, [r0, #STC1]

    pop {r0-r4}
    subs pc, lr, #4

.word SILEN
.include "vader.inc"
.ifndef notaFS
.err @ No se ha escogido una partitura. Revise el código...
.endif

indiceNota: .word -1
estadoBuzzer: .word 0
estadoLed: .word -1
tipoEncendidoLeds: .word 0
leds: .word 0b00000000000000000000001000000000
    .word 0b00000000000000000000010000000000
    .word 0b00000000000000000000100000000000
    .word 0b00000000000000100000000000000000
    .word 0b00000000010000000000000000000000
    .word 0b00001000000000000000000000000000
