.text
fib:    @r0 será nuestro valor n de la funcion.
        push {r4}       @guardamos el preservado r4
        cmp r0, #1      @comparamos r0 con 1
        moveq r4, #1    @si el cmp son iguales, guardar en r4 el valor #1
        movlt r4, #0    @si el cmp es menor o igual, guardar en r4 el valor #0
        beq final       @si el cmp el flag es igual, entonces saltar a final
        blt final       @si el cmp el flag es menor o igual, entonces saltar a final
        mov r1, #1      @mover a r1 el valor 1
        mov r2, #0      @R1, R2 ant1 y ant2
        mov r3, #2      @R3 contador
loop:   cmp r3, r0
        bgt final       
        add r4, r1, r2  @R4 valor actual
        mov r2, r1
        mov r1, r4
        add r3, r3, #1 
        b loop           
final:  mov r0, r4
        pop {r4}
        bx lr
