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
        Escribir "eax = " + ConvertirATexto(registros[1])
        Escribir "ebx = " + ConvertirATexto(registros[2])
        Escribir "ecx = " + ConvertirATexto(registros[3])
        Escribir "edx = " + ConvertirATexto(registros[4])
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
    Definir i,k,j Como Entero
    Definir buffer,caracter Como Cadena
    Definir enBloque Como Logico
    j <- 1
    enBloque <- Falso

    Para k <- 1 Hasta nlineas
        buffer <- ""

        Para i <- 1 Hasta Longitud(lineas[k])
            caracter <- Subcadena(lineas[k],i,i)

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

                si memoria[ioffset,2] = 0 Entonces

                        para l<-1 Hasta longitudmensaje Hacer

                                si l = longitudmensaje y valido = longitudmensaje - 1 Entonces

                                        encontrado = Verdadero
                                        ptr <- ioffset

                                        para k<-0 Hasta longitudmensaje Hacer

                                                si k = longitudmensaje Entonces
                                                        memoria[ptr+k,1] = 0
                                                        memoria[ptr+k,2] = 1
                                                SiNo
                                                        Carac <- CodificarAscii(Subcadena(mensaje,k+1,k+1))
                                                        memoria[ptr+k,1] = carac
                                                        memoria[ptr+k,2] = 1
                                                FinSi

                                        FinPara

                                FinSi

                                si memoria[ioffset+l,2] = 0 y valido <> -1 Entonces
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

                si memoria[ioffset,2] = 0 Entonces

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

                si Subcadena(tokentrabajando,Longitud(tokentrabajando),Longitud(tokentrabajando)) = ":" Entonces

                        contador <- 0

                        Para j <- 1 Hasta nlineas Hacer

                                si lineas[j] <> "" Entonces
                                        contador <- contador + 1
                                FinSi

                                Si tokentrabajando = Subcadena(lineas[j],1,Longitud(lineas[j])-1) Entonces
                                        ptr <- contador
                                FinSi

                        FinPara

                        asignarvariable(Subcadena(tokentrabajando,1,Longitud(tokentrabajando)-1),ConvertirATexto(ptr),pointers)

                FinSi

                si tokentrabajando = "" Entonces
                        termino = Verdadero
                FinSi

                i <- i + 1

        FinMientras

FinFuncion

Funcion reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)

        para i<-1 Hasta VARIABLES_CONST Hacer
                pointers[i,1] = "0"
                pointers[i,2] = "0"
        FinPara

        para i<-1 Hasta MAXINSTRUCIONES_CONST Hacer
                instruccion[i] = "0"
        FinPara

FinFuncion

Funcion asignarvariable(variable, puntero, pointers)

        encontrado = Falso
        i <- 1

        Mientras encontrado = Falso Hacer

                si pointers[i,2] = "0" Entonces

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

                si pointers[ioffset,1] = variable Entonces

                        ptr <- ConvertirANumero(pointers[ioffset,2])
                        encontrado = Verdadero

                FinSi

                ioffset <- ioffset + 1

        FinMientras

FinFuncion

Algoritmo CPU

        MEMORIA_CONST = 1024
        VARIABLES_CONST = 64
        MAXINSTRUCIONES_CONST = 6

        Definir rip Como Cadena
        Definir registros, eip Como Entero

        Dimension registros[4]

        Definir memoria Como Entero
        Dimension memoria[MEMORIA_CONST,2]

        Definir lineas, tokens, instruccion, pointers Como Cadena
        Definir cantidad, i, nlineas, tam Como Entero

        nlineas <- 14

        typesection = 0

        Dimension lineas[nlineas]
        Dimension tokens[MEMORIA_CONST/2]
        Dimension instruccion[MAXINSTRUCIONES_CONST]
        Dimension pointers[VARIABLES_CONST,2]

        reiniciomemoria(MEMORIA_CONST, VARIABLES_CONST, MAXINSTRUCIONES_CONST, memoria, pointers, instruccion)

        lineas[1] <- ";"

        lineas[2] <- "section .data;"
        //lineas[3] <- "msg db {Hola Mundo}, 0;"
        //lineas[4] <- "msg_len equ msg;"
        lineas[5] <- "section .text;"
        lineas[6] <- "global _start;"
        lineas[7] <- "_start:;"
        lineas[8] <- "mov eax, 4;"
        lineas[9] <- "mov ebx, 1;"
        lineas[11] <- "int 0x80;"
        lineas[12] <- "mov eax, 1;"
        lineas[13] <- "mov ebx, 0;"
        lineas[14] <- "int 0x80;"

        cantidad <- Tokenizar(lineas, tokens, nlineas)

        nlineasReal = Numero_Lineas(tokens, cantidad)

        ObtenerLabels(tokens, nlineasReal, lineas, pointers)





        // PRUEBAS

        DebugTokens(tokens, cantidad)

        DebugPointers(pointers, VARIABLES_CONST)

        DebugMemoria(memoria, 1, 20)





        para eip <- 1 Hasta nlineasReal Hacer

                Separar_Instruccion(tokens, instruccion, eip, cantidad)

                DebugInstruccion(instruccion)

                si typesection = 2 Entonces

                        Segun instruccion[2] Hacer

                                "db":

                                        puntero = asignar_espacio_memoria_car(instruccion[3], Longitud(instruccion[3]), memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                                        DebugPointers(pointers, VARIABLES_CONST)
                                        DebugMemoria(memoria, 1, 20)
                                        DebugStringMemoria(memoria, puntero)

                                "dw":

                                        puntero = asignar_espacio_memoria_int(instruccion[3], memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                                "dd":

                                        puntero = asignar_espacio_memoria_int(instruccion[3], memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                                "dq":

                                        puntero = asignar_espacio_memoria_int(instruccion[3], memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                                "dt":

                                        puntero = asignar_espacio_memoria_car(instruccion[3], Longitud(instruccion[3]), memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                                "equ":

                                        puntero_variable = BuscarPunteroVariable(instruccion[3], pointers)

                                        final = Falso
                                        auxiliar1 = 0

                                        Mientras final = Falso Hacer

                                                si memoria[puntero_variable+auxiliar1,1] = 0 o memoria[puntero_variable+auxiliar1,1] = 1 Entonces
                                                        final = Verdadero
                                                FinSi

                                                auxiliar1 <- auxiliar1 + 1

                                        FinMientras

                                        longit = auxiliar1 - 1

                                        puntero = asignar_espacio_memoria_int(longit, memoria)

                                        asignarvariable(instruccion[1],ConvertirATexto(puntero),pointers)

                        FinSegun

                FinSi

                si typesection = 1 Entonces

                        segun instruccion[1] Hacer

                                "global":

                                        rip = "1"

                                "mov":

                                        indice <- Obtener_Registro(instruccion[2])

                                        Si indice <> -1 Entonces
                                                registros[indice] <- ConvertirANumero(instruccion[3])
                                        FinSi

                                        DebugRegistros(registros)

                        FinSegun

                FinSi

                si instruccion[1] = "section" Entonces

                        si instruccion[2] = ".data" Entonces
                                typesection = 2
                        FinSi

                        si instruccion[2] = ".text" Entonces
                                typesection = 1
                        FinSi

                FinSi

                para i <- 1 Hasta 6 Hacer
                        instruccion[i] = ""
                FinPara

        FinPara

FinAlgoritmo