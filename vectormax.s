.data
tam:	.word 8
datos:	.word -2, -4, -6, -8, -2, -4, -6, -7
res:	.word 0

.text
.global main
main:	@r0 -> temp, r1 -> contador, r2 -> array de datos, r3 -> máximo, r4 -> temp
	ldr r0, =tam	    	@Guardamos en r0 la posición de memoria de tam
	ldr r1, [r0]		@R1 tamaño del vector  
	ldr r2, =datos		@Direccion de memoria donde esta el primer valor
       	ldr r3, [r2], #4	@Guardamos en r3 el valor que hay en la pos de memoria r2 y lo aumentamos #4
        sub r1, r1, #1		@Como le hemos sumado 1 pos a r2, restamos 1 al tamaño
loop:	
	cmp r1, #0		@Si r1 es 0
	beq salir   		@salimos del loop
	ldr r4, [r2], #4	@Cargamos en r4 el valor de memoria de r2 y le aumentamos #4
	cmp r4, r3		@si r4 es mayor que r3
	movgt r3, r4		@guardo su valor en r3
	sub r1, r1, #1		@resto 1 en el tamaño del array
	b loop		        
salir:	
	ldr r0, =res		
	str r3, [r0]		
	bx lr
