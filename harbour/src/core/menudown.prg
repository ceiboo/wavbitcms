#include "inkey.ch"
#include "config.ch"

FUNCTION menuTopBar(aPAoptions,nPAtree,cPAmodule)
LOCAL 	nLOkey:=1,;		
		nLOcounter:=0,;	
		nLOoptionBar:=1,;
		nLOitemsBar:=LEN(aPAoptions),;
		aLOoldMenu:=ARRAY(nPAtree),;
		aLOoldKey:=ARRAY(nPAtree),;
		aLOoldScreen:=ARRAY(nPAtree),;
		nLOstepMenu:=1,;
		aLOmenuActual:=EVAL(aPAoptions[nLOoptionBar,2])

PUBLIC cPUmainScreen

	CLEAR SCREEN
	FOR nLOcounter:= 0 TO MAXROW()
		@  nLOcounter, 00 SAY REPLICATE(chr(176),MAXCOl()+1)  COLOR colorBackground()
	ENDFOR

	@  00, 00 SAY SPACE(MAXCOL()+1) COLOR colorBackground()
	@  01, 00 SAY SPACE(MAXCOL()+1) COLOR colorPrimary()
	@  00, 01 SAY longDate(DATE()) COLOR colorBackground()
	@  00, MAXCOL()-23 SAY "Nia Tracker System 1.0" COLOR colorBackground()
	
	@  MAXROW(), 00 SAY SPACE(MAXCOL()+1) COLOR colorBackground()
	@  MAXROW(), 01 SAY "Company: Nia LLC." COLOR colorBackground()
	@  MAXROW(), MAXCOL()-15 SAY "Wavbit Technologies" COLOR colorBackground()
		
	cPUmainScreen:=savescreen(00,00,MAXROW(),MAXCOL())

	DO WHILE .T.
		RESTSCREEN(00,00,MAXROW(),MAXCOL(),cPUmainScreen)
	
		* show menu items
		nLOcoordx:=0
		FOR nLOcounter:= 1 TO nLOitemsBar
			IF nLOcounter!=nLOoptionBar
				@ 01,nLOcoordx SAY aPAoptions[nLOcounter,1] COLOR colorPrimary()
			ELSE
				@ 01,nLOcoordx SAY aPAoptions[nLOcounter,1] COLOR colorSecondary()
				nLOcoordy:=nLOcoordx
			ENDIF
			nLOcoordx:=nLOcoordx+LEN(aPAoptions[nLOcounter,1])
		ENDFOR

		nLOstepMenu:=1
		aLOmenuActual:=EVAL(aPAoptions[nLOoptionBar,2])
		nLOcoordx:=1

	* almaceno los valores anteriores para restaurar
	aLOoldMenu[nLOstepMenu]:=aLOmenuActual
	DO WHILE .T.
		aLOreturnMenu:=menuDropdown(aLOmenuActual, nLOcoordx, nLOcoordy+01, nLOkey, .T.)		
*		@  MAXROW(), 41 SAY "Car.:"+STR(MEMORY(0),10,2)+"  Cont:"+STR(MEMORY(1),10,2)+"  RUN:"+STR(MEMORY(2),10,2)
		nLOkey:=aLOreturnMenu[1]
		nLOaccion:=aLOreturnMenu[2]
		SAVE SCREEN TO aLOoldScreen[nLOstepMenu]
		DO CASE
			* Si se presiona ENTER o la tecla rapida de la opcion: 
			CASE nLOkey <300
				aLOmenuActual:=EVAL(nLOaccion)
				* Si hay un Submenu para anidar:
				IF VALTYPE(aLOmenuActual)=="A"
					* nLOkey es el nro de item seleccionado del menu:
					aLOoldKey[nLOstepMenu]:=nLOkey
					nLOstepMenu++
					* la coordenada y se incementa 6 posiciones a la derecha:
					nLOcoordy:=nLOcoordy+6	 
					* la coordenada x se incementa en la cant. de opciones (nLOkey) +1:
					nLOcoordx:=nLOcoordx+nLOkey+1		
				
					* almaceno los valores anteriores para restaurar:
					aLOoldMenu[nLOstepMenu]:=aLOmenuActual
					aLOoldKey[nLOstepMenu]:=nLOkey
					nLOkey:=1
				ELSE	//Si no hay otro submenu:
					* recupero los valores anteriores:
					aLOmenuActual:=aLOoldMenu[nLOstepMenu]
					RESTORE SCREEN FROM aLOoldScreen[nLOstepMenu]
				ENDIF
				LOOP

			CASE (nLOkey==327 .OR. nLOkey==319) .AND. nLOstepMenu >1
				nLOstepMenu--
				RESTORE SCREEN FROM aLOoldScreen[nLOstepMenu]
				aLOmenuActual:=aLOoldMenu[nLOstepMenu]
				nLOkey:=aLOoldKey[nLOstepMenu]
				* la pos. y es ahora y-6  
				nLOcoordy:=nLOcoordy-6 
				* la pos. x es ahora x-la cant. de opciones (nLOkey)-1
				nLOcoordx:=nLOcoordx-nLOkey-1			
				LOOP				

			CASE nLOkey==327 .AND. nLOstepMenu==1
				IF alert("ATENTION...","Do you want to exit the system now?")
					ExitNow()
				ENDIF
				nLOkey:=1	  //Si no sale queda en la 1er opcion del popup.

			CASE nLOkey==319
				nLOoptionBar:=IIF(nLOoptionBar=1,nLOitemsBar,nLOoptionBar-1)
				nLOkey:=1
				EXIT

			CASE nLOkey==304
				nLOoptionBar:=IIF(nLOoptionBar=nLOitemsBar,1,nLOoptionBar+1)
				nLOkey:=1
				EXIT

			CASE nLOkey==300+K_HOME .OR. nLOkey==300+K_END	//Inicio o fin de Operador.
				nLOkey:=1
				EXIT
		ENDCASE
	ENDDO
ENDDO
RETURN .T.


FUNCTION menuDropdown(aPApopupItem, nPAcoordX, nPAcoordY, nPAitemActual, lPAverHora, lPAsoloDibuja)
	LOCAL nLOcounter, nLOCantidadDeItems, nLORetornaOpcion, lLOCorta, nLOletra,;
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
	FOR nLOcounter:=1 TO nLOcantidadDeItems
		IF EMPTY(aPApopupItem[nLOcounter,1])
			@ nPAcoordX+nLOcounter,nPAcoordY SAY chr(204)+REPLICATE(chr(205),LEN(aPApopupItem[1,1])-1)+chr(185)
		ELSE
			nLOletra:=AT("@",aPApopupItem[nLOcounter,1])
			sLOitem:=STRTRAN(aPApopupItem[nLOcounter,1],"@")
			aLOletra[nLOcounter]:=UPPER(SUBSTR(sLOitem,nLOletra,1))
	
			IF nLOcounter==nPAitemActual
				@ nPAcoordX+nLOcounter,nPAcoordY+1 SAY sLOitem COLOR colorSecondary()
			ELSE
				@ nPAcoordX+nLOcounter,nPAcoordY+1 SAY sLOitem
				@ nPAcoordX+nLOcounter,nPAcoordY+nLOletra SAY aLOletra[nLOcounter] COLOR colorSecondary()
			ENDIF
		ENDIF
	ENDFOR
	DISPEND()
	
	IF lPAsoloDibuja
		RETURN {nPAitemActual,aPApopupItem[nPAitemActual,3]}
	ENDIF
	lLOcorta:=.F.
	nLOretornaOpcion:=nLOkey:=0
	nLOlinea:=nPAItemActual
	nLOcounter:=1
	dLOtiempoInicial:=SECONDS()
	centrar(aPApopupItem[nPAitemActual,2])
	DO WHILE nLOkey!=K_ESC
		nLOkey:=0
		DO WHILE nLOkey==0
			IF SECONDS()-dLOtiempoInicial > aPUconfig[CFG_SLEEP]
				dLOtiempoInicial:=SECONDS()
			ENDIF
			nLOkey:=INKEY()
			IF lPAverHora != NIL
				IF lPAverHora
					@ 00,72 SAY TIME() COLOR colorBackground()
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
			CASE UPPER(CHR(nLOkey)) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
				 lLOderecho:= .T.
				IF lLOderecho
					FOR nLOcounter:= 1 TO LEN(aPApopupItem)
						IF UPPER(CHR(nLOkey)) == aLOletra[nLOcounter]
							   lLOcorta:= .T.
							EXIT
						ENDIF
					ENDFOR
					IF lLOcorta
						nLOletra:=AT("@",aPApopupItem[nLOlinea,1])
						DISPBEGIN()
						@ nPAcoordX+nLOlinea,nPAcoordY+1		SAY STRTRAN(aPApopupItem[nLOlinea,1],"@")
						@ nPAcoordX+nLOlinea,nPAcoordY+nLOletra	SAY aLOletra[nLOlinea] COLOR colorSecondary()
						@ nPAcoordX+nLOcounter,nPAcoordY+1		SAY STRTRAN(aPApopupItem[nLOcounter,1],"@") COLOR colorSecondary()
						DISPEND()
						centrar(aPApopupItem[nLOcounter,2])
						nLOretornaOpcion:=nLOcounter
						EXIT
					ELSE	
						TONE(100,5)
					ENDIF
				ENDIF
	
			* Teclas de salida: 
			CASE nLOkey==K_ESC .OR. nLOkey==K_LEFT .OR. nLOkey==K_RIGHT
				nLOretornaOpcion:=300+nLOkey
				EXIT
			CASE nLOkey==K_ENTER
				lLOderecho:= .T.
				IF lLOderecho
					nLOretornaOpcion:=nLOlinea
					EXIT
				ENDIF
	
			CASE nLOkey==K_UP .OR. nLOkey==K_DOWN
				nLOletra:=AT("@",aPApopupItem[nLOlinea,1])
				DISPBEGIN()
				@ nPAcoordX+nLOlinea,nPAcoordY+1 SAY STRTRAN(aPApopupItem[nLOlinea,1],"@")
				@ nPAcoordX+nLOlinea,nPAcoordY+nLOletra SAY aLOletra[nLOlinea] COLOR colorSecondary()
				DISPEND()
				IF nLOkey==K_DOWN
					nLOlinea:=IIF(nLOlinea==LEN(aPApopupItem),1,nLOlinea+1)
				 ELSE
					nLOlinea:=IIF(nLOlinea==1,LEN(aPApopupItem),nLOlinea-1)
				ENDIF
				IF EMPTY(aPApopupItem[nLOlinea,1])
					IF nLOkey==K_DOWN
						nLOlinea:=IIF(nLOlinea==LEN(aPApopupItem),1,nLOlinea+1)
					 ELSE
						nLOlinea:=IIF(nLOlinea==1,LEN(aPApopupItem),nLOlinea-1)
					ENDIF
				ENDIF
				DISPBEGIN()
				@ nPAcoordX+nLOlinea,nPAcoordY+1 SAY STRTRAN(aPApopupItem[nLOlinea,1],"@") COLOR colorSecondary()
				DISPEND()
				centrar(aPApopupItem[nLOlinea,2])
				dLOtiempoInicial:=SECONDS()
		ENDCASE
	ENDDO
	IF nLOkey==0
		nLOretornaOpcion:=327
	ENDIF
RETURN {nLOretornaOpcion,IIF(nLOretornaOpcion>300,"",aPApopupItem[nLOretornaOpcion,3])}
	