#include "config.ch"

*-------------------------------------------------------------------------
*
* Archivo.....: company.prg
*
* Autor.......: JOSE LUIS ALFARO
*
* Fecha.......: 2023/09/12
*
* Version.....: wavbit cms 1.0
*
*-------------------------------------------------------------------------


*-------------------------------------------------------------------------
*
* Funcion.....: enCeroEmpresa()
*
* Resumen.....: inicializa los datos de la empresa en la vble aPUempresa
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
PROCEDURE enCeroEmpresa()
aPUempresa[MI_NUMERO       ]:=1
aPUempresa[MI_EMPRESA      ]:=SPACE(35)
aPUempresa[MI_DIRECCION    ]:=SPACE(30)
aPUempresa[MI_TELEFONO     ]:=SPACE(12)
aPUempresa[MI_EMAIL        ]:=SPACE(35)
RETURN


*-------------------------------------------------------------------------
*
* Funcion.....: leeDatosEmpresa()
*
* Resumen.....: lee del archivo .ini los valores de los datos
*				del registro de empresa.
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
PROCEDURE leeDatosEmpresa()
LOCAL cLOseccion:="EMPRESA"
aPUempresa[MI_NUMERO       ]:=   profileNum(MI_FICHEROEMPRESA,cLOseccion,"NUMERO",         aPUempresa[MI_NUMERO])
aPUempresa[MI_EMPRESA      ]:=profileString(MI_FICHEROEMPRESA,cLOseccion,"EMPRESA",        aPUempresa[MI_EMPRESA])
aPUempresa[MI_DIRECCION    ]:=profileString(MI_FICHEROEMPRESA,cLOseccion,"DIRECCION",      aPUempresa[MI_DIRECCION])
aPUempresa[MI_TELEFONO     ]:=profileString(MI_FICHEROEMPRESA,cLOseccion,"TELEFONO",       aPUempresa[MI_TELEFONO])
aPUempresa[MI_EMAIL        ]:=profileString(MI_FICHEROEMPRESA,cLOseccion,"EMAIL",          aPUempresa[MI_EMAIL])

aPUempresa[MI_EMPRESA      ]:=IIF(ALLTRIM(aPUempresa[MI_EMPRESA      ])=="",SPACE(35),aPUempresa[MI_EMPRESA      ])
aPUempresa[MI_DIRECCION    ]:=IIF(ALLTRIM(aPUempresa[MI_DIRECCION    ])=="",SPACE(30),aPUempresa[MI_DIRECCION    ])
aPUempresa[MI_TELEFONO     ]:=IIF(ALLTRIM(aPUempresa[MI_TELEFONO     ])=="",SPACE(12),aPUempresa[MI_TELEFONO     ])
aPUempresa[MI_EMAIL        ]:=IIF(ALLTRIM(aPUempresa[MI_EMAIL        ])=="",SPACE(35),aPUempresa[MI_EMAIL        ])
RETURN


*-------------------------------------------------------------------------
*
* Funcion.....: grabaDatosEmpresa()
*
* Resumen.....: graba en el archivo .ini los valores de los datos
*				del registro de empresa.
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
PROCEDURE grabaDatosEmpresa()
LOCAL cLOseccion:="EMPRESA"
SetProfile(MI_FICHEROEMPRESA,cLOseccion,"NUMERO",         aPUempresa[MI_NUMERO])
SetProfile(MI_FICHEROEMPRESA,cLOseccion,"EMPRESA",        aPUempresa[MI_EMPRESA])
SetProfile(MI_FICHEROEMPRESA,cLOseccion,"DIRECCION",      aPUempresa[MI_DIRECCION])
SetProfile(MI_FICHEROEMPRESA,cLOseccion,"TELEFONO",       aPUempresa[MI_TELEFONO])
SetProfile(MI_FICHEROEMPRESA,cLOseccion,"EMAIL",          aPUempresa[MI_EMAIL])
RETURN


*-------------------------------------------------------------------------
*
* Funcion.....: editaDatosEmpresa
*
* Resumen.....: permite editar los datos de la empresa.
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
PROCEDURE editaDatosEmpresa()
LOCAL cLOpantalla
cLOpantalla:=SAVESCREEN(01,05,MAXROW()-1,MAXCOL()-7)
window(01,06,MAXROW()-1,MAXCOL()-9,.T.)
SET CURSOR ON
abmEmpresa()
READ
SET CURSOR OFF
grabaDatosEmpresa()
RESTSCREEN(01,05,MAXROW()-7,MAXCOL(),cLOpantalla)
RETURN


*-------------------------------------------------------------------------
*
* Funcion.....: abmEmpresa
*
* Resumen.....: muestra en pantalla los datos de la empresa para editarlos
*
* Autor.......: Alfaro Jose Luis
*
*-------------------------------------------------------------------------
PROCEDURE abmEmpresa()
CLEAR GETS
@ 02,08 SAY 'Company....:'	GET aPUempresa[MI_EMPRESA];
	PICTURE 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
	WHEN centrar("Company Name.",24)
@ 03,08 SAY 'Company Number............:'	GET aPUempresa[MI_NUMERO];
	PICTURE '####';
	WHEN centrar("Company Number.",24)

@ 04,08 SAY 'Address..........:'	GET aPUempresa[MI_DIRECCION];
	PICTURE '@!kS30';
	WHEN centrar("Address.",24)
@ 05,08 SAY 'Phone...........:'	GET aPUempresa[MI_TELEFONO];
	PICTURE '@!kS12';
	WHEN centrar("Company Phone.",24)
@ 06,08 SAY 'Email..............:'	GET aPUempresa[MI_EMAIL];
	PICTURE 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
	WHEN centrar("Company Email.",24)
RETURN
