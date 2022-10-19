# Abad Hernández, Javier
# Castro García, Jaime
# Grupo 708

.data
incorrecto:.asciiz "ENTRADA INCORRECTA"
cadenaInicial: .space 200
cadenaUno: .space 200
cadenaDos: .space 200
operacion: .space 6

salidaCadena: .space 1000
len:.asciiz "len"
lwc:.asciiz "lwc"
upc:.asciiz "upc"
cat:.asciiz "cat"
cmp:.asciiz "cmp"
chr:.asciiz "chr"
rchr:.asciiz "rchr"
str:.asciiz "str"
rev:.asciiz "rev"
rep:.asciiz "rep"

igual: .asciiz "IGUAL"
mayor: .asciiz "MAYOR"
menor: .asciiz "MENOR"
.text

main:
	li $v0, 8			#Lectura de una cadena
	la $a0, cadenaInicial
	li $a1, 200
	syscall
	
	la $a0, cadenaInicial	
	jal cambioSaltoPorFin
	
	la $a0, cadenaInicial
	la $a1, operacion
	la $a2, cadenaUno
	la $a3, cadenaDos

	jal separarCadenas

	
	beq $v0, -1, entrada_incorrecta
	
	
		# Compruebo que operación he elegido.
	
		comprobacion_len: 
					la $a0, operacion
					la $a1, len
					jal comparaCadena
					beqz $v0, operacion_len 
		comprobacion_lwc:
					la $a0, operacion
					la $a1, lwc
					jal comparaCadena
					beqz $v0, operacion_lwc 

		comprobacion_upc:	
					la $a0, operacion
					la $a1, upc
					jal comparaCadena
					beqz $v0, operacion_upc 
					
		comprobacion_rev:
					la $a0, operacion
					la $a1, rev
					jal comparaCadena
					beqz $v0, operacion_rev
					
								
		# Comprobación de que las cadenas que trabajan con dos operandos contienen ambos.		
		la $a0, cadenaDos
		lb $s0, 0($a0)
		ble $s0, 32, entrada_incorrecta
						
		comprobacion_str:
					la $a0, operacion
					la $a1, str
					jal comparaCadena
					beqz $v0, operacion_str
					
		comprobacion_chr:
					la $a0, operacion
					la $a1, chr
					jal comparaCadena
					beqz $v0, operacion_chr
	
		comprobacion_rchr:
					la $a0, operacion
					la $a1, rchr
					jal comparaCadena
					beqz $v0, operacion_rchr
		
		comprobacion_cat:
					la $a0, operacion
					la $a1, cat
					jal comparaCadena
					beqz $v0, operacion_cat

		comprobacion_cmp:
					la $a0, operacion
					la $a1, cmp
					jal comparaCadena
					beqz $v0, operacion_cmp
		
		comprobacion_rep:
					la $a0, operacion
					la $a1, rep
					jal comparaCadena
					beqz $v0, operacion_rep

		entrada_incorrecta:
					li $v0, 4
					la $a0, incorrecto
					syscall
					j salidaPrograma


# Realización de las funciones pertinentes dependiendo de la operación elegida.
operacion_len:
		la $a0, cadenaUno
		jal longitudCadena
		move $a0, $v0
		la $a1, salidaCadena
		jal convertir
		j finPrograma

operacion_lwc: 
		la $a0, cadenaUno
		la $a1, salidaCadena
		jal cadenaMinuscula
		j finPrograma
				
operacion_upc: 
		la $a0, cadenaUno
		la $a1, salidaCadena
		jal cadenaMayuscula
		j finPrograma
		
operacion_rev: 
		la $a0, cadenaUno
		la $a1, salidaCadena
		jal strcpy_reverse
		j finPrograma

operacion_cat:	
		la $a0, cadenaUno
		la $a1, cadenaDos
		la $a2, salidaCadena
		jal concatenarCadena
		j finPrograma
		
operacion_cmp:
		la $a0, cadenaUno
		la $a1, cadenaDos
		jal comparaCadena
		move $s0, $v0
		li $v0, 4
		beqz $s0, igualValor
		beq $s0, 1, mayorValor
		beq $s0, -1, menorValor
		igualValor:
			la $a0, igual
			syscall
			j salidaPrograma
		mayorValor:	
			la $a0, mayor
			syscall
			j salidaPrograma
		menorValor:
			la $a0, menor
			syscall
			j salidaPrograma
			
operacion_chr:
		la $a0, cadenaUno
		la $a1, cadenaDos
		jal buscarCaracter
		la $a1, salidaCadena
		jal convertir
		j finPrograma
		
operacion_rchr:
		la $a0, cadenaUno
		la $a1, cadenaDos
		jal buscarCaracterReverse
		la $a1, salidaCadena		
		jal convertir
		j finPrograma
		
operacion_str:
		la $a0, cadenaUno
		la $a1, cadenaDos
		jal buscarCadena
		move $a0, $v0
		la $a1, salidaCadena
		jal convertir
		j finPrograma

operacion_rep: 	
		la $a0, cadenaDos
		jal convertir_reverse
		beq $v0, -1, entrada_incorrecta
		la $a0, cadenaUno
		la $a2, salidaCadena
		jal repetir_cadena

finPrograma:
	li $v0, 4			#Llamada al sistema para imprimir una cadena
	la $a0, salidaCadena
	syscall
salidaPrograma:
	li $v0, 10 			#Llamada al sistema para finalizar el programa
 	syscall

#################################################################   FUNCIONES   ################################################################
		
# FUNCIÓN STRINGCOPY-REVERSE (REV):
# Copia la primera cadena en la segunda pero dandola la vuelta.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$a1: Cadena invertida.
strcpy_reverse:
		lb $t0, 0($a0)
		addi $a0, $a0, 1
		bnez $t0, strcpy_reverse
		addi $a0, $a0, -1
				
	copia_inversa:
		addi $a0, $a0, -1
		lb $t0, 0($a0)
		beqz $t0, fincpy_reverse
		sb $t0, 0($a1)
		addi $a1, $a1, 1
		j copia_inversa
	
	fincpy_reverse:
		sb $zero, 0($a1)
		jr $ra

# FUNCIÓN CAMBIO DE SALTO DE LINEA POR FINAL DE CADENA:
# Cambia el \n por \0 para marcar fin de cadena.
# Parametros de entrada:
#	-$a0: Cadena para leerla y saber su operacion	
# Parametros de salida:
#	-$a0: Cadena modificada.
cambioSaltoPorFin:
	lb $t0, 0($a0)
	addi $a0, $a0, 1
	bne $t0, 10, cambioSaltoPorFin
	sb $zero, 0($a0)
	jr $ra

# FUNCIÓN LONGITUD CADENA (LEN):
# Lee la cadena pasada por el usuario y haya su longitud en hexadecimal
# Parametros de entrada:
#	-$a0: Cadena para leerla y saber su longitud.
# Parametros de salida:
# 	-$v0: Número decimal con la longitud de la cadena.
longitudCadena:
		addi $a0, $a0, 1
		lb $t1, 0($a0)
		addi $v0, $v0, 1		
		bnez $t1, longitudCadena	#fin de cadena
		jr $ra
		
# FUNCIÓN CADENA MAYUSCULAS (UPC):
# Lee la cadena pasada por el usuario y la muestra en mayusculas
# Parametros de entrada:
#	-$a0: Cadena para leer.
# Parametros de salida:
#	-$a1: Cadena en mayusculas.
cadenaMayuscula:
   	lb  $t1, 0($a0)			#Comprobaciones para solo modificar letras minusculas
   	beq $t1, 0, salidaMayus
   	ble $t1, 96, igualMayus
   	bgt $t1, 122, igualMayus
   	addi $t1, $t1, -32
    	sb $t1, 0($a1)
igualMayus:
	sb $t1, 0($a1)
	addi $a0, $a0, 1
    	addi $a1, $a1, 1
    	j cadenaMayuscula
salidaMayus:	
	sb $zero, 0($a1)
	jr $ra	
	
# FUNCIÓN CADENA MINUSCULAS (LWC):
# Lee la cadena pasada por el usuario y la muestra en minusculas
# Parametros de entrada:
#	-$a0: Cadena para leer.
# Parametros de salida:
#	-$a1: Cadena en minusculas.
cadenaMinuscula:
   	lb  $t1, 0($a0)			#Comprobaciones para solo modificar letras mayusculas
   	beq $t1, 0, salidaMinus
   	ble $t1, 64, igualMinus
   	bgt $t1, 90, igualMinus
   	addi $t1, $t1, 32
igualMinus:
	sb $t1, 0($a1)
	addi $a0, $a0, 1
    	addi $a1, $a1, 1
    	j cadenaMinuscula
salidaMinus:
	sb $zero, 0($a1)	
	jr $ra	
###################################################################################################################################################################################
# FUNCIÓN CONCATENAR CADENA (CAT):
# Concatena las dos cadenas introducidas como parametro en una tercera.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$a2: Cadena concatenada.
concatenarCadena:
			lb $t0, 0($a0)			#Guardo primera cadena
			beqz $t0, segundaCadena
			sb $t0, 0($a2)
			addi $a0, $a0, 1
			addi $a2, $a2, 1
			j concatenarCadena
	segundaCadena:
			lb $t0, 0($a1)			#Guardo segunda cadena
			beqz $t0, finalConcatenar
			sb $t0, 0($a2)
			addi $a1, $a1, 1
			addi $a2, $a2, 1
			j segundaCadena
	finalConcatenar:
			sb $zero, 0($a2)
			jr $ra

# FUNCIÓN BUSCAR CARACTER (CHR):
# Busca la primera posición en la segunda cadena en la que se encuentra
# el primer caracter de la primera cadena comenzando la busqueda
# por el principio de la segunda cadena.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$a0: Número con la posición, si no está 0.
buscarCaracter:
	lb $t0, 0($a0)
	move $a0, $zero
	bucleBusqueda:
		lb $t1, 0($a1)
		addi $a0, $a0, 1
		beq $t0, $t1, fin_chr
		addi $a1, $a1, 1
		bnez $t1, bucleBusqueda
	noEncuentra:			
		move $a0, $zero
	fin_chr:
		jr $ra

# FUNCIÓN BUSCAR CARACTER REVERSE (RCHR):
# Busca la primera posición en la segunda cadena en la que se encuentra
# el primer caracter de la primera cadena pero comenzando la busqueda
# por el final de la segunda cadena.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$a0: Número con la posición, si no está 0.
buscarCaracterReverse:
	lb $t0, 0($a0)
	move $a0, $zero
	buscarFinalCadena:			#Me situo en el final de la segunda cadena para realizar la busqueda a la inversa
		lb $t1, 0($a1)
		addi $a1, $a1, 1
		addi $a0, $a0, 1
		bnez $t1, buscarFinalCadena
		addi $a1, $a1, -1
	busqueda_inversa:			#Realizo la busqueda a la inversa.
		addi $a1, $a1, -1
		addi $a0, $a0, -1
		lb $t1, 0($a1)
		beqz $t1, salida_rchr
		bne $t1, $t0, busqueda_inversa
	salida_rchr:
		jr $ra

# FUNCIÓN REPETIR CADENA (REP):
# Imprime en la tercera cadena la primera repetida tantas veces como 
# indique el número introducido
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: numero de repeticiones.
# Parametros de salida:
#	-$a2: Cadena ya repetida.
repetir_cadena:
		move $t0,$a0
		beqz $a1, fin_rep
		addi $a1, $a1, -1
	nuevaRepe:				#Entro cada vez que inicio de nuevo la repeticion.
		lb $t1, 0($t0)
		beqz $t1, repetir_cadena
		sb $t1, 0($a2)
		addi $t0, $t0, 1
		addi $a2, $a2, 1
		j nuevaRepe
	fin_rep:
		sb $zero, 0($a2)
		jr $ra
		
# FUNCIÓN CONVERTIR:
# Convierte un número decimal en una cadena en ASCII, mostrando el contenido
# en hexadecimal.
# Parametros de entrada:
#	-$a0: Número para convertir.
#	-$a1: Dirección de cadena resultante en hexadecimal.
# Parametros de salida:
#	-$a1: Cadena con el número en hexadecimal.
convertir:
	li $t2, 8
	inicio:
		rol $a0, $a0, 4			#Se rota 4 posiciones a la izquierda
		and $t1, $a0, 0xf
		ble $t1, 9, menorNueve
		addi $t1, $t1, 55		#Se pasa el número a ascii si es mayor que 9
		j sig
		menorNueve:
			addi $t1, $t1, 48	#Se pasa el número a ascii si es menor que 9
		sig:	
			sb $t1, 0($a1)
			addi $a1, $a1, 1
			addi $t2, $t2, -1
			bnez $t2, inicio
		salirC:
			sb $zero, 0($a1)
			jr $ra
	
# FUNCIÓN CONVERTIR REVERSE:
# Convierte un número hexadecimal en una cadena en ASCII, mostrando el contenido
# en decimal.
# Parametros de entrada:
#	-$a0: Direccion de memoria que contiene el numero en hexadecimal.
# Parametros de salida:
#	-$a1: Número en decimal.
convertir_reverse:
	move $t1, $zero
	move $t2, $zero
	lb $t0, 0($a0)
	bucle_conversion:				#Comprobaciones de que las entradas sean correctas y elección letra o numero.
		ble $t0, '0', error_conversion
		ble $t0, '9', numeros
		ble $t0, 'F', mayusculas
		ble $t0, 'Z', error_conversion
		ble $t0, 'f', minusculas
		
		error_conversion:
			addi $v0, $zero, -1
			jr $ra
		mayusculas:
			addi $t3, $zero, 'A'
			addi $t3, $t3, -10
			j operaciones_conversion
		minusculas:
			addi $t3, $zero, 'a'
			addi $t3, $t3, -10
			j operaciones_conversion
		numeros:
			addi $t3, $zero, '0'
		operaciones_conversion:
			addi $t2, $t2, 1
			sub $t0, $t0, $t3
			or $t1, $t1, $t0
			addi $a0, $a0, 1
			lb $t0, 0($a0)
			sll $t1, $t1, 4
			bnez $t0, bucle_conversion
			srl $t1, $t1, 4
	fin_conversion:
		move $a1, $t1
		jr $ra
					
# FUNCIÓN SEPARAR CADENAS:
# Separa la cadena inicial en 3 cadenas: la operacion, el operando1 y operando2
# Parametros de entrada:
#	-$a0: Cadena inicial.
# Parametros de salida:
#	-$a1: Cadena con operacion.
#	-$a2: Cadena con el operando1.
#	-$a3: Cadena con el operando2.
separarCadenas:
		move $t1, $a1
	separar:				#Separa, la primera vez separa operación.
		lb $t4, 0($a0)
		ble $t4, 32, finalCadena
		sb $t4, 0($t1)
		addi $a0, $a0, 1
		addi $t1, $t1, 1		
		j separar
	finalCadena:
		sb $zero, 0($t1)
		addi $t9, $t9, 1
		beqz $t4, finalizar
	espacio:				#Si se encuentra un espacio o tabulador, se realiza el paso a la siguiente palabra para separar.
		addi $a0, $a0, 1
		lb $t4, 0($a0)
		beqz $t4, finalizar
		ble $t4, 32, espacio
		beq $t9, 1, separar2
		beq $t9, 2, separar3
	errorEntrada:
		addi $v0, $zero, -1
		jr $ra
	separar2:				#Separar la segunda cadena, que es operando1
		move $t1, $a2
		j separar
	separar3:				#Separar la tercera cadena, que es operando2
		move $t1, $a3
		j separar
	finalizar:
		ble $t9, 1, errorEntrada	#Si no tengo mas que una cadena, es decir, operación, hay error.
		jr $ra
	

# FUNCIÓN BUSCAR CADENA (STR):
# Busca la primera posición en la segunda cadena en la que se encuentra
# la primera cadena.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$v0: Posición en la que se encuetra el comienzo de la primera cadena en la segunda cadena, si no está 0.
buscarCadena:
	addi $v0, $zero, 1
	bucleBusquedaStr:
		move $t0, $a0			# Me situo en el principio de la primera cadena.
		move $t4, $zero			# Inicio a 0 el contador de la posición de caracter de la primera cadena.
	comparoElementos:
		lb $t2, 0($t0)
		lb $t3, 0($a1)		
		beq $t2, $t3, coincideCaracter
		addi $a1, $a1, 1
		addi $v0, $v0, 1		# Contador de la posición de la segunda cadena.
		bnez $t3, bucleBusquedaStr		
	noEsta:
		move $v0, $zero
		jr $ra
	coincideCaracter:			# Comprueba mediante dos caracteres si coindice caracter a caracter una cadena con otra.
		addi $t4, $t4, 1
		beqz $t2, finalStr
		addi $a1, $a1, 1
		addi $t0, $t0, 1
		addi $v0, $v0, 1
		lb $t2, 0($t0)
		lb $t3, 0($a1)		
		beqz $t2, finalStr
		beq $t2, $t3, comparoElementos
		addi $a1, $a1, -1
		addi $v0, $v0, -1
		j bucleBusquedaStr
	finalStr:
		sub $v0, $v0, $t4		# Resto a la posición en la que me encuentro la longitud de la primera cadena, para tener donde 
		jr $ra				# empieza.
		
	
# FUNCIÓN COMPARA CADENA:
# Compara caracer a caracter ASCII las dos cadenas introducidas por parámetro
# para ver si son iguales, mayor o menor.
# Parametros de entrada:
#	-$a0: Primera cadena.
#	-$a1: Segunda cadena.
# Parametros de salida:
#	-$v0 = -1: Primera cadena es menor que la segunda.
#	-$v0 = 0: Primera cadena es igual que la segunda.
#	-$v0 = 1: Primera cadena es mayor que la segunda.
comparaCadena:
		move $t2, $zero
		move $t3, $zero
		addi $v0,$zero,-1 #iniciamos v0 en -1.
		iguales:
			lb $t2,0($a0) 
			lb $t3,0($a1) 
			bnez $t2,no_terminador 
			beqz $t3,terminador #comprobamos si alguna de las cadenas ha terminado.
		no_terminador:
			addi $a0,$a0,1 
			addi $a1,$a1,1 
			beq $t2,$t3,iguales #comprobamos si son iguales.
			bgt $t2,$t3,mayorCopy #si a0>a1 se va a mayor.
			jr $ra
		mayorCopy:
			addi $v0,$zero,1 
			jr $ra
		terminador:
			move $v0,$zero 
			jr $ra
				


