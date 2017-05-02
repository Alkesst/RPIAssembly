@This code it's supposed to be a calculator in assembly code..
@For this code you'll need the libberry.s
.text
.global main
main:		
			bl initBerry
			mov r2, #BUTTON1
			mov r3, #BUTTON2
while:		
			cmp r3, #1
			beq outwhile
			cmp r2, #1
			bneq outwhile		
			mov r0, #0
			add r0, r0, #0b1
			bl setLeds		
			b while
outwhile:	
