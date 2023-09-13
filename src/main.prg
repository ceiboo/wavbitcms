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
* Archivo.....: main.prg
*
* Autor.......: Ceiboo "Software Development" | José Luis Alfaro
*
* Fecha.......: 2023/09/12  
*
* Version.....: wavbit cms 1.0
*
*-------------------------------------------------------------------------

PROCEDURE MAIN()
*
* Busca el fichero INI y los datos de la empresa y la inicializa.
PUBLIC MI_FICHEROEMPRESA:="cms.ini" //variable que contiene el nombre del fichero INI.
PUBLIC aPUempresa:=ARRAY(longAPUEMPRESA)	//registro que contiene los datos de la empresa.
PUBLIC aPUconfig:=ARRAY(longAPUCONFIG)		//registro de la configuracion gral.


iniCfgGeneral()	//Inicializa la configuracion gral. con los valores por defecto.

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
IF (cLOentorno:=GETENV("cms"))==""
	MI_FICHEROEMPRESA:="cms.ini"
	aPUconfig[MI_PUESTO]:=1
	*aviso("NO SE HA DECLARADO LA VARIABLE DE ENTORNO SET FACTORY=",;"POR DEFECTO SET FACTORY=/F:CMS.INI /P:1")
ELSE
	nLOatf:=AT("/F:",cLOentorno)
	nLOatp:=AT("/P:",cLOentorno)
	nLOratf:=IIF(nLOatp==0,LEN(cLOentorno)-1,nLOatp-4)
	MI_FICHEROEMPRESA:=SUBSTR(cLOentorno,nLOatf+3,nLOratf)
	aPUconfig[MI_PUESTO]:=IIF(nLOatp==0,1,VAL(SUBSTR(cLOentorno,nLOatp+3,1)))
ENDIF	

IF !FILE(MI_FICHEROEMPRESA)	
	* si no encuentra el archivo INI lo crea y edita los datos de la empresa.
	creaFicheroIni(MI_FICHEROEMPRESA)
	enCeroEmpresa()
	editaDatosEmpresa()
ELSE
	* si el archivo existe entonces lee los datos de la empresa y 
	* la configuracion general del sisema.
	enCeroEmpresa()
	leeDatosEmpresa()
	leeCfgGeneral()
ENDIF

menuInicial()

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
