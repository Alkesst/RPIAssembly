@This code it's supposed to be a calculator in assembly code..
@For this code you'll need the libberry.s and the library witingPi.s found at http://wiringpi.com
.data
.include "wiringPiPins.s"
.include "libberry.s"
.text
.global main
main:
      push {lr}
      bl opperand
      mov r4, r0
      bl opperand
      mov r5, r0
      add r0, r4, r5
      bl setLeds
      pop {lr}
      bx lr

endmain:
      bx lr


opperand:
			push {lr}
			bl initBerry
			mov r2, #BUTTON1
			mov r3, #BUTTON2
while:
			cmp r3, #1
			beq outwhile
			cmp r2, #1
			bne outwhile
			mov r0, #0
			add r0, r0, #0b1
			bl setLeds
			b while
outwhile:
			push {r0}
			ldr r0, =0b100000110
			ldr r1, =0b1111101000
			bl playNote
			pop {r0}
			pop {lr}
			bx lr
