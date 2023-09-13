#include "config.ch"

*-------------------------------------------------------------------------
*
* Archivo.....: menu.prg
*
* Autor.......: Ceiboo "Software Development" | José Luis Alfaro
*
* Fecha.......: 2023/09/12  
*
* Version.....: wavbit cms 1.0
*
*-------------------------------------------------------------------------


*-------------------------------------------------------------------------
*
* Funcion.....:	menuInicial
*
*-------------------------------------------------------------------------
FUNCTION menuInicial()
LOCAL aLOopcionesMenuBarra
aLOopcionesMenuBarra:={;
            {" Archivo ",	{ || menuArchivos()},	3},;
            {" Ayuda ",		{ || menuAyuda()},		3}}

menuBarraPrincipal(aLOopcionesMenuBarra,5,"Estadisticas")
RELEASE cPUmodulo
RETURN .T.


*-------------------
*  MENU: Archivos  *      
*-------------------
FUNCTION menuArchivos()
RETURN {{" @Users                       ","Add, Edit and Delete Users.",{||padrones("Users")},	'PA'},;
        {""},;
        {" sobre el @Autor...           ","Datos sobre el autor del producto de software.",{||sobreElAutor()},'  '},;
        {" @Salir de Wavbit cms 1.0     ","Se utiliza para volver al sistema operativo.",{||salirYa()},'  '}}


*-------------------
*  MENU: Ayudas    *      
*-------------------
FUNCTION menuAyuda()
RETURN {{" @Manual     ","Manual del usuario.",	{||ayuManual()},	'  '},;
        {" @Novedad    ","Novedades del sistema.",	{||ayuNovedad()},	'  '}}


FUNCTION ayuManual()
RETURN .T.

FUNCTION ayuNovedad()
RETURN .T.


FUNCTION padrones(x)
RETURN .T.
