
.data
	.word 0
uno:	.word 1
cuatro:	.word 4
SAD:	.word 0
tam:	.word 4
pos:	.word 24
arrA:	.word 25, -3, -6, 1
arrB:	.word 23, -1, -4, -1


.text
main:	
	lw $9, tam($0)			#$9 vale el tamaño de los arrays
	add $13, $0, $0			#inicializo $13 a 0
	lw $14, cuatro($0)		#inicializo $14 a la pos de memoria cuatro:
	lw $15, uno($0)			#inicializo $15 a la pos de memoria uno:
	add $10, $9, $9			#
	add $10, $10, $9		#
	add $10, $10, $9		# Inicialicamos $10 a 4*n (4 veces el tamaño)	
	sub $19, $19, $19		#inicializo $19 a 0
	lw $8, pos($0)			#introduzco en $8 el puntero
	add $16, $8, $10		#calculo el puntero para el segundo vector y lo guardo en $16
for:
	lw $11, 0($8)			#en $11 guardamos el primer elemento del array accediendo de manera indirecta (puntero); en $11 guardamos el elemento que hay en 0 con un desplazamiento de $8
	lw $10, 0($16)			#en $10 guardamos el primer elemento del array accediendi de manera indirecta
	sub $17, $11, $10		#en $17 guardamos el resultado de la resta de ambos valores
	slt $18, $17, $0		#si $17 - $0 es positivo, en $18 se guarda un cero
	beq $18, $0, noot		#si $18 == 0, saltamos a noot:
	sub $17, $0, $17		#resto a 0, -$17, por tanto, si el número es negativo, se transforma en positivo.
noot:	
	add $19, $17, $19		#$19 es el resultado de la suma en valor absoluto de la resta de todos los elementos de los vectores
	add $8, $8, $14			#incrementamos $8 en $14 (4)
	add $16, $16, $14		#incrementamos $16 en $14 (4)
	sub $9, $9, $15			#resto a $9 el valor $15 (1)
	beq $9, $0, exit		#si $9 == 0; salgo 
	j for				#saltamos al label for
exit:	
	sw $19, SAD($0)			#guardamos $19 en el label SAD con desplazamiento $0
	
	nop
