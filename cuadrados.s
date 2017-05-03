.text

cuad:	@r0 -> n @r4 -> res
        push {r4, lr}	
        cmp r0, #1	@si r0 es igual a 1
        bgt call	@si es mayor salta a call
        mov r4, r0	@muevo el valor de r0 a r4 
        b fin		@salto a fin
call:   mul r4, r0, r0  @i^2
        sub r0, r0, #1  @n-1
        bl cuad         @cuad
        add r4, r4, r0  @res = i^2 + cuad(i-1);
fin:    mov r0, r4	@guardo el resultado en r0
	pop {r4, lr}	@pop de preservador y lr
	bx lr		@salimos de la funcion

