#include "config.ch"

FUNCTION initApp()
LOCAL aLOMenubar
aLOMenubar:={;
        {" Users ",	{ || menuUsers()},3},;
        {" Customers ",	{ || menuCustomers()},3},;
		{" Data ",	{ || menuData()},3},;
		{" Reports ",	{ || menuReports()},3},;
        {" Help ",	{ || menuHelp()},3}}

menuTopBar(aLOMenubar,2)
RELEASE cPUmodulo
RETURN .T.


*-------------------
*  MENU: Data *      
*-------------------
FUNCTION menuData()
RETURN {{" @Work Data     ","Work Data.",{||CommingSoon()},	'PA'},;
        {" @Time Data     ","Time Data.",{||CommingSoon()},'  '}}


*-------------------
*  MENU: Reports *      
*-------------------
FUNCTION menuReports()
RETURN {{" @Work Report     ","Work Data.",{||CommingSoon()},	'PA'},;
        {" @Time Report     ","Time Data.",{||CommingSoon()},'  '},;
		{" @System Report   ","System Data.",{||CommingSoon()},'  '}}



*-------------------
*  MENU: Help      *      
*-------------------
FUNCTION menuHelp()
RETURN {{" @About Nia Tracker ","Reports.",{||CommingSoon()},	'PA'},;
        {""},;
        {" @Exit              ","Data.",{||ExitNow()},'  '}}



*-------------------
*  APP: CommingSoon*      
*-------------------
FUNCTION CommingSoon()
RETURN .T.

*-------------------
*  APP: ExitNow   *      
*-------------------
FUNCTION ExitNow()
LOCAL nLOindice, cLOpantalla
//SET COLOR TO "W/N,N/W"
@ 00,00 CLEAR TO MAXROW(),MAXCOL()
//sonidoVenir()
//screenBackExit(1)
CLEAR ALL
@ 00,00 SAY "Thank you!"
CLOSE ALL
RELEASE ALL
SETCURSOR(1)
QUIT
RETURN(.T.)

