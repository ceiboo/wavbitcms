#include "config.ch"

*-------------------------------------------------------------------------
*
* Funcion.....: iniCfgGeneral()
*
* Resumen.....:	Les da un valor inicial a las variables de Configuracion
*
* Autor.......: JOSE LUIS ALFARO
*
* Ultima Rev..:	26-06-2006
*
*-------------------------------------------------------------------------
FUNCTION iniCfgGeneral()
aPUconfig[MI_RETARDO]:=120
aPUconfig[MI_SONIDO]:="S"
*aPUconfig[MI_TONO]:="W+/N, BG+/B,,,W/N"
aPUconfig[MI_TONO]:="{'W+/B, BG+/N','N/W','W+/BG+','N+/W'}"
aPUconfig[MI_ARRAYTONO]:=&(aPUconfig[MI_TONO])
aPUconfig[MI_PUESTO]:=1
RETURN .T.


FUNCTION leeCfgGeneral()
LOCAL cLOarchivo	:=""
cLOarchivo:="PUESTO"+STR(aPUconfig[MI_PUESTO],1)
aPUconfig[MI_RETARDO] :=PROFILENUM         (MI_FICHEROEMPRESA,   cLOarchivo,"RETARDO",aPUconfig[MI_RETARDO])
aPUconfig[MI_SONIDO]  :=UPPER(PROFILESTRING(MI_FICHEROEMPRESA,cLOarchivo,"SONIDO", aPUconfig[MI_SONIDO]))
aPUconfig[MI_TONO]	  :=UPPER(PROFILESTRING(MI_FICHEROEMPRESA,cLOarchivo,"TONOS",  aPUconfig[MI_TONO]))

** Provisorio hasta actualizar los .INI y CONTROL.EXE:
** Si el PLEX.INI no tiene los colores con el nuevo formato se le aplican
** los colores por defecto:
IF AT("{",aPUconfig[MI_TONO])=0 .OR. AT("}",aPUconfig[MI_TONO])=0
	aPUconfig[MI_TONO]:="{'W+/W,BG+/N','N/W','W+/BG+','N+/W'}"
ENDIF
** Como la expresi�n de aPUconfig[MI_TONO] se eval�a como macroexpresi�n
** para obtener un arreglo, hay que sacarle cualquier error de lectura de
** PROFILESTRING():
DO WHILE !(LEFT(aPUconfig[MI_TONO],1)=="{")
	aPUconfig[MI_TONO]:=SUBSTR(aPUconfig[MI_TONO],2)
ENDDO
aPUconfig[MI_ARRAYTONO]:=&(aPUconfig[MI_TONO])
RETURN .T.