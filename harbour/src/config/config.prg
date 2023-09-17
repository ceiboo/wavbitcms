#include "config.ch"

*-------------------------------------------------------------------------
*
* Function.....: initConfig()
*
*-------------------------------------------------------------------------
FUNCTION initConfig()
	PUBLIC aPUconfig:=ARRAY(1)
	aPUconfig[CFG_SLEEP]:=120
RETURN .T.

FUNCTION colorPrimary()
RETURN 'W/N+'
	
FUNCTION colorSecondary()
RETURN 'N/W'
	
FUNCTION colorBackground()
RETURN 'N+/W'
	
FUNCTION colorDisable()
RETURN 'N+/W'
	