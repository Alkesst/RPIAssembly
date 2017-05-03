.data

string: .asciz "Esto es una prueba 1, 2, 3"

.text

main:  	ldr a1, =string
        bl ucase
        mov a1,#0
        mov v4,#1
        swi #0
		
ucase:	

loop:	ldrb r1, [r0] 
		cmp r1,#0 
		beq out
		cmp r1, #'a' 
		subhs r1,r1,#('a'-'A') 		
		strb r1, [r0] 
		add r0,r0,#1 
		b loop

out:	mov pc, lr	
