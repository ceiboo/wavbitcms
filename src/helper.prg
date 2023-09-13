#include "inkey.ch"
#include "config.ch"

*-------------------------------------------------------------------------
*
* Archivo.....: helper.prg
*
* Autor.......: Ceiboo "Software Development" | José Luis Alfaro
*
* Fecha.......: 2023/09/12  
*
* Version.....: wavbit cms 1.0
*
* Funciones:   sonidoIr()
*			   sonidoVenir()
*			   centrar()
*			   window()
*			     sombra()
*			   seguro()
*			   aviso()
*			   esquina()
*			   longDate()
*			   eleccion()
*			   dispositivo()
*			     controlTeclas()
*			     editarParDisp()
*			     mostrarParametros()
*			   cargarDispos()
*			   pUpper()
*			   exacto()
*			   elapTime()
*			   valTime()
*			   salirYa()
*			   calculaCoordenadas()
*			   plexFondo()
*			   sobreElAutor()
*			   santaFe()
*			   calculadora()
*			   salvaPantalla()
*			   xBuscar()
*			   nuevaColumna()
*			   borrarColumnas()
*			   closeTabla()
*			   openTabla()
*			   mostrarReporte()
*			       fcMostrarReporte()
*			   hexaToInt()
*			   prCommit()
*			   leeAlicuota()
*			   keyBoard()
*			   valTipoComprobante()
*			   estaEntre()
*			   leerGuiaOri()
*			   procesando()
*			   verParcial()
*			   verFinal()
*			   stLlave()
*			   nombreTamano()
*			   verDatosMedicamento()
*			   verMedicaSemejantes()
*			   estaEnValores()
*			   rubroNomb()
*			   mensaje()
*			   estadoModem()
*			   rpEnReceta()
*			   grabarMensaje()
*			   leerMensaje()
*			   armaPaqueteModem()
*			   datosRetira()
*			   leePaqueteModem()
*			   leerPresentacion()
*			   MemLibre()
*			   Bisiesto()
*			   mensaDebito()
*			   pideAnulCredito()
*			   grabarAutorizacion()
*			   pideAutorizacion()
*			   ArrayRespuesta()
*			   leeRespuesta()
*			   esNumero()
*			   GraSaveScreen
*			   GraRestScreen
*
*-------------------------------------------------------------------------

*-------------------------------------------------------------------------
*
* Funcion.....: sonidoIr
*
* Resumen.....:	Genera un sonido de Ida
*
*-------------------------------------------------------------------------
FUNCTION  sonidoIr()
LOCAL nLOtiempo
IF aPUconfig[MI_SONIDO]=="S"
	nLOtiempo:=VAL(SUBSTR(TIME(),7,2))*50
	TONE(nLOtiempo*1)
	TONE(nLOtiempo*4)
	TONE(nLOtiempo*7)
ENDIF
RETURN( .T. )


*-------------------------------------------------------------------------
*
* Funcion.....: sonidoVenir
*
* Resumen.....:	Genera un sonido de Vuelta
*
*-------------------------------------------------------------------------
FUNCTION sonidoVenir()
LOCAL nLOtiempo
IF aPUconfig[MI_SONIDO]=="S"
	nLOtiempo:=VAL(SUBSTR(TIME(),7,2))*50
	TONE(nLOtiempo*7)
	TONE(nLOtiempo*4)
	TONE(nLOtiempo*1)
ENDIF
RETURN( .T. )


*-------------------------------------------------------------------------
*
* Funcion.....: centrar
*
* Parametros..:	cPAtexto	//texto que voy a centrar
*				nPAlineaIni	//linea donde se escribe el texto
*				nPAcolIni	//columna inicial donde
*				nPAcolFin	//columna final
*				cPAcolor	//cadena de color
*
* Resumen.....:	Centra Textos en Pantalla
*
*-------------------------------------------------------------------------
FUNCTION centrar(cPAtexto, nPAlineaIni, nPAcolIni, nPAcolFin, cPAcolor)
LOCAL nLOx, nLOy, nLOz
cPAcolor:=IIF(cPAcolor==NIL,colorNormal(),cPAcolor)
DO CASE
	CASE nPAlineaIni==NIL
		nLOx:=MAXROW()-1
		nLOy:=00
		nLOz:=MAXCOL()+1
	CASE nPAcolIni==NIL
		nLOx:=nPAlineaIni
		nLOy:=00
		nLOz:=MAXCOL()+1
	CASE nPAcolFin==NIL
		nLOx:=nPAlineaIni
		nLOy:=nPAcolIni
		nLOz:=MAXCOL()+1
	CASE nPAcolFin != NIL
		nLOx:=nPAlineaIni
		nLOy:=nPAcolIni
		nLOz:=nPAcolFin
ENDCASE
@ nLOx,nLOy SAY PADC(cPAtexto,nLOz-nLOy) COLOR cPAcolor
RETURN(.T.)


*-------------------------------------------------------------------------
*
* Funcion.....: window
*
* Parametros..: nPAfilaInicial	//fila inicial de la ventana
* 				nPAcolInicial	//columna inicial de la ventana
*				nPAfilaFinal	//fila donde finaliza la ventana
*				nPAcolFinal		//columna donde finaliza la ventana
*				lPAsombra		//ventana con sombra
*				cPAmenSuperior	//mensaje superior de la ventana
*
* Resumen.....: Genera una ventana de texto
*
*-------------------------------------------------------------------------
FUNCTION window(nPAfilaInicial, nPAcolInicial, nPAfilaFinal, nPAcolFinal, lPAsombra, cPAmenSuperior)
LOCAL cLObox:=chr(201)+chr(205)+chr(187)+chr(186)+chr(188)+chr(205)+chr(200)+chr(186)

lPAsombra:=IF(lPAsombra == NIL,.F.,lPAsombra)
IF lPAsombra
	sombra(nPAfilaInicial+01, nPAcolInicial+01, nPAfilaFinal+01, nPAcolFinal+02 )
	*cLObox:=''
ENDIF
SETCOLOR( colorNormal() )
@ nPAfilaInicial, nPAcolInicial-01, nPAfilaFinal, nPAcolFinal+01 BOX '         '
@ nPAfilaInicial, nPAcolInicial, nPAfilaFinal, nPAcolFinal BOX cLObox
IF cPAmenSuperior != NIL
	@ nPAfilaInicial,INT(nPAcolInicial+((nPAcolFinal-nPAcolInicial)/2)-((LEN(cPAmenSuperior)+2)/2)) SAY IIF(lPAsombra," "," ")+IIF(LEN(cPAmenSuperior)<(nPAcolFinal-nPAcolInicial-2),cPAmenSuperior,LEFT(cPAmenSuperior,(nPAcolFinal-nPAcolInicial)-1))+IIF(lPAsombra," "," ")
ENDIF
RETURN(.T.)


*-------------------------------------------------------------------------
*
* Funcion.....: Sombra
*
* Parametros..:	nPAfilaInicial	 //	 N� de fila inicial
*				nPAcolInicial	 //	 N� de columna inicial
*				nPAfilaFinal	 //	 N� de fila final
*				nPAcolFinal		 //	 N� de columna final
*				cPAmenSuperior	 //
*   			nPAsombra		 //
*
* Resumen.....:	Dibuja la sombra de las ventanas
*
*-------------------------------------------------------------------------
FUNCTION sombra(nPAfilaInicial, nPAcolInicial, nPAfilaFinal, nPAcolFinal, cPAmenSuperior, nPAsombra)
@ nPAfilaInicial, nPAcolInicial, nPAfilaFinal, nPAcolFinal BOX '        ' COLOR colorInverso()
RETURN .T.


*-------------------------------------------------------------------------
*
* Funcion.....: seguro
*
* Parametros..: cPAmensa1  // Texto del mensaje en pantalla.
*				cPAmensa2  // Texto para la segunda linea.
*				aPAarray   // Arreglo con las opciones de menu para el
*							  mensaje. Si no se pasan se muestra Si y No.
*
* Retorna.....:	En caso de que no se pase aPAarray, la funcion retorna .T. o .F.,
*				en caso contrario, retorna nLOmenu
*
* Resumen.....:	Funcion que genera una ventana de texto
*
*-------------------------------------------------------------------------
FUNCTION seguro(cPAmensa1, cPAmensa2, aPAarray)
LOCAL nLOmenu:=1, nLOcursorActual, nLOvalor, nLOindice, cLOpantalla,;
	  nLOcantLineas:=0
nLOcursorActual:=SETCURSOR()
nLOlineas:=MLCOUNT(cPAmensa1,60)-1
IF nLOlineas==0
	cPAmensa1:=PADC(cPAmensa1,60," ")
ENDIF
sonidoIr()
cLOpantalla:=SAVESCREEN(08-nLOlineas,08,17,75)
window(09-nLOlineas,09,15,72,.t.)
cPAmensa2:=IIF(PCOUNT()==1,"",cPAmensa2)
KEYBOARD CHR(K_ESC)
MEMOEDIT(cPAmensa1,11-nLOlineas,10,11,71,.F.,,60)
centrar(cPAmensa2,12,10,71)
IF aPAarray==NIL
	@ 13,29 PROMPT  "   Si   "
	@ 13,44 PROMPT  "   No   "
ELSE
	DO CASE
		CASE LEN(aPAarray)==1
			nLOvalor:=41-(INT(LEN(aPAarray[1]))/2)
		CASE LEN(aPAarray)==2
			nLOvalor:=39-(INT(LEN(aPAarray[1])+LEN(aPAarray[2])+2)/2)
		CASE LEN(aPAarray)==3
			nLOvalor:=38-(INT(LEN(aPAarray[1])+LEN(aPAarray[2])+LEN(aPAarray[3])-4)/2)
		CASE LEN(aPAarray)==4
			nLOvalor:=42-(INT(LEN(aPAarray[1])+LEN(aPAarray[2])+LEN(aPAarray[3])+LEN(aPAarray[4])+6)/2)
	ENDCASE
	FOR nLOindice:=1 TO LEN(aPAarray)
		@ 13, nLOvalor PROMPT aPAarray[nLOindice]
		nLOvalor:=nLOvalor+LEN(aPAarray[nLOindice])+2
	ENDFOR
ENDIF
MENU TO nLOmenu
RESTSCREEN(08-nLOlineas,08,17,75,cLOpantalla)
sonidoVenir()
SETCURSOR(nLOcursorActual)
RETURN IIF(PCOUNT()<=2,IIF(nLOmenu=1,.T.,.F.),nLOmenu)


*-------------------------------------------------------------------------
*
* Funcion.....: aviso
*
* Parametros..:	cPAmensa1 	//Mensaje de la primera linea.
*				cPAmensa2 	//Mensaje para la segunda linea.
*
* Resumen.....:	Esta funcion genera una ventana de texto
*
*-------------------------------------------------------------------------
FUNCTION aviso( cPAmensa1,cPAmensa2 )
RETURN(seguro(cPAmensa1,cPAmensa2,{" Continuar "}))


*-------------------------------------------------------------------------
*
* Funcion.....: esquina
*
* Parametros..:	cPAmensaje	 //Texto a mostrar por pantalla
*				nPAsegundos  //Segundos que se ha de mostrar el mensaje
*				lPArestaurar //Si se restaura la pantalla despues de mostrar
*							   el mensaje.
*
* Retorna.....: Verdadero
*
* Resumen.....:	La funcion muestra en pantalla un el texto contenido en
*				cPAmensaje, opcionalmente durante los segundos especificados
*				en nPAsegundos. Luego si lPArestaurar es Verdadero se
*				restaura la pantalla.
*
*-------------------------------------------------------------------------
FUNCTION esquina(cPAmensaje, nPAsegundos, lPArestaurar)
LOCAL nLOmitad, nLOcursorActual, cLOpantalla
lPArestaurar:=IIF(lPArestaurar=NIL, .T., lPArestaurar)
nLOcursorActual:=SETCURSOR()
nLOmitad:=LEN(cPAmensaje)+2
nLOx:=77-nLOmitad
SETCURSOR(0)
cLOpantalla:=SAVESCREEN(00,73-nLOmitad,06,79)
window(01,73-nLOmitad,03,76,.T.)
centrar(cPAmensaje,02,75-nLOmitad,75)
IF nPAsegundos!=NIL
	INKEY(nPAsegundos)
ENDIF
IF lPArestaurar
	RESTSCREEN(00,73-nLOmitad,05,78,cLOpantalla)
ENDIF
SETCURSOR(nLOcursorActual)
RETURN(.T.)


*-------------------------------------------------------------------------
*
* Funcion.....: longDate
*
* Parametros..: dPAfecha //Cadena de fecha en el formato dd/mm/aa
*
* Resumen.....:	Retorna la fecha pasada como parametro convertida a una
*				expresi�n de caracteres.
*
*-------------------------------------------------------------------------
FUNCTION longDate(dPAfecha)
RETURN(CDOW(dPAfecha)+","+STR(DAY(dPAfecha),2)+" de "+CMONTH(dPAfecha)+" de "+STR(YEAR(dPAfecha),4))


*-------------------------------------------------------------------------
*
* Funcion.....: eleccion
*
* Parametros..:	aPAitemsMenu	//Array que contiene los elementos de menu
*				cPAmensaje		//Cadena que contiene la descripcion de la
*								  posicion actualmente seleccionada en el men�.
*				aPAitemsEnable	//Arreglo l�gico que indica cuales opciones
*								  del men� son seleccionables.
*
* Retorna.....:	nLOmenu		// Posicion seleccionada en el menu
*
* Resumen.....:	La funcion relaciona el elemento seleccionado con su posicion,
*				y devuelve este valor
*				Si la seleccion se aborta, se retorna 0.
*
*-------------------------------------------------------------------------
FUNCTION eleccion(aPAitemsMenu, cPAmensaje, aPAitemsEnable)
LOCAL nLOmenu,cLOmensaje,nLOlargo,nLOancho,cLOpantalla
nLOmenu:=1
cLOmensaje:=IIF(cPAmensaje==NIL,"->*Elija*<-",cPAmensaje)
nLOlargo:=	IIF(LEN(aPAitemsMenu)>=12,14,LEN(aPAitemsMenu)+1)
nLOlarcho:=	IIF(LEN(aPAitemsMenu)>=12,12,LEN(aPAitemsMenu))
nLOancho:=	INT(LEN(aPAitemsMenu[1])/2)
cLOpantalla:=SAVESCREEN(02,(36-nLOancho),(09+nLOlargo),(44+nLOancho))
window(04,(38-nLOancho),(08+nLOlargo),(42+nLOancho), .T.)
centrar(cLOmensaje,05,40-nLOancho,40+nLOancho)
IF PCOUNT()==3
	nLOmenu:=ACHOICE(06,40-nLOancho,08+nLOlarcho,40+nLOancho,aPAitemsMenu,aPAitemsEnable)
ELSE
	nLOmenu:=ACHOICE(06,40-nLOancho,08+nLOlarcho,40+nLOancho,aPAitemsMenu)
ENDIF
IF nLOmenu<1 .OR. nLOmenu>LEN(aPAitemsMenu)
	nLOmenu:=eleccion(aPAitemsMenu, cPAmensaje, aPAitemsEnable)
ENDIF
RESTSCREEN(02,(36-nLOancho),(09+nLOlargo),(44+nLOancho),cLOpantalla)
RETURN( nLOmenu )



*-------------------------------------------------------------------------
*
* Funcion.....: controlTeclas
*
* Parametros..:	Parametros de ACHOICE: nPAmodo 		//modo de ACHOICE
*									   nPAopcion	//opcion seleccionada
*									   nPApos		//fila de la opcion
*
* Retorna.....:	nLOretorno  //Valor numerico para ser evaluado por ACHOICE
*
* Resumen.....:	Funcion de usuario para ACHOICE.
*
*-------------------------------------------------------------------------
FUNCTION controlTeclas(nPAmodo,nPAopcion,nPApos)
LOCAL nLOtecla,nLOretorno	//Valor de retorno para ACHOICE
							//(0=salir,1=elegir,2=continuar
nLOtecla:=LASTKEY()
DO CASE
	CASE nLOtecla==K_RIGHT .OR. nLOtecla==K_ENTER
		IF LASTKEY()=K_ESC
			nLOretorno:=0
		ELSE
			nLOretorno:=1
		ENDIF
	CASE nLOtecla==K_ESC
		nLOretorno:=0
	OTHERWISE
		//mostrarParametros(nPAopcion)
		nLOretorno:=2
ENDCASE
RETURN nLOretorno




*-------------------------------------------------------------------------
*
* Funcion.....: pUpper
*
* Parametros..:	cPAtexto	// Cadena a convertir
*
* Retorna.....:	El mismo valor contenido en cPAtexto
*
* Resumen.....: Dado un texto contenido en cPAtexto, la funcion lo retorna poniendo a la
*				a la primer letra en mayusculas y el resto en minusculas
*
*-------------------------------------------------------------------------
FUNCTION pUpper(cPAtexto)
RETURN( UPPER(LEFT(cPAtexto,1))+LOWER(SUBSTR(cPAtexto,2,LEN(cPAtexto)-1)) )


*-------------------------------------------------------------------------
*
* Funcion.....: exacto
*
* Resumen.....:	Redondea en dos decimales el valor pasado como parametro.
*
* Autor.......: Sch�nhals Fischer, Rodolfo Eduardo
*
* Ultima Rev..: Wed 07/10/1998 23:34:38  Adolfo con R
*
*-------------------------------------------------------------------------
FUNCTION exacto(nPAnumero)
RETURN ROUND(nPAnumero,2)



*-------------------------------------------------------------------------
*
* Funcion.....: valTime
*
* Parametros..:	cPAtime
*
* Retorna.....:
*
* Resumen.....:
*
*-------------------------------------------------------------------------
FUNCTION valTime(cPAtime)
RETURN(VAL(SUBSTR(cPAtime,1,2)+SUBSTR(cPAtime,4,2)+SUBSTR(cPAtime,7,2)))


*-------------------------------------------------------------------------
*
* Funcion.....: salirYa
*
* Autor.......: Sch�nhals Fischer, Rodolfo Eduardo
*
* Ultima Rev..: Wed 07/10/1998 23:34:38  Adolfo con R
*
*-------------------------------------------------------------------------
FUNCTION salirYa()
LOCAL nLOindice, cLOpantalla
*	FOR nLOindice:=1 TO MAXCOL()
*		cLOpantalla:=SAVESCREEN(00,02,MAXROW(),MAXCOL())
*		RESTSCREEN(00,00,MAXROW(),MAXCOL()-3,cLOpantalla)
*		@ 00,78 CLEAR TO MAXROW(),MAXCOL()
*	ENDFOR
SETCOLOR("W/N")
@ 00,00 CLEAR TO MAXROW(),MAXCOL()
sonidoVenir()
screenBackExit(1)
SETCOLOR("W/N,N,N,N,N")
@ 24,00 SAY " "
CLOSE ALL
RELEASE ALL
SETCURSOR(1)
QUIT
RETURN(.T.)

*-------------------------------------------------------------------------
*
* Funcion.....: calculaCoordenadas
*
* Parametros..:	nPAlenElemento1	//
*				nPAlenArray		//
*
* Retorna.....:	aLOcoordenadas	//
*
*-------------------------------------------------------------------------
FUNCTION calculaCoordenadas(nPAlenElemento1, nPAlenArray)
LOCAL aLOcoordenadas, nLOlenArray
nLOlenArray:=IIF(PCOUNT()==1, MAXROW()-15, nPAlenArray)
aLOcoordenadas:=ARRAY(4)
aLOcoordenadas[1]:=INT((MAXROW()-nLOlenArray)/2) + 1
aLOcoordenadas[3]:=aLOcoordenadas[1] + nLOlenArray - 1
aLOcoordenadas[2]:=INT((MAXCOL()-nPAlenElemento1)/2)
aLOcoordenadas[4]:=aLOcoordenadas[2] + nPAlenElemento1
RETURN (aLOcoordenadas)


*-------------------------------------------------------------------------
*
* Funcion.....: screenBackExit
*
* Resumen.....:
*
*-------------------------------------------------------------------------
FUNCTION screenBackExit(xPAtipo)
LOCAL nLOx, nLOy
	nLOx:=11
	nLOy:=08
	@ nLOx+01,nLOy+01 SAY "          Wavbit CMS 1.0             "
	@ nLOx+02,nLOy+01 SAY " JOSE LUIS ALFARO - JULIO DE 2023 "
RETURN .T.


*-------------------------------------------------------------------------
*
* Funcion.....: sobreElAutor
*
* Parametros..:	ninguno
*
*-------------------------------------------------------------------------
FUNCTION sobreElAutor()
LOCAL cLOpanta
SAVE SCREEN TO cLOpanta
window(07,09,16,69,.T.)
@ 09,26 SAY "INFORMACION SOBRE EL AUTOR" COLOR colorInverso()
@ 13,11 SAY " La empresa Ceiboo tiene sus oficinas en Parque Sarmiento 500, "
@ 14,11	SAY "    Gualeguaychu (2820) Entre Rios, Tel.+54 3446-557777.    "
INKEY(0)
RESTORE SCREEN FROM cLOpanta
RETURN .T.


*-------------------------------------------------------------------------
*
* Funcion.....:	keyBoard()
*
* Parametros..: xPAvalor //Si es numerico es el ascii del caracter a poner
*						   en el teclado, Si es caracter contiene la cadena
*						   a poner en el teclado.
*
* Resumen.....:	Coloca en la memoria intermedia de teclado el caracter
*				correspondiente al ascii pasado como parametro (si este es
*				numerico) o la cadena recibida como par�metro si es caracter.
*
*-------------------------------------------------------------------------
FUNCTION keyBoard(xPAvalor)
KEYBOARD IIF(VALTYPE(xPAvalor)=="C",xPAvalor,IIF(VALTYPE(xPAvalor)=="N",CHR(xPAvalor),NIL))
RETURN .T.


*-------------------------------------------------------------------------
*
* Funci�n.....: estaEntre
*
* Par�metros..: nPAvalor			//Nro. a validar.
*				nPAdesde, nPAhasta	//L�mites v�lidos para el nro.
*
* Retorna.....: .T. si el valor pasado como par�metro est� entre nPAdesde y
*				nPAhasta inclusive, de lo contrario .F.
*
*-------------------------------------------------------------------------
FUNCTION estaEntre(nPAvalor, nPAdesde, nPAhasta)
RETURN IIF(nPAvalor>=nPAdesde .AND. nPAvalor<=nPAhasta, .T., .F.)




*-------------------------------------------------------------------------
*
* Funcion.....:	Bisiesto
*
* Parametros..: dPAfecha
*
* Retorna.....:	True o False
*
* Resumen.....:	Devuelve .T. si el a�o que le pasamos como parametro es bisiesto
*
* Autor.......: Fern�ndez Mat�as
*
* Ultima Rev..: Mat�as
*
*-------------------------------------------------------------------------
FUNCTION Bisiesto(dPAfecha)
LOCAL nLOano:=0

IF VALTYPE(dPAfecha)=="D"
	nLOano=YEAR(dPAfecha)
ELSE
    nLOano=dPAfecha
ENDIF
IF ROUND(nLOano/4,0)*4=nLOano
	RETURN .T.
ENDIF
RETURN .F.


*-------------------------------------------------------------------------
*
* Funcion.....:	esNumero
*
*-------------------------------------------------------------------------
FUNCTION esNumero(cPAvalor)
LOCAL lLOvalor:=.T., nLOindice:=1
cPAvalor:=ALLTRIM(cPAvalor)
IF LEN(cPAvalor)>0
	FOR nLOindice:=1 TO LEN(cPAvalor)
		IF !(SUBSTR(cPAvalor,nLOindice,1)$"0123456789.")
			lLOvalor:=.F.
			EXIT
		ENDIF
	NEXT
ELSE
	lLOvalor:=.F.
ENDIF
RETURN lLOvalor

FUNCTION colorNormal()
*LOCAL aLOcolores:=&(aPUconfig[MI_TONO])
*RETURN aLOcolores[1]
RETURN aPUconfig[MI_ARRAYTONO][1]

FUNCTION colorInverso()
*LOCAL aLOcolores:=&(aPUconfig[MI_TONO])
*RETURN aLOcolores[2]
RETURN aPUconfig[MI_ARRAYTONO][2]

FUNCTION colorFondo()
*LOCAL aLOcolores:=&(aPUconfig[MI_TONO])
*RETURN aLOcolores[3]
RETURN aPUconfig[MI_ARRAYTONO][3]

FUNCTION colorDeshabilitado()
*LOCAL aLOcolores:=&(aPUconfig[MI_TONO])
*RETURN aLOcolores[4]
RETURN aPUconfig[MI_ARRAYTONO][4]