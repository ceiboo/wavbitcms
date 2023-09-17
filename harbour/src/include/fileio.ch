***
*
*  Fileio.ch
*
*  Definiciones est ndar para funciones de ficheros de bajo nivel de Clipper
*
*  Copyright (c) 1990-1993, Computer Associates International, Inc.
*  Todos los derechos reservados.
*
*


// Valor Error (todas las funciones)

#define F_ERROR      (-1)


// Modos para FSEEK()

#define FS_SET       0     // Situarse a partir del principio del fichero
#define FS_RELATIVE  1     // Situarse a partir de la posici¢n actual
#define FS_END       2     // Situarse a partir del final del fichero


// Modos de acceso para FOPEN()

#define FO_READ      0     // Abrir para lectura (valor por defecto)
#define FO_WRITE     1     // Abrir para escritura
#define FO_READWRITE 2     // Abrir para lectura/escritura


// Modos compartidos para FOPEN() (combinar con modo de apertura usando +)

#define FO_COMPAT    0     // Modo de compatibilidad (valor por defecto)
#define FO_EXCLUSIVE 16    // Modo exclusivo (los dem s procesos no pueden
                           // acceder)
#define FO_DENYWRITE 32    // Evitar que escriban otros procesos
#define FO_DENYREAD  48    // Evitar que lean otros procesos
#define FO_DENYNONE  64    // Permitir leer o escribir a otros procesos
#define FO_SHARED    64    // Igual que FO_DENYNONE


// Atributos de fichero para FCREATE()
// NOTA:  FCREATE() siempre abre ficheros con (FO_READWRITE + FO_COMPAT)

#define FC_NORMAL    0     // Crear fichero normal lectura/escritura
                           // (valor por defecto)
#define FC_READONLY  1     // Crear fichero de s¢lo lectura
#define FC_HIDDEN    2     // Crear fichero oculto
#define FC_SYSTEM    4     // Crear fichero de sistema


// Tipos de fichero para FSETDEVMODE()

#define FD_RAW       1
#define FD_BINARY    1
#define FD_COOKED    2
#define FD_TEXT      2
#define FD_ASCII     2

#define _FILEIO_CH
