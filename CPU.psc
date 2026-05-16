Funcion cantidad <- Tokenizar(lineas, tokens, nlineas)
	
    Definir i, k, j Como Entero
    Definir buffer, caracter Como Cadena
	
    j <- 1
	
    Para k <- 1 Hasta nlineas
        
        buffer <- ""
		
        Para i <- 1 Hasta Longitud(lineas[k])
            caracter <- Subcadena(lineas[k], i, i)
			
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
			indice <- -1 // error xd
	FinSegun
	
FinFuncion

Funcion Separar_instruccion(tokens, instruccion, index, cantidad)
	
	aux1 <- Verdadero
	
	ahora <- -1 // En donde estamos en una instruccion
	inicio <- 0 // Donde inicia una instruccion
	final <- 0 // Donde se termina la instruccion
	
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


Funcion caracter <- DecodificarAscii(codigo)
	
	Definir letras Como Cadena
	
	letras <- " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	
	Si codigo >= 32 Y codigo <= Longitud(letras)+31 Entonces
		caracter <- Subcadena(letras, codigo-31, codigo-31)
	SiNo
		caracter <- ""
	FinSi
	
FinFuncion

Funcion ptr <- asignar_espacio_memoria(mensaje, longitudmensaje, memoria)
	Definir Carac Como Entero
	
	encontrado = Falso
	ioffset <- 1
	Mientras encontrado = Falso Hacer
		si memoria[ioffset,2] = 0  Entonces
			para l<-1 Hasta longitudmensaje Hacer
				si l = longitudmensaje Entonces
					encontrado = Verdadero
					ptr <- ioffset
					
					para k<-0 Hasta longitudmensaje Hacer
						si k = longitudmensaje Entonces
							memoria[ptr+k, 1] = 0
							memoria[ptr+k, 2] = 1
							wa<-1
						SiNo
							Carac <- CodificarAscii(Subcadena(mensaje, k+1,k+1))
							memoria[ptr+k, 1] = carac
							memoria[ptr+k, 2] = 1
						FinSi
					FinPara
				FinSi
			FinPara
		FinSi
	FinMientras
FinFuncion

Algoritmo CPU
	// REGISTROS:
	// eax = syscall
	// ebx = 1° argumento
	// ecx = 2° argumento
	// edx = 3° argumento
	
	
	// eip = seguimiento de instrucciones
	
    Definir registros, eip Como Entero
	Dimension registros[4]
	
    Definir memoria Como Entero
    Dimension memoria[1024,2]
	
    Definir lineas, tokens, instruccion Como Cadena
    Definir cantidad, i, nlineas, tam Como Entero
	
    nlineas <- 14
	
	// El tipo de seccion que va a establecerse en la recorrida
	
	// 0 = no establecida
	// 1 = .text
	// 2 = .data
	
	typesection = 0
	
    Dimension lineas[nlineas]
    Dimension tokens[300]
    Dimension instruccion[10]
	
	// Asigna el punteor de cada variable
	Dimensionar pointers[64,64]
	
    lineas[1] <- ";" // OBLIGATORIO NO TOCAR
	
	// CODIGO ASSM (linux)
	
    lineas[2] <- ".section .data;"
    lineas[3] <- "msg db HolaMundo, 0;"
    lineas[4] <- "len db 11;"
    lineas[5] <- ".section .text;"
    lineas[6] <- "_start:;"
    lineas[7] <- "mov eax, 4;"
    lineas[8] <- "mov ebx, 1;"
    //lineas[9] <- "mov ecx, msg;"
    //lineas[10] <- "mov edx, len;"
    lineas[11] <- "int 0x80;"
    lineas[12] <- "mov eax, 1;"
    lineas[13] <- "mov ebx, 0;"
    lineas[14] <- "int 0x80;"
	
    cantidad <- Tokenizar(lineas, tokens, nlineas)
	nlineasReal = Numero_Lineas(tokens, cantidad)
	
	
	// PRUEBAS
	
	
	prueba1 = asignar_espacio_memoria("hola", 4, memoria)
	
	para i<-0 Hasta 4 Hacer
		Escribir memoria[prueba1+i,1]
		prueba2 <- DecodificarAscii(memoria[prueba1+i,1])
		Escribir prueba2
	FinPara
	
	
	
	// MAIN
	
	para eip <- 1 Hasta nlineasReal Hacer
		Separar_Instruccion(tokens, instruccion, eip, cantidad)
		Escribir instruccion[1]
		
		si typesection = 2 Entonces
			Segun instruccion[2] Hacer
				"db":
					//puntero = asignar_espacio_memoria()
			FinSegun
		FinSi
		
		si typesection = 1 Entonces
			segun instruccion[1] Hacer
				"mov": 
					indice <- Obtener_Registro(instruccion[2])
					
					Si indice <> -1 Entonces
						registros[indice] <- ConvertirANumero(instruccion[3])
					FinSi
			FinSegun
		FinSi
		
		si instruccion[1] = ".section" Entonces
				si instruccion[2] = ".data" Entonces
					typesection = 2
				FinSi
				si instruccion[2] = ".text"
					typesection = 1
				FinSi
		FinSi
		
		
		para i<-1 Hasta 10 Hacer
			instruccion[i] = ""
		FinPara
	FinPara
	
	
	
	
	
	
	
	// PRUEBAS
	
    // Separar_Instruccion(tokens, instruccion, 1, cantidad)
	
	// Para i <- 1 Hasta 10 Hacer
	// 	Si instruccion[i] <> "" Entonces
	// 		Escribir instruccion[i]
	//	FinSi
	// FinPara
	
	
FinAlgoritmo