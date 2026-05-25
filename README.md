# CPU en PSeInt

Este proyecto es un mini interprete tipo ASM dentro de PSeInt. Para programar, editas el arreglo `lineas[]` en [CPU.psc](CPU.psc) y luego ejecutas el algoritmo.

## Requisitos

- PSeInt (cualquier version que soporte arreglos y funciones).

## Como ejecutar

1. Abre [CPU.psc](CPU.psc) en PSeInt.
2. Busca el bloque `Algoritmo CPU`.
3. Edita las asignaciones de `lineas[]` con tu programa.
4. Ejecuta el algoritmo.

> Importante: cada linea debe terminar con `;` dentro del texto, porque el parser lo usa para separar instrucciones.

## Como escribir programas

El codigo usa tres secciones:

- `.data`: define datos (strings o numeros).
- `.text`: instrucciones.
- `.bss`: reserva memoria.

### Reglas de sintaxis

- Las cadenas y caracteres se escriben entre `{}` para poder incluir espacios.
- Las etiquetas llevan `:` al final (ej: `_start:`).
- Se recomienda declarar `global _start` y luego la etiqueta `_start:`.

### Instrucciones soportadas

- `db`: string en memoria.
- `dw`, `dd`, `dq`, `dt`: enteros de decoracion si te soy sincero.
- `equ`: calcula largo de un string (hasta encontrar 0 o 1).
- `resb`: reserva N bytes en `.bss`.
- `mov`: asignacion a registros o memoria.
- `mov byte [var], {A}`: escribe un caracter en memoria.
- `int 0x80`: syscall.

### Registros

- `eax`: numero de syscall.
- `ebx`: arg1.
- `ecx`: arg2.
- `edx`: arg3.

### Syscall actual

- `eax = 3`: lee texto desde consola y lo guarda en memoria.
  - `ebx = 0` para leer input de teclado.
  - `ecx` apunta al buffer donde se escriben los caracteres.
  - `edx` se usa como longitud maxima del buffer.
- `eax = 4`: imprime `edx` bytes desde la direccion `ecx`.
  - `ebx = 1` para stdout.

### Ejemplo 3: Leer input en un buffer

```text
lineas[2] <- "section .bss;"
lineas[3] <- "buffer resb 20;"

lineas[4] <- "section .text;"
lineas[5] <- "global _start;"
lineas[6] <- "_start:;"

lineas[7] <- "mov eax, 3;"
lineas[8] <- "mov ebx, 0;"
lineas[9] <- "mov ecx, buffer;"
lineas[10] <- "mov edx, 20;"
lineas[11] <- "int 0x80;"
```

> Nota: esta entrada copia los caracteres tal cual en memoria; si luego quieres imprimirlos, usa `eax = 4` con el mismo `buffer`.

## Ejemplo 1: Hola Mundo

```text
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
```

## Ejemplo 2: Cambiar el string y volver a imprimir

```text
lineas[13] <- "mov byte [msg], {A};"
lineas[14] <- "mov byte [msg+1], {d};"
lineas[15] <- "mov byte [msg+2], {i};"
lineas[16] <- "mov byte [msg+3], {o};"
lineas[17] <- "mov byte [msg+4], {s};"

lineas[18] <- "mov eax, 4;"
lineas[19] <- "mov ebx, 1;"
lineas[20] <- "mov ecx, msg;"
lineas[21] <- "mov edx, msg_len;"
lineas[22] <- "int 0x80;"
```

## Tips

- Si agregas mas lineas, ajusta `nlineas` y el tamaño de `lineas[]` si hace falta.
- Evita instrucciones con mas de 6 tokens, porque `instruccion[]` tiene tamaño 6.
