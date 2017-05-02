.data
leds:	.word RLED1, RLED2, YLED1, YLED2, GLED1, GLED2	/* id de los pines de los leds */
.include "wiringPiPins.s"  /* fichero con definiciones para el control de la placa */

.text
 
.global initBerry, setLeds, playNote

@ initBerry: Inicializa la libreria wiringPi y los pines de la placa (berryclip)
@
@ Uso:
@    initBerry()
@ Parametros de entrada:
@    Ninguno 
@ Resultado:
@    Ninguno
initBerry:
	push {r5, r6, lr}

	bl wiringPiSetup	/* inicializamos libreria */

						/* configuramos pin del pulsador 1 y 2 como entrada */	
						/* pinMode(int pin, int mode) */
	mov r0, #BUTTON1	/* indicamos el pin */	
	mov r1, #INPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
	
	mov r0, #BUTTON2	/* indicamos el pin */	
	mov r1, #INPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
						/* configuramos pin altavoz como salida */	
	mov r0, #BUZZER		/* indicamos el pin */	
	mov r1, #OUTPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
						/* configuramos pines de leds como salidas */	
	ldr r5, =leds		/* cargamos en r5 la direccion del array con los pines de los leds */
	add r6, r5, #24		/* en r6 calculamos la direccion final del array (6*4) */
bconf:	
	ldr r0, [r5]		/* cargamos un pin */
	mov r1, #OUTPUT		/* indicamos el modo */
	bl pinMode			/* configuramos pin como salida */
						/* pinMode(int pin, int mode) */
	ldr r0, [r5], #4    /* apagamos el led por si estuviera encendido */
	mov r1, #0
	bl digitalWrite
						
	cmp r5, r6			/* comprobamos si ha llegado al ultimo */
	bne bconf			/* si no ha llegado, volvemos para inicializar otro */
	pop {r5, r6, lr}
	bx lr

@ setLeds: Enciende/apaga los leds que se le indican de la placa (berryclip)
@
@ Uso:
@    setLeds(r0)
@ Parametros de entrada:
@    r0: Valor binario que indica el estado de los 6 leds en sus 6 bits menos significativos
@		 (valor 0 -> led apagado, valor 1 -> led encendido)
@		 bit 0 de r0 -> RLED1
@		 bit 1 de r0 -> RLED2
@		 bit 2 de r0 -> YLED1
@		 bit 3 de r0 -> YLED2
@		 bit 4 de r0 -> GLED1
@		 bit 5 de r0 -> GLED2
@ Resultado:
@    No devuelve nada, solo enciende/apaga los leds correspondientes en la placa
@ Nota:
@	 Previamente a la llamada a esta funcion, la libreria wiringPi debe estar inicializada 
@	 y los pines de los leds correctamente configurados como salida (initBerry)
setLeds:
        push {r4-r7, lr}
        mov r7, r0          @guardamos en r0 a r7 para no machacar la variable r0
        mov r5, #0b00000001 @mask
        ldr r4, =leds 		@accedemos a la pos del array
        mov r6, r4          @contador
        add r4, r4, #24     @inicializamos el contador
loop:
        and r2, r7, r5 		@solo habria que poner ands + un digitalwrite que saca lo que es e ir moviendo a la izquierda
        cmp r2, r5          @comparamos el bit de leds con nuestro and
        bne offled          @si son distintos, saltar a offled
        ldr r0, [r6], #4    /* encendemos el led */
        mov r1, #1          @encendemos el led
        bl digitalWrite
        b outloop
offled:
        ldr r0, [r6], #4    /* apagamos el led por si estuviera encendido */
        mov r1, #0
        bl digitalWrite
outloop:
        lsl r5, r5, #1      @modificamos nuestra máscara 1 bit
        cmp r6, r4
        blt loop
        pop {r4-r7, lr}
        bx lr

@ playNote: Reproduce una nota por el altavoz de la berryclip
@
@ Uso:
@    playNote(r0, r1)
@ Parametros de entrada:
@    r0: periodo (en microsegundos) de la frecuencia de la nota a tocar
@	 r1: duracion (en milisegundos) de la nota a tocar 
@ Resultado:
@    No devuelve nada, solo hace sonar el altavoz
@ Nota:
@	 Previamente a la llamada a esta funcion, la libreria wiringPi debe estar inicializada 
@	 y el pin del altavoz correctamente configurado como salida (initBerry)
@ 	 (Consultar informacion sobre las instrucciones ensamblador "sdiv / udiv")
playNote:
        push {r4-r5, lr}
        mov r4, r0      @guardamos el periodo
        lsr r4, r4, #1  @dividimos el periodo entre 2 p.ej.: 01010 lsr-> 0101
        mov r5, r1      @guardamos la duración de la nota
        mov r3, #1000   @Temporal
        mul r5, r5, r3  @convertimos r5 a las mismas unidades que r4
loop2:
        cmp r5, #0      @Si la duración de la nota es 0
        ble out         @saltar a salir
        mov r0, #BUZZER @Guardamos la posición de memoria del identificador BUZZER en r0
        mov r1, #1      @lo establecemos como parámetro de salida
        bl digitalWrite @llamamos a la función
        sub r5, r5, r4  @le restamos medio periodo a la duración total de la nota
        mov r0, r4      @esperamos medio periodo con el zumbador encendido
        bl delayMicroseconds
        mov r0, #BUZZER @Apagar el zumbador
        mov r1, #0
        bl digitalWrite
        mov r0, r4
        bl delayMicroseconds
        sub r5, r5, r4
        b loop2
out:
        pop {r4-r5, lr}
        bx lr



