
#include "inkey.ch"


FUNCTION BrowseData(aData)

  
    LOCAL oBrowse
    LOCAL n       := 1
    LOCAL nCursor, roc, col
    LOCAL nTotalColumns
    LOCAL cColor
    LOCAL nRow, nCol
    LOCAL cLOpantallaLocal
    LOCAL aColumnData
    
    LOCAL nKey
    LOCAL nTmpRow, nTmpCol
    LOCAL lEnd    := .F.
    LOCAL aCol1,aCol2,aCol3,aCol4,aCol5,aCol6,aCol7,aCol8,aCol9,aCol10,aCol11,aCol12,aCol13,aCol14,aCol15,aCol16,aCol17,aCol18,aCol19,aCol20
 
    cLOpantallaLocal:=savescreen(00,00,MAXROW(),MAXCOL())
    RESTSCREEN(00,00,MAXROW(),MAXCOL(),cPUmainScreen)
    oBrowse := TBrowseNew( 02, 01, MAXROW()-2, MAXCOL()-1 )
    
 
    oBrowse:colorSpec     := ColorPrimary()
    oBrowse:ColSep        := hb_UTF8ToStrBox( "│" )
    oBrowse:HeadSep       := hb_UTF8ToStrBox( "╤═" )
    oBrowse:FootSep       := hb_UTF8ToStrBox( "╧═" )
    oBrowse:GoTopBlock    := {|| n := 1 }
    oBrowse:GoBottomBlock := {|| n := Len( aData["data"] ) }
    oBrowse:SkipBlock     := {| nSkip, nPos | nPos := n, ;
       n := iif( nSkip > 0, Min( Len( aData["data"] ), n + nSkip ), ;
       Max( 1, n + nSkip ) ), n - nPos }
 
   nTotalColumns:=iif(LEN(aData["labels"])<=20,LEN(aData["labels"]),20);

   aColumnData := Array(LEN(aData["labels"]),LEN(aData["data"]))
   FOR col := 1 TO nTotalColumns
      FOR row := 1 TO LEN(aData["data"])
         aColumnData[col,row]:=aData["data"][row][col]
      NEXT
   NEXT   

   FOR col := 1 TO nTotalColumns
      DO CASE
      CASE col == 1
         aCol1 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol1[n] } ) )
      CASE col == 2
         aCol2 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol2[n] } ) )
      CASE col == 3
         aCol3 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol3[n] } ) )
      CASE col == 4
         aCol4 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol4[n] } ) )
      CASE col == 5
         aCol5 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol5[n] } ) )
      CASE col == 6
         aCol6 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol6[n] } ) )
      CASE col == 7
         aCol7 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol7[n] } ) )
      CASE col == 8
         aCol8 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol8[n] } ) )
      CASE col == 9
         aCol9 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol9[n] } ) )
      CASE col == 10
         aCol10 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol10[n] } ) )
      CASE col == 11
         aCol11 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol11[n] } ) )
      CASE col == 12
         aCol12 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol12[n] } ) )
      CASE col == 13
         aCol13 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol13[n] } ) )
      CASE col == 14
         aCol14 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol14[n] } ) )
      CASE col == 15
         aCol15 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol15[n] } ) )
      CASE col == 16
         aCol16 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol16[n] } ) )
      CASE col == 17
         aCol17 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol17[n] } ) )
      CASE col == 18
         aCol18 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol18[n] } ) )
      CASE col == 19
         aCol19 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol19[n] } ) )
      CASE col == 20
         aCol20 := aColumnData[col]
         oBrowse:AddColumn( TBColumnNew( aData["labels"][col], {|| aCol20[n] } ) )
      ENDCASE
      oBrowse:GetColumn( col ):Footing := "String"

   NEXT
    oBrowse:Configure()
 

    oBrowse:Freeze := 1
    nCursor := SetCursor( 0 )
    cColor := SetColor( colorPrimary() )
    nRow := Row()
    nCol := Col()
    hb_DispBox( 01, 00, MAXROW()-1, MAXCOL(), hb_UTF8ToStrBox( "┌─┐│┘─└│ " ) )
    oBrowse:Refreshall()
    
    WHILE ! lEnd
       oBrowse:ForceStable()
 
       nKey := Inkey( 0 )
 
       DO CASE
       CASE nKey == K_ESC
          SetPos( 17, 0 )
          lEnd := .T.
 
       CASE nKey == K_DOWN
          oBrowse:Down()
 
       CASE nKey == K_UP
          oBrowse:Up()
 
       CASE nKey == K_LEFT
          oBrowse:Left()
 
       CASE nKey == K_RIGHT
          oBrowse:Right()
 
       CASE nKey == K_PGDN
          oBrowse:pageDown()
 
       CASE nKey == K_PGUP
          oBrowse:pageUp()
 
       CASE nKey == K_CTRL_PGUP
          oBrowse:goTop()
 
       CASE nKey == K_CTRL_PGDN
          oBrowse:goBottom()
 
       CASE nKey == K_HOME
          oBrowse:home()
 
       CASE nKey == K_END
          oBrowse:end()
 
       CASE nKey == K_CTRL_LEFT
          oBrowse:panLeft()
 
       CASE nKey == K_CTRL_RIGHT
          oBrowse:panRight()
 
       CASE nKey == K_CTRL_HOME
          oBrowse:panHome()
 
       CASE nKey == K_CTRL_END
          oBrowse:panEnd()
 
       CASE nKey == K_TAB
          hb_DispOutAt( 0, 0, Time() )
 
       ENDCASE
 
    ENDDO
    SetPos( nRow, nCol )
    SetColor( cColor )
    SetCursor( nCursor )
    RESTSCREEN(00,00,MAXROW(),MAXCOL(),cLOpantallaLocal)
 
 RETURN .T.
 
