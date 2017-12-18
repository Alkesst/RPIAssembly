@ MADE BY MELCHOR629
.set GPFBASE, 0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPFSEL3, 0x0C
.set GPFSEL4, 0x10
.set GPFSEL5, 0x14
.set GPFSEL6, 0x18

.set GPFSET0, 0x1C @Selector Enciende un pin (0-31)
.set GPFSET1, 0x20 @Selector Enciende un pin (32-53)

.set GPCLR0, 0x28 @Selector Apaga un pin (0-31)
.set GPCLR1, 0x2C @Selector Apaga un pin (32-53)

.set GPLEV0,  0x34 @Estados de los pines (0-31) 0 -> 0V 1 -> 3.3V
.set GPLEV1,  0x38 @ "       "  "    "   (31-53)

.set GPEDS0,  0x40 @Detectar (R) que pin ha provocado una interrupción o...
.set GPEDS1,  0x44 @Indicar que ya se ha procesado (W) la interrupción para 1 pin

.set GPREN0,  0x4C @Selector de pines cuyos cambios de flanco de subida serán
.set GPREN1,  0x50 @notificados mediante una interrupción

.set GPFEN0,  0x58 @Igual que GPREN pero con el flanco de bajada
.set GPFEN1,  0x5C

.set GPHEN0,  0x64 @Igual que GPREN pero con nivel alto (3.3V)
.set GPHEN1,  0x68

.set GPLEN0,  0x70 @Igual que GPREN pero con nivel bajo (0V)
.set GPLEN1,  0x74

.set GPAREN0, 0x7C @Igual que GPREN pero permite detectar pulsos de poca
.set GPAREN1, 0x80 @duración

.set GPAFEN0, 0x88 @Igual que GPFEN pero permite detectar pulsos de poca
.set GPAFEN1, 0x8C @duración

.set GPPUD,   0x94 @Conecta resistencias de pull-up (bits válidos #imm & 3)
.set GPPUDCLK0, 0x98 @Conecta resistencias de pull-down sobre los pines deseados
.set GPPUDCLK1, 0x9C

.set STBASE,  0x3F003000 @Dirección base para System Timer
.set STCS,    0x00 @Comparator Selector (para saber que Comparador ha lanzado la RTI)
.set STCLO,   0x04 @parte baja del contador de 64 bits
.set STCHI,   0x08 @parte alta del contador de 64 bits
.set STC0,    0x0C @Comparador 1 (GPU)
.set STC1,    0x10 @Comparador 2
.set STC2,    0x14 @Comparador 3 (GPU)
.set STC3,    0x18 @Comparador 4

.set INTBASE, 0x3F00B200
.set INTPEIRQB, 0x00 @Para comprobar que ha provocado el IRQ
.set INTPEIRQ1, 0x04
.set INTPEIRQ2, 0x08
.set INTFIQCON, 0x0C @Control para el FIQ: formato EIIIIIII (Enable) (IRQnum)
.set INTENIRQ1, 0x10 @Para activar IRQs determinados
.set INTENIRQ2, 0x14
.set INTENIRQB, 0x18
.set INTDIIRQ1, 0x1C @Para desactivar IRQs determinados
.set INTDIIRQ2, 0x20
.set INTDIIRQB, 0x24

/**
 *  Boton 1: 2   L4 (Y): 17   L2 (R): 10
 *  Boton 2: 3   L6 (G): 27   L1 (R): 9
 *  Buzzer:  4   L5 (G): 22   L3 (Y): 11
 **/

/* Poner un pin como entrada: 000
   Poner un pin como salida:  001 */

/* GPSEL   xx999888777666555444333222111000 */

/*         33222222222211111111110000000000 */
/* GPSET   10987654321098765432109876543210 */

/*         33222222222211111111110000000000 */
/* GPCLR   10987654321098765432109876543210 */

/* La tabla de interrupciones se almacena en la dirección 0x0 y contiene
 * una instrucción de salto a la RTI correspondiente. RTI:
 * push {regs} @ se guardan cualquier registro excepto los propios del modo
 *  ...
 * pop {regs}
 * subs pc, lr, #4 (si es error de datos, es un #8)
 * La siguiente macro es para escribir las rti en la direccion de la tabla
 */
.macro  ADDISR vector, dirIsr
    ldr r1, =(\dirIsr - \vector + 0xA7fffffB)
    ROR r1, #2
    str r1, [r0, #\vector]
.endm
/**
 *  Nosotros usaremos la dirección 0x4000 como pila del FIQ, 0x8000 para IRQ
 *  y la 0x8000000 para el modo supervisor (kernel). Las interrupciones por
 *  defecto están desactivadas. Si se (re)configura un GPIO, hay que hacerlo
 *  con las interrpciones desactivadas.
 *  Cada IRQ se pueden desactivar y activar a placer con el grupo Enable y
 *  Disable. Para saber que ha sido la causa del IRQ, se mira el grupo Pending.
 *  Para poder usar bien las interrupciones, hay que inicializar el valor de la
 *  pila en cada modo. Para ello, cambiamos el modo a la fuerza del CPSR y
 *  escribimos el nuevo valor de SP.
 **/

/**
 * Using these starting files, the Raspberry Pi3 goes to a new special mode
 * denoted "v7-Hypervisor (HYP)". This mode does not allow to change to IRQ
 * mode or FIQ mode and thus, we have to move the processor from HYP mode to
 * supervisor mode (SVC) which is the defalult mode of the Raspberry Pi 1 & 2.
 **/
.macro RPI3
    mrs r0,cpsr
    mov r0, #0b11010011   @ Mode SVC, FIQ&IRQ disable
    msr spsr_cxsf, r0
    add r0, pc, #4
    msr ELR_hyp, r0
    eret
    mov r0, #0
.endm
