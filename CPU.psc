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


Funcion DebugRegistros(registros)
    Escribir "===== REGISTROS ====="
    Escribir "eax = " + registros[1]
    Escribir "ebx = " + registros[2]
    Escribir "ecx = " + registros[3]
    Escribir "edx = " + registros[4]
    Escribir "====================="
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
        Escribir "[" + ConvertirATexto(i) + "] valor=" + ConvertirATexto(memoria[i,1]) + " usado=" + ConvertirATexto(memoria[i,2])
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


Funcion indice <- Obtener_Registro(registro)
    Segun registro Hacer
        "eax":
            indice <- 1
        "ebx":
            indice <- 2
        "ecx":
            indice <- 3
        "edx":
            indice <- 4
        De Otro Modo:
            indice <- -1
    FinSegun
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
                        SiNo
                            Carac <- CodificarAscii(Subcadena(mensaje, k+1, k+1))
                            memoria[ptr+k,1] = Carac
                            memoria[ptr+k,2] = 1
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
            memoria[ioffset,1] = mensaje
            memoria[ioffset,2] = 1
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


Funcion reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)
    Para i <- 1 Hasta VARIABLES_CONST Hacer
        pointers[i,1] = "0"
        pointers[i,2] = "0"
    FinPara
	
    Para i <- 1 Hasta MAXINSTRUCIONES_CONST Hacer
        instruccion[i] = "0"
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
    encontrado = Falso
    ioffset <- 1
	
    Mientras encontrado = Falso Hacer
        Si pointers[ioffset,1] = variable Entonces
            ptr <- ConvertirANumero(pointers[ioffset,2])
            encontrado = Verdadero
        FinSi
		
        ioffset <- ioffset + 1
    FinMientras
FinFuncion

Funcion esnumero <- CheckearNumero(num) 
	ListaNumeros = "1234567890"
	esnumero = Verdadero
	para j<-1 Hasta Longitud(num)
		para i<-1 Hasta 9
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
    i <- 1
	
    esnumero = CheckearNumero(arg2)
    Si esnumero = Verdadero Entonces
        arg2S <- ConvertirANumero(arg2)
    SiNo
        encontrado = Falso
        Mientras encontrado = Falso Hacer
            Si pointers[i,1] = arg2 Entonces
                arg2S = ConvertirANumero(pointers[i,2])
                encontrado = Verdadero
            FinSi
            i <- i + 1
        FinMientras
    FinSi
	
	i<-1
	esnumero = CheckearNumero(arg3)
    Si esnumero = Verdadero Entonces
        arg3S <- ConvertirANumero(arg3)
    SiNo
        encontrado = Falso
        Mientras encontrado = Falso Hacer
            Si pointers[i,1] = arg3 Entonces
                arg3S = ConvertirANumero(pointers[i,2])
                encontrado = Verdadero
            FinSi
            i <- i + 1
        FinMientras
    FinSi
	
	
    Si sysc = "1" Entonces
		palabra = ""
		para i<-0 Hasta arg3S-1 Hacer
			letra = DecodificarAscii(memoria[arg2S+i,1])
			palabra = palabra + letra
		FinPara
		Escribir palabra
    FinSi
FinFuncion

Algoritmo CPU
	
	// REGISTROS:
	// eax = syscall
	// ebx = 1° argumento
	// ecx = 2° argumento
	// edx = 3° argumento
	
	
	// eip = seguimiento de instrucciones
	
	
    MEMORIA_CONST = 1024
    VARIABLES_CONST = 64
    MAXINSTRUCIONES_CONST = 6
	
    Definir rip, registros Como Cadena
    Definir eip Como Entero

    Dimension registros[4]
	
    Definir memoria Como Entero
    Dimension memoria[MEMORIA_CONST,2]
	
    Definir lineas, tokens, instruccion, pointers Como Cadena
    Definir cantidad, i, nlineas, tam Como Entero
	
    nlineas <- 14
    typesection = 0
	locked <- Verdadero
	
    Dimension lineas[nlineas]
    Dimension tokens[MEMORIA_CONST/2]
    Dimension instruccion[MAXINSTRUCIONES_CONST]
    Dimension pointers[VARIABLES_CONST,2]
	
    reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)
	
    lineas[1] <- ";"
	
    lineas[2] <- "section .data;"
    lineas[3] <- "msg db {Hola Mundo}, 0;"
    lineas[4] <- "msg_len equ msg;"
    lineas[5] <- "section .text;"
    lineas[6] <- "global _start;"
    lineas[7] <- "_start:;"
    lineas[8] <- "mov eax, 1;"
    lineas[9] <- "mov ebx, 1;"
    lineas[10] <- "mov ecx, msg;"
    lineas[11] <- "mov edx, msg_len;"
    lineas[12] <- "int 0x80;"
	
    cantidad <- Tokenizar(lineas, tokens, nlineas)
	
    nlineasReal = Numero_Lineas(tokens, cantidad)
	
    ObtenerLabels(tokens, nlineasReal, lineas, pointers)
	
	
    // PRUEBAS
	
    //DebugTokens(tokens, cantidad)
    //DebugPointers(pointers, VARIABLES_CONST)
    //DebugMemoria(memoria, 1, 20)
	
	
    Para eip <- 1 Hasta nlineasReal Hacer
		
        Separar_Instruccion(tokens, instruccion, eip, cantidad)
		
        //DebugInstruccion(instruccion)
		
        Si typesection = 2 Entonces
			
			
			// Instrucciones posibles
			
			// db = Strings
			// dw, dq y dt ints,
			// equ ver el tamaño de una variable
			
			// msg db hola mundo, 0 / significa en msg define hola mundo, acabando con un 0
			// 0 = fin de una string
			// 1 = salto de linea
			
            Segun instruccion[2] Hacer
				
                "db":
                    puntero = asignar_espacio_memoria_car(instruccion[3], Longitud(instruccion[3]), memoria)
                    asignarvariable(instruccion[1], ConvertirATexto(puntero), pointers)
                    //DebugPointers(pointers, VARIABLES_CONST)
                    //DebugMemoria(memoria, 1, 20)
                    //DebugStringMemoria(memoria, puntero)
					
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
					
                    puntero = asignar_espacio_memoria_int(longit, memoria)
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
						indice <- Obtener_Registro(instruccion[2])
						
						si indice <> -1 Entonces
							registros[indice] <- instruccion[3]
						FinSi
						
						
						//DebugRegistros(registros)
					"int":
						
						si instruccion[2] = "0x80" Entonces
							syscall(registros[1], registros[2], registros[3], registros[4], pointers, memoria)
						FinSi
				FinSegun
			FinSi

        FinSi
		
        Si instruccion[1] = "section" Entonces
            Si instruccion[2] = ".data" Entonces
                typesection = 2
            FinSi
			
            Si instruccion[2] = ".text" Entonces
                typesection = 1
            FinSi
        FinSi
		
        Para i <- 1 Hasta 6 Hacer
            instruccion[i] = ""
        FinPara
		
    FinPara
	
FinAlgoritmo