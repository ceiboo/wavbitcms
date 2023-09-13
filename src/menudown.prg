#include "inkey.ch"
#include "config.ch"
*-------------------------------------------------------------------------
*
* Archivo.....: menudown.prg
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
* Funcion.....: menuDescolgable
*
* Parametros..:	aPApopupItem  // Array(x,4) multidimensional que contiene las opciones para ese menu.
*				nPAcoordX     // Coordenadas superior izquierda, desde donde se construye el menu.
*    			nPAcoordY	  // Coordenadas superior izquierda, desde donde se construye el menu.
*				nPAitemActual // Contiene el numero de item con el que se debe comenzar.
*				lPAverHora	  // Valor logico que dice si se muestra o no la Hora.
*				lPAsoloDibuja // Valor logico que dice si se tratan teclas o no
*
* Retorna.....:
*
* Resumen.....: Función de Menu descolgable (popup) que se llama desde
*				menuBarraPrincipal.
*
* Autor.......: Alfaro José Luis
*
*-------------------------------------------------------------------------
FUNCTION menuDescolgable(aPApopupItem, nPAcoordX, nPAcoordY, nPAitemActual, lPAverHora, lPAsoloDibuja)
LOCAL nLOContador, nLOCantidadDeItems, nLORetornaOpcion, lLOCorta, nLOletra,;
	  sLOitem, aLOletra:=ARRAY(LEN(aPApopupItem)), lLOderecho, aLOmatrizDer
nPAcoordX++
IF nPAitemActual==NIL .OR. nPAitemActual==0
	nPAitemActual:=1
ENDIF
IF lPAsoloDibuja==NIL
	lPAsoloDibuja:=.F.
ENDIF
SET CURSOR OFF

nLOcantidadDeItems=LEN(aPApopupItem)
IF (nPAcoordX+1+nLOcantidadDeItems) > 23
	nPAcoordX:=nPAcoordX-(nPAcoordX+1+nLOcantidadDeItems-23)
ENDIF
IF nPAcoordY+LEN(aPApopupItem[1,1])+1 > 79
	nPAcoordY:=nPAcoordY-(nPAcoordY+LEN(aPApopupItem[1,1])+1-79)
ENDIF

window(nPAcoordX,nPAcoordY,nPAcoordX+1+nLOcantidadDeItems,nPAcoordY+LEN(aPApopupItem[1,1]), .T.)
DISPBEGIN()
FOR nLOcontador:=1 TO nLOcantidadDeItems
	IF EMPTY(aPApopupItem[nLOcontador,1])
		@ nPAcoordX+nLOcontador,nPAcoordY SAY chr(204)+REPLICATE(chr(205),LEN(aPApopupItem[1,1])-1)+chr(185)
	ELSE
		nLOletra:=AT("@",aPApopupItem[nLOcontador,1])
		sLOitem:=STRTRAN(aPApopupItem[nLOcontador,1],"@")
		aLOletra[nLOcontador]:=UPPER(SUBSTR(sLOitem,nLOletra,1))

		IF nLOcontador==nPAitemActual
			@ nPAcoordX+nLOcontador,nPAcoordY+1 SAY sLOitem COLOR colorInverso()
		ELSE
			@ nPAcoordX+nLOcontador,nPAcoordY+1 SAY sLOitem
			@ nPAcoordX+nLOcontador,nPAcoordY+nLOletra SAY aLOletra[nLOcontador] COLOR colorInverso()
		ENDIF
	ENDIF
ENDFOR
DISPEND()

IF lPAsoloDibuja
	RETURN {nPAitemActual,aPApopupItem[nPAitemActual,3]}
ENDIF
lLOcorta:=.F.
nLOretornaOpcion:=nLOtecla:=0
nLOlinea:=nPAItemActual
nLOcontador:=1
dLOtiempoInicial:=SECONDS()
centrar(aPApopupItem[nPAitemActual,2])
DO WHILE nLOtecla!=K_ESC
	nLOtecla:=0
	DO WHILE nLOtecla==0
		IF SECONDS()-dLOtiempoInicial > aPUconfig[MI_RETARDO]
			dLOtiempoInicial:=SECONDS()
		ENDIF
		nLOtecla:=INKEY()
		IF lPAverHora != NIL
			IF lPAverHora
				@ 00,72 SAY TIME() COLOR colorFondo()
			ENDIF
		ENDIF
	ENDDO

*	DO CASE
*		CASE (aPUoperador[MI_MODALIDAD]=="P" .OR. aPUoperador[MI_MODALIDAD]=="O");
*			.AND. EMPTY(aPUoperador[MI_OPERADOR])
*			logonOperador()
*		CASE aPUoperador[MI_MODALIDAD]=="L"
*		   	aPUoperador[MI_OPERADOR]:=""
*	ENDCASE

	CLEAR TYPEAHEAD
	DO CASE
		* Si se pulsa una letra se verifica si es una tecla rapida:
		CASE UPPER(CHR(nLOtecla)) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 			lLOderecho:= .T.
			IF lLOderecho
				FOR nLOcontador:= 1 TO LEN(aPApopupItem)
					IF UPPER(CHR(nLOtecla)) == aLOletra[nLOcontador]
       	                lLOcorta:= .T.
						EXIT
					ENDIF
				ENDFOR
				IF lLOcorta
					nLOletra:=AT("@",aPApopupItem[nLOlinea,1])
					DISPBEGIN()
					@ nPAcoordX+nLOlinea,nPAcoordY+1		SAY STRTRAN(aPApopupItem[nLOlinea,1],"@")
					@ nPAcoordX+nLOlinea,nPAcoordY+nLOletra	SAY aLOletra[nLOlinea] COLOR colorInverso()
					@ nPAcoordX+nLOcontador,nPAcoordY+1		SAY STRTRAN(aPApopupItem[nLOcontador,1],"@") COLOR colorInverso()
					DISPEND()
					centrar(aPApopupItem[nLOcontador,2])
					nLOretornaOpcion:=nLOcontador
					EXIT
                ELSE	
					TONE(100,5)
				ENDIF
			ENDIF

		* Teclas de salida: 
		CASE nLOtecla==K_ESC .OR. nLOtecla==K_LEFT .OR. nLOtecla==K_RIGHT
			nLOretornaOpcion:=300+nLOtecla
			EXIT
		CASE nLOtecla==K_ENTER
			lLOderecho:= .T.
    		IF lLOderecho
    			nLOretornaOpcion:=nLOlinea
    			EXIT
			ENDIF

		CASE nLOtecla==K_UP .OR. nLOtecla==K_DOWN
			nLOletra:=AT("@",aPApopupItem[nLOlinea,1])
			DISPBEGIN()
			@ nPAcoordX+nLOlinea,nPAcoordY+1 SAY STRTRAN(aPApopupItem[nLOlinea,1],"@")
			@ nPAcoordX+nLOlinea,nPAcoordY+nLOletra SAY aLOletra[nLOlinea] COLOR colorInverso()
			DISPEND()
			IF nLOtecla==K_DOWN
				nLOlinea:=IIF(nLOlinea==LEN(aPApopupItem),1,nLOlinea+1)
			 ELSE
				nLOlinea:=IIF(nLOlinea==1,LEN(aPApopupItem),nLOlinea-1)
			ENDIF
			IF EMPTY(aPApopupItem[nLOlinea,1])
				IF nLOtecla==K_DOWN
					nLOlinea:=IIF(nLOlinea==LEN(aPApopupItem),1,nLOlinea+1)
				 ELSE
					nLOlinea:=IIF(nLOlinea==1,LEN(aPApopupItem),nLOlinea-1)
				ENDIF
			ENDIF
			DISPBEGIN()
			@ nPAcoordX+nLOlinea,nPAcoordY+1 SAY STRTRAN(aPApopupItem[nLOlinea,1],"@") COLOR colorInverso()
			DISPEND()
			centrar(aPApopupItem[nLOlinea,2])
			dLOtiempoInicial:=SECONDS()
	ENDCASE
ENDDO
IF nLOtecla==0
	nLOretornaOpcion:=327
ENDIF
RETURN {nLOretornaOpcion,IIF(nLOretornaOpcion>300,"",aPApopupItem[nLOretornaOpcion,3])}


*-------------------------------------------------------------------------
*
* Funcion.....: menuBarraPrincipal
*
* Parametros..: aPAopciones		// Areglo con las opciones del menu de barra 
*								  principal y los submenues descolgables.
*				nPAanidaciones	// Nro. de anidaciones que pueden alcanzar
*								  los submenues.
*				cPAmodulo		// Nombre del modulo que llama a la funcion
*
* Resumen.....: Funcion que dibuja la pantalla principal de los modulos
*				y controla el menu principal y lo submenues descolgables.
*
*-------------------------------------------------------------------------
FUNCTION menuBarraPrincipal(aPAopciones,nPAanidaciones,cPAmodulo)
LOCAL 	nLOtecla:=1,;		// el numero de tecla que devuelve Menu Descolgable
		nLOcontador:=0,;	// contador
		nLOopcionBarra:=1,;	// el numero de opcion de la Barra
		nLOitemsBarra:=LEN(aPAopciones),;	// cantidad de items de la barra
		aLOmenuAnterior:=ARRAY(nPAanidaciones),;   	// menues descolgables anteriores
		aLOteclaAnterior:=ARRAY(nPAanidaciones),;	// teclas anteriores
		aLOpantallaAnterior:=ARRAY(nPAanidaciones)	// pantallas anteriores
PUBLIC cPUpantallaPrincipal

	IF FILE("PANTALLA.MEM")
		RESTORE FROM pantalla.mem ADDITIVE
	ELSE
		clear screen
		FOR nLOcontador:= 0 TO MAXROW()
			@  nLOcontador, 00 SAY REPLICATE(chr(178),MAXCOl()+1) COLOR colorInverso()
		ENDFOR
			
		cPUpantallaPrincipal:=savescreen(00,00,MAXROW(),MAXCOL())
	ENDIF
DO WHILE .T.
	* Disenio del fondo:
		RESTSCREEN(00,00,MAXROW(),MAXCOL(),cPUpantallaPrincipal)
		@  00, 00 SAY SPACE(MAXCOL()+1) COLOR colorFondo()
		@  01, 00 SAY SPACE(MAXCOL()+1) COLOR colorNormal()
		@  00, 01 SAY longDate(DATE()) COLOR colorFondo()
		@  00, MAXCOL()-14 SAY "Wavbit cms 1.0 " COLOR colorFondo()
		
		@  MAXROW(), 00 SAY SPACE(MAXCOL()+1) COLOR colorFondo()
		*@  MAXROW(), 01 SAY "Company: "+aPUempresa[MI_EMPRESA] COLOR colorFondo()
		@  MAXROW(), 01 SAY "Company: Wavbit" COLOR colorFondo()
		@  MAXROW(), MAXCOL()-15 SAY "Harbour Project" COLOR colorFondo()
	
	* Visualizacion en pantalla las opciones del menu de barra:
	nLOcoordx:=0
	FOR nLOcontador:= 1 TO nLOitemsBarra
		IF nLOcontador!=nLOopcionBarra
			@ 01,nLOcoordx SAY aPAopciones[nLOcontador,1] COLOR colorNormal()
		ELSE
			@ 01,nLOcoordx SAY aPAopciones[nLOcontador,1] COLOR colorInverso()
			nLOcoordy:=nLOcoordx
		ENDIF
		nLOcoordx:=nLOcoordx+LEN(aPAopciones[nLOcontador,1])
	ENDFOR

	nLOnivelMenu:=1
	aLOmenuActual:=EVAL(aPAopciones[nLOopcionBarra,2])
	nLOcoordx:=1

	* almaceno los valores anteriores para restaurar
	aLOmenuAnterior[nLOnivelMenu]:=aLOmenuActual
	DO WHILE .T.
		aLOdevuelveElMenu:=menuDescolgable(aLOmenuActual, nLOcoordx, nLOcoordy+01, nLOtecla, .T.)		
*		@  MAXROW(), 41 SAY "Car.:"+STR(MEMORY(0),10,2)+"  Cont:"+STR(MEMORY(1),10,2)+"  RUN:"+STR(MEMORY(2),10,2)
		nLOtecla:=aLOdevuelveElMenu[1]
		nLOaccion:=aLOdevuelveElMenu[2]
		SAVE SCREEN TO aLOpantallaAnterior[nLOnivelMenu]
		DO CASE
			* Si se presiona ENTER o la tecla rapida de la opcion: 
			CASE nLOtecla <300
				aLOmenuActual:=EVAL(nLOaccion)
				* Si hay un Submenu para anidar:
				IF VALTYPE(aLOmenuActual)=="A"
					* nLOtecla es el nro de item seleccionado del menu:
					aLOteclaAnterior[nLOnivelMenu]:=nLOtecla
					nLOnivelMenu++
					* la coordenada y se incementa 6 posiciones a la derecha:
					nLOcoordy:=nLOcoordy+6	 
					* la coordenada x se incementa en la cant. de opciones (nLOtecla) +1:
					nLOcoordx:=nLOcoordx+nLOtecla+1		
				
					* almaceno los valores anteriores para restaurar:
					aLOmenuAnterior[nLOnivelMenu]:=aLOmenuActual
					aLOteclaAnterior[nLOnivelMenu]:=nLOtecla
					nLOtecla:=1
				ELSE	//Si no hay otro submenu:
					* recupero los valores anteriores:
					aLOmenuActual:=aLOmenuAnterior[nLOnivelMenu]
					RESTORE SCREEN FROM aLOpantallaAnterior[nLOnivelMenu]
				ENDIF
				LOOP

			CASE (nLOtecla==327 .OR. nLOtecla==319) .AND. nLOnivelMenu >1
				nLOnivelMenu--
				RESTORE SCREEN FROM aLOpantallaAnterior[nLOnivelMenu]
				aLOmenuActual:=aLOmenuAnterior[nLOnivelMenu]
				nLOtecla:=aLOteclaAnterior[nLOnivelMenu]
				* la pos. y es ahora y-6  
				nLOcoordy:=nLOcoordy-6 
				* la pos. x es ahora x-la cant. de opciones (nLOtecla)-1
				nLOcoordx:=nLOcoordx-nLOtecla-1			
				LOOP				

			CASE nLOtecla==327 .AND. nLOnivelMenu==1
				IF seguro("ATENCION...","¿ Usted desea realmente salir ahora ?")
					salirYa()
				ENDIF
				nLOtecla:=1	  //Si no sale queda en la 1er opcion del popup.

			CASE nLOtecla==319
				nLOopcionBarra:=IIF(nLOopcionBarra=1,nLOitemsBarra,nLOopcionBarra-1)
				nLOtecla:=1
				EXIT

			CASE nLOtecla==304
				nLOopcionBarra:=IIF(nLOopcionBarra=nLOitemsBarra,1,nLOopcionBarra+1)
				nLOtecla:=1
				EXIT

			CASE nLOtecla==300+K_HOME .OR. nLOtecla==300+K_END	//Inicio o fin de Operador.
				nLOtecla:=1
				EXIT
		ENDCASE
	ENDDO
ENDDO
RETURN .T.
