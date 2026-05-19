// FUNCIONES DEBUG VARIABLES MEMORIA ENTRE OTRAS COSAS

Funcion DebugTokens(tokens, cantidad)
    Escribir "===== TOKENS ====="
	
    Para i <- 1 Hasta cantidad Hacer
        Si tokens[i] <> "" Entonces
            Escribir "[" + ConvertirATexto(i) + "] = " + tokens[i]
        FinSi
    FinPara
	
    Escribir "=================="
FinFuncion


Funcion DebugInstruccion(instruccion)
    Escribir "===== INSTRUCCION ====="
	
    Para i <- 1 Hasta 6 Hacer
        Si instruccion[i] <> "" Entonces
            Escribir "[" + ConvertirATexto(i) + "] = " + instruccion[i]
        FinSi
    FinPara
	
    Escribir "======================="
FinFuncion


Funcion DebugPointers(pointers, VARIABLES_CONST)
    Escribir "===== POINTERS ====="
	
    Para i <- 1 Hasta VARIABLES_CONST Hacer
        Si pointers[i,1] <> "0" Entonces
            Escribir pointers[i,1] + " -> " + pointers[i,2]
        FinSi
    FinPara
	
    Escribir "===================="
FinFuncion


Funcion DebugMemoria(memoria, inicio, final)
    Escribir "===== MEMORIA ====="
	
    Para i <- inicio Hasta final Hacer
        Si memoria[i,3] = 0 Entonces
            tipostr <- "INT"
        FinSi
        Si memoria[i,3] = 1 Entonces
            tipostr <- "ASCII"
        FinSi
        Si memoria[i,3] = 2 Entonces
            tipostr <- "PTR"
        FinSi
        Escribir "[" + ConvertirATexto(i) + "] valor=" + ConvertirATexto(memoria[i,1]) + " usado=" + ConvertirATexto(memoria[i,2]) + " tipo=" + tipostr
    FinPara
	
    Escribir "==================="
FinFuncion


Funcion DebugStringMemoria(memoria, ptr)
    Definir texto Como Cadena
	
    texto <- ""
    final <- Falso
    i <- 0
	
    Mientras final = Falso Hacer
        Si memoria[ptr+i,1] = 0 Entonces
            final <- Verdadero
        SiNo
            texto <- texto + DecodificarAscii(memoria[ptr+i,1])
        FinSi
		
        i <- i + 1
    FinMientras
	
    Escribir "STRING MEMORIA -> " + texto
FinFuncion


Funcion cantidad <- Tokenizar(lineas, tokens, nlineas)
    Definir i, k, j Como Entero
    Definir buffer, caracter Como Cadena
    Definir enBloque Como Logico
	
    j <- 1
    enBloque <- Falso
	
    Para k <- 1 Hasta nlineas
        buffer <- ""
		
        Para i <- 1 Hasta Longitud(lineas[k])
            caracter <- Subcadena(lineas[k], i, i)
			
            Si caracter = "{" Entonces
                enBloque <- Verdadero
                buffer <- ""
            Sino
                Si caracter = "}" Entonces
                    enBloque <- Falso
                    Si buffer <> "" Entonces
                        tokens[j] <- buffer
                        j <- j + 1
                        buffer <- ""
                    FinSi
                Sino
                    Si enBloque Entonces
                        buffer <- buffer + caracter
                    Sino
                        Si caracter <> " " Y caracter <> "," Y caracter <> ";" Entonces
                            buffer <- buffer + caracter
                        Sino
                            Si buffer <> "" Entonces
                                tokens[j] <- buffer
                                j <- j + 1
                                buffer <- ""
                            FinSi
                            Si caracter = ";" Entonces
                                tokens[j] <- ";"
                                j <- j + 1
                            FinSi
                        FinSi
                    FinSi
                FinSi
            FinSi
        FinPara
		
        Si buffer <> "" Entonces
            tokens[j] <- buffer
            j <- j + 1
        FinSi
    FinPara
	
    cantidad <- j - 1
FinFuncion


Funcion Separar_instruccion(tokens, instruccion, index, cantidad)
    aux1 <- Verdadero
	
    ahora <- -1
    inicio <- 0
    final <- 0
	
    i <- 1
    Mientras i <= cantidad Y aux1 Hacer
        Si tokens[i] = ";" Entonces
            ahora <- ahora + 1
            Si ahora = index - 1 Entonces
                inicio <- i
            FinSi
        FinSi
		
        Si ahora = index Entonces
            final <- i
            k <- 1
            Para j <- inicio + 1 Hasta final - 1 Hacer
                instruccion[k] <- tokens[j]
                k <- k + 1
            FinPara
            aux1 <- Falso
        FinSi
		
        i <- i + 1
    FinMientras
FinFuncion


Funcion lineas <- Numero_Lineas(tokens, cantidad)
    lineas <- -1
	
    Para i <- 1 Hasta cantidad Hacer
        Si tokens[i] = ";" Entonces
            lineas <- lineas + 1
        FinSi
    FinPara
FinFuncion


Funcion codigo <- CodificarAscii(caracter)
    Definir letras Como Cadena
	
    letras <- " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    codigo <- -1
	
    Para i <- 1 Hasta Longitud(letras)
        Si Subcadena(letras, i, i) = caracter Entonces
            codigo <- i + 31
        FinSi
    FinPara
FinFuncion


Funcion carac <- DecodificarAscii(codigo)
    Definir letras Como Cadena
	
    letras <- " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	
    Si codigo >= 32 Y codigo <= Longitud(letras)+31 Entonces
        carac <- Subcadena(letras, codigo-31, codigo-31)
    SiNo
        carac <- ""
    FinSi
FinFuncion

Funcion ptr <- ReservearMemoria(cantidad,memoria)
	
	Encontrado <- Falso
	ioffset <- 1
	
	Mientras Encontrado = Falso Hacer
		
		valido = 1
		
        Si memoria[ioffset,2] = 0 Entonces
            Para l <- 1 Hasta cantidad Hacer
                Si l = cantidad Y valido = cantidad  Entonces
                    encontrado = Verdadero
                    ptr <- ioffset
					
                    Para k <- 0 Hasta cantidad - 1 Hacer
						
						memoria[ptr+k,1] = 0
						memoria[ptr+k,2] = 1
						memoria[ptr+k,3] = 0
						
                    FinPara
                FinSi
				
                Si memoria[ioffset+l,2] = 0 Y valido <> -1 Entonces
                    valido = valido + 1
                SiNo
                    valido = -1
                FinSi
            FinPara
        FinSi
		
        ioffset <- ioffset + 1
		
	FinMientras
FinFuncion


Funcion ptr <- asignar_espacio_memoria_car(mensaje, longitudmensaje, memoria)
    Definir Carac Como Entero
	
    encontrado = Falso
    ioffset <- 1
	
    Mientras encontrado = Falso Hacer
        valido = 0
		
        Si memoria[ioffset,2] = 0 Entonces
            Para l <- 1 Hasta longitudmensaje Hacer
                Si l = longitudmensaje Y valido = longitudmensaje - 1 Entonces
                    encontrado = Verdadero
                    ptr <- ioffset
					
                    Para k <- 0 Hasta longitudmensaje Hacer
                        Si k = longitudmensaje Entonces
                            memoria[ptr+k,1] = 0
                            memoria[ptr+k,2] = 1
							memoria[ptr+k,3] = 1
                        SiNo
                            Carac <- CodificarAscii(Subcadena(mensaje, k+1, k+1))
                            memoria[ptr+k,1] = Carac
                            memoria[ptr+k,2] = 1
							memoria[ptr+k,3] = 1
                        FinSi
                    FinPara
                FinSi
				
                Si memoria[ioffset+l,2] = 0 Y valido <> -1 Entonces
                    valido = valido + 1
                SiNo
                    valido = -1
                FinSi
            FinPara
        FinSi
		
        ioffset <- ioffset + 1
    FinMientras
FinFuncion


Funcion ptr <- asignar_espacio_memoria_int(mensaje, memoria)
    encontrado = Falso
    ioffset <- 1
	
    Mientras encontrado = Falso Hacer
        Si memoria[ioffset,2] = 0 Entonces
            ptr <- ioffset
            encontrado = Verdadero
            memoria[ioffset,1] = ConvertirANumero(mensaje)
            memoria[ioffset,2] = 1
			memoria[ioffset,3] = 0
        SiNo
            ioffset <- ioffset + 1
        FinSi
    FinMientras
FinFuncion


Funcion ObtenerLabels(tokens, nlineas, lineas, pointers)
    termino = Falso
    i <- 1
	
    Mientras termino = Falso Hacer
        tokentrabajando <- tokens[i]
		
        Si Subcadena(tokentrabajando, Longitud(tokentrabajando), Longitud(tokentrabajando)) = ":" Entonces
            contador <- 0
			
            Para j <- 1 Hasta nlineas Hacer
                Si lineas[j] <> "" Entonces
                    contador <- contador + 1
                FinSi
				
                Si tokentrabajando = Subcadena(lineas[j], 1, Longitud(lineas[j])-1) Entonces
                    ptr <- contador
                FinSi
            FinPara
			
            asignarvariable(Subcadena(tokentrabajando, 1, Longitud(tokentrabajando)-1), ConvertirATexto(ptr), pointers)
        FinSi
		
        Si tokentrabajando = "" Entonces
            termino = Verdadero
        FinSi
		
        i <- i + 1
    FinMientras
FinFuncion


Funcion ReEscribirBytes(elcarac, puntero, memoria)
	si memoria[puntero,2] <> 0 Entonces
		memoria[puntero,1] <- CodificarAscii(elcarac)
	FinSi
FinFuncion



Funcion reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)
    Para i <- 1 Hasta VARIABLES_CONST Hacer
        pointers[i,1] = "0"
        pointers[i,2] = "0"
    FinPara
	
    Para i <- 1 Hasta MAXINSTRUCIONES_CONST Hacer
        instruccion[i] = "0"
    FinPara
	
	Para i <- 1 Hasta MEMORIA_CONST Hacer
		memoria[i,1] = 0
		memoria[i,2] = 0
		memoria[i,3] = 0
	FinPara
FinFuncion


Funcion asignarvariable(variable, puntero, pointers)
    encontrado = Falso
    i <- 1
	
    Mientras encontrado = Falso Hacer
        Si pointers[i,2] = "0" Entonces
            pointers[i,1] = variable
            pointers[i,2] = puntero
            encontrado = Verdadero
        FinSi
		
        i <- i + 1
    FinMientras
FinFuncion


Funcion ptr <- BuscarPunteroVariable(variable, pointers)
	
	// variable puede se como msg o msg+10 
	
    encontrado = Falso
    ioffset <- 1
	mas <- Falso
	num = "0"
	temp <- variable
	
	para i<-1 Hasta Longitud(temp) Hacer
		si mas Entonces
			num = num + Subcadena(temp,i,i)
		FinSi
		si mas = Falso Entonces
			si Subcadena(temp, i,i) = "+" Entonces
				variable = Subcadena(temp,1,i-1)
				mas = Verdadero
			FinSi
		FinSi
	FinPara
	
	
	
    Mientras encontrado = Falso Hacer
        Si pointers[ioffset,1] = variable Entonces
            ptr <- ConvertirANumero(pointers[ioffset,2]) + ConvertirANumero(num)
            encontrado = Verdadero
        FinSi
		
        ioffset <- ioffset + 1
    FinMientras
FinFuncion

Funcion esnumero <- CheckearNumero(num) 
	ListaNumeros = "1234567890"
	esnumero = Verdadero
	para j<-1 Hasta Longitud(num)
		para i<-1 Hasta 10
			si Subcadena(ListaNumeros, i,i) = Subcadena(num, j,j) Entonces
				encontrado = 1
			FinSi
		FinPara
		si encontrado <> 1 Entonces
			esnumero = Falso
		FinSi
		encontrado = 0
	FinPara
FinFuncion

Funcion syscall(sysc, arg1, arg2, arg3, pointers, memoria)
	
    syscS <- ConvertirANumero(sysc)
    arg1S <- ConvertirANumero(arg1)
	
	
	arg2S <- ConvertirANumero(arg2)
	
	
	arg3S <- ConvertirANumero(arg3)
	
	
    Segun sysc Hacer
		"3": 
			
		"4":
			
			palabra = ""
			
			Para i <- 0 Hasta arg3S-1 Hacer
				letra = DecodificarAscii(memoria[arg2S+i,1])
				palabra = palabra + letra
			FinPara
			
			Escribir palabra
			
    FinSegun
	
	
FinFuncion

Algoritmo CPU
	
	// REGISTROS:
	// eax = syscall
	// ebx = 1� argumento
	// ecx = 2� argumento
	// edx = 3� argumento
	
	
	// eip = seguimiento de instrucciones
	
	
    MEMORIA_CONST = 1024
    VARIABLES_CONST = 64
    MAXINSTRUCIONES_CONST = 6
	
    Definir rip Como Cadena
    Definir eip Como Entero
	
	// TIPO_INT = 0
	// TIPO_ASCII = 1
	// TIPO_POINTER = 2
	
    Definir memoria Como Entero
    Dimension memoria[MEMORIA_CONST,3]
	
    Definir lineas, tokens, instruccion, pointers Como Cadena
    Definir cantidad, i, nlineas, tam Como Entero
	
    nlineas <- 100
    typesection = 0
	locked <- Verdadero
	
    Dimension lineas[nlineas]
    Dimension tokens[MEMORIA_CONST/2]
    Dimension instruccion[MAXINSTRUCIONES_CONST]
    Dimension pointers[VARIABLES_CONST,2]
	
    reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)
	
    lineas[1] <- ";"
	
	lineas[2] <- "section .data;"
	lineas[3] <- "msg db {Hola Mundo}, 10;"
	lineas[4] <- "msg_len equ msg;"
	
	lineas[5] <- "section .text;"
	lineas[6] <- "global _start;"
	lineas[7] <- "_start:;"
	
	lineas[8] <- "mov eax, 4;"
	lineas[9] <- "mov ebx, 1;"
	lineas[10] <- "mov ecx, msg;"
	lineas[11] <- "mov edx, msg_len;"
	lineas[12] <- "int 0x80;"
	
	lineas[13] <- "mov byte [msg], {A};"
	lineas[14] <- "mov byte [msg+1], {d};"
	lineas[15] <- "mov byte [msg+2], {i};"
	lineas[16] <- "mov byte [msg+3], {o};"
	lineas[17] <- "mov byte [msg+4], {s};"
	lineas[18] <- "mov byte [msg+5], { };"
	
	lineas[19] <- "mov eax, 4;"
	lineas[20] <- "mov ebx, 1;"
	lineas[21] <- "mov ecx, msg;"
	lineas[22] <- "mov edx, msg_len;"
	lineas[23] <- "int 0x80;"
	
    cantidad <- Tokenizar(lineas, tokens, nlineas)
	
    nlineasReal = Numero_Lineas(tokens, cantidad)
	
    ObtenerLabels(tokens, nlineasReal, lineas, pointers)
	
	puntero <- asignar_espacio_memoria_int("0", memoria)
	asignarvariable("eax", ConvertirATexto(puntero), pointers)
	puntero <- asignar_espacio_memoria_int("0", memoria)
	asignarvariable("ebx", ConvertirATexto(puntero), pointers)
	puntero <- asignar_espacio_memoria_int("0", memoria)
	asignarvariable("ecx", ConvertirATexto(puntero), pointers)
	puntero <- asignar_espacio_memoria_int("0", memoria)
	asignarvariable("edx", ConvertirATexto(puntero), pointers)
	
	
    // PRUEBAS
	
    //DebugTokens(tokens, cantidad)
    //DebugPointers(pointers, VARIABLES_CONST)
    //DebugMemoria(memoria, 1, 20)
	
	
    Para eip <- 1 Hasta nlineasReal Hacer
		
        Separar_Instruccion(tokens, instruccion, eip, cantidad)
		
        //DebugInstruccion(instruccion)
		
		//DebugMemoria(memoria, 1, 20)
		//DebugStringMemoria(memoria, puntero)
		//DebugPointers(pointers, VARIABLES_CONST)
		
        Si typesection = 2 Entonces
			
			
			// Instrucciones posibles
			
			// db = Strings
			// dw, dq y dt ints,
			// equ ver el tama�o de una variable
			
			// msg db hola mundo, 0 / significa en msg define hola mundo, acabando con un 0
			// 0 = fin de una string
			// 1 = salto de linea
			
            Segun instruccion[2] Hacer
				
                "db":
                    puntero = asignar_espacio_memoria_car(instruccion[3], Longitud(instruccion[3]), memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
                "dw":
                    puntero = asignar_espacio_memoria_int(instruccion[3], memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
                "dd":
                    puntero = asignar_espacio_memoria_int(instruccion[3], memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
                "dq":
                    puntero = asignar_espacio_memoria_int(instruccion[3], memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
                "dt":
                    puntero = asignar_espacio_memoria_car(instruccion[3], Longitud(instruccion[3]), memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
                "equ":
                    puntero_variable = BuscarPunteroVariable(instruccion[3], pointers)
					
                    final = Falso
                    auxiliar1 = 0
					
                    Mientras final = Falso Hacer
                        Si memoria[puntero_variable+auxiliar1,1] = 0 O memoria[puntero_variable+auxiliar1,1] = 1 Entonces
                            final = Verdadero
                        FinSi
						
                        auxiliar1 <- auxiliar1 + 1
                    FinMientras
					
                    longit = auxiliar1
					
                    puntero = asignar_espacio_memoria_int(ConvertirATexto(longit), memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
					
            FinSegun
			
        FinSi
		
        Si typesection = 1 Entonces
			
			si locked = Verdadero
				Segun instruccion[1] Hacer
					"global":
						rip = instruccion[2] + ":"
				FinSegun
				
				si instruccion[1] = rip Entonces
					locked = Falso
				FinSi
			SiNo
				Segun instruccion[1] Hacer
					"mov":
						si instruccion[2] = "byte" Entonces
							si Subcadena(instruccion[3],1,1) = "[" y Subcadena(instruccion[3],Longitud(instruccion[3]),Longitud(instruccion[3])) = "]" Entonces
								puntero = BuscarPunteroVariable(Subcadena(instruccion[3],2,Longitud(instruccion[3])-1), pointers)
								memoria[puntero,1] = CodificarAscii(instruccion[4])
								memoria[puntero,3] = 2
							FinSi
						SiNo
							puntero = BuscarPunteroVariable(instruccion[2], pointers)
							
							esnumero = CheckearNumero(instruccion[3])
							Si esnumero = Falso Entonces
								
								encontrado = Falso
								p <- 1
								Mientras encontrado = Falso Hacer
									
									si Subcadena(instruccion[3],1,1) <> "[" Entonces
										
										Si pointers[p,1] = instruccion[3] Entonces
											aux3 = ConvertirANumero(pointers[p,2])
											encontrado = Verdadero
										FinSi
									SiNo
										nombrevar <- Subcadena(instruccion[3], 2, Longitud(instruccion[3])-1)
										Si pointers[p,1] = nombrevar Entonces
											aux3 = ConvertirANumero(pointers[p,2])
											encontrado = Verdadero
										FinSi
										
									FinSi
									p <- p + 1
									
								FinMientras
								
								
								si Subcadena(instruccion[3],1,1) = "[" Y Subcadena(instruccion[3],Longitud(instruccion[3]),Longitud(instruccion[3])) = "]" Entonces
									
									memoria[puntero, 1] <- memoria[aux3,1]
									memoria[puntero, 3] <- memoria[aux3,3]
									aux4 = Verdadero
									
								SiNo
									
									memoria[puntero,1] <- aux3
									memoria[puntero,3] <- 2
								FinSi
								
							SiNo
								
								memoria[puntero, 1] <- ConvertirANumero(instruccion[3])
								
							FinSi
						FinSi
						
						
						
					"int":
						si instruccion[2] = "0x80" Entonces
							ptr_eax <- BuscarPunteroVariable("eax", pointers)
							ptr_ebx <- BuscarPunteroVariable("ebx", pointers)
							ptr_ecx <- BuscarPunteroVariable("ecx", pointers)
							ptr_edx <- BuscarPunteroVariable("edx", pointers)
							syscall(ConvertirATexto(memoria[ptr_eax,1]), ConvertirATexto(memoria[ptr_ebx,1]), ConvertirATexto(memoria[ptr_ecx,1]), ConvertirATexto(memoria[ptr_edx,1]), pointers, memoria)
						FinSi
				FinSegun
			FinSi
			
        FinSi
		
		
		si typesection = 3 Entonces
			si instruccion[2] = "resb" Entonces
				puntero <- ReservearMemoria(ConvertirANumero(Instruccion[3]),memoria)
				asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
			FinSi
		FinSi
		
        Si instruccion[1] = "section" Entonces
            Si instruccion[2] = ".data" Entonces
                typesection = 2
            FinSi
			
            Si instruccion[2] = ".text" Entonces
                typesection = 1
            FinSi
			
			si instruccion[2] = ".bss" Entonces
				typesection = 3
			FinSi
        FinSi
		
		
        Para i <- 1 Hasta 6 Hacer
            instruccion[i] = ""
        FinPara
		
    FinPara
	
FinAlgoritmo
