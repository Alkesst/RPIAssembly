@This code it's supposed to be a calculator in assembly code..
@For this code you'll need the libberry.s and the library witingPi.s found at http://wiringpi.com
.data
.include "wiringPiPins.s"
.text
.global main
main:
	push {lr}
	bl initBerry
	bl opperand
	mov r4, r0
	bl initBerry
	bl opperand
	mov r5, r0
	add r0, r4, r5
	bl setLeds
	ldr r0, =5000
	bl delay
	mov r0, #0
	bl setLeds
	pop {lr}
	bx lr


opperand:
	push {r4-r6, lr}
      mov r6, #0
	mov r4, #BUTTON1
	mov r5, #BUTTON2
while:
	mov r0, r5
	bl digitalRead
	cmp r0, #0
	beq outwhile
	mov r0, r4
	bl digitalRead
	cmp r0, #0
	bne while
	add r6, r6, #0b1
	mov r0, r6
	bl setLeds
bucl:
	mov r0, r4
	bl digitalRead
	cmp r0, #0
	beq bucl
	ldr r0, =7500
	bl delayMicroseconds
	bne while
outwhile:
	push {r0}
	ldr r0, =0b100000110
	ldr r1, =0b1111101000
	bl playNote
	pop {r0}
      	mov r0, r6
	pop {r4-r6, lr}
	bx lr
