// To print text without formatting chars.
#ifdef DEBUG
   #stdout Compiling debugging version...
#endif

#ifndef __HARBOUR__
#include "clipper.ch"
#endif

#include "inkey.ch"
#include "config.ch"

*-------------------------------------------------------------------------
*
* File:		main.prg
*
* Author:	Ceiboo "Software Development" | José Luis Alfaro
*
* Date:		2023/09/12  
*
* Version:	1.0
*
*-------------------------------------------------------------------------

PROCEDURE MAIN()

*
* Seteo de configuracion inicial
SETBLINK(.F.)
SET DELIMITER TO ""
SET MESSAGE TO 23
SET WRAP ON
SET DELETE ON
SET CURSOR OFF
SET SCOREBOARD OFF
SET DATE FORMAT TO "dd/mm/yy"
SET EPOCH TO 1980
SET CENTURY ON
SET DECIMALS TO 2
SETCURSOR(3)
CLEAR SCREEN


initConfig()

initApp()

RETURN


*-------------------------------------------------------------------------
*
* Funcion.....: creaArchivoIni
*
* Parametros..:	MI_FICHEROEMPRESA
*
* Resumen.....: crea el archivo de inicializacion si no existe.
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
STATIC PROCEDURE creaFicheroIni(MI_FICHEROEMPRESA)
LOPmanejador:=FCREATE(MI_FICHEROEMPRESA,0)
FCLOSE(LOPmanejador)
RETURN

