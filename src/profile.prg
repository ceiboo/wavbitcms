*******************
**  Profile.PRG  **
*****************************************************************************
//
//  This software is provided as FREEWARE, with no warranty either explicit
//  or implied.  Any questions may be sent via Compuserve E-Mail to Dave
//  Rooney, 74562,1564.
//
*****************************************************************************
//
//  Author: Dave Rooney, CIS ID 74562,1564
//    Date: Jan. 12, 1995
//
//  This is an update to PROFILE.PRG dated Sep. 13, 1994.  No previous
//  version of Profile.PRG is required.
//
//  Changes:
//
//  1) File extensions other than .INI are allowed.
//  2) Added ProfileDate function to better handle date values.
//  3) Fixed section delimiter bug.
//  4) Changed date handling to use century.
//
//  Functions for reading and writing .INI files.
//
//  PUBLIC FUNCTIONS:
//
//  ProfileString( cINIFile, cSection, cKey, cDefault )
//  ProfileNum( cINIFile, cSection, cKey, nDefault )
//  ProfileDate( cINIFile, cSection, cKey, dDefault )
//  SetProfile( cINIFile, cSection, cKey, xValue )
//
//  ProfileString is used to read a string from the specified .INI file.
//
//  Eg. cSystemPath := ProfileString( "TEST.INI", "System", "Path", "." )
//
//
//  ProfileNum is used to read a numeric value from the specified .INI file,
//  including logical values (stored as 0 or 1).
//
//  Eg. nMaxUsers := ProfileNum( "TEST.INI", "System", "MaxUsers", 20 )
//
//  ProfileDate is used to read a date value from the specified .INI file.
//  ( SetProfile stores dates in the format YYYYMMDD. )
//
//  Eg. dDownload := ProfileDate( "TEST.INI", "System", "LastDnld", DATE() )
//
//
//  SetProfile is used to store a value of any data type except objects,
//  code blocks & arrays in the .INI file.
//
//  lSuccess := SetProfile( "TEST.INI", "System", "MaxUsers", 20 )
//
//
//  Place REQUEST Profile anywhere in your code, and compile with /N /W.
//

ANNOUNCE Profile


#include "fileio.ch"

#ifndef _CRLF

#define  _CRLF    CHR(13) + CHR(10)

#endif


******************************
**  FUNCTION ProfileString  **
*****************************************************************************
//
//  This function reads a string from the specified .INI file.
//
//  Parameters: cFile    - The .INI file name to be used
//              cSection - The section from which to read
//              cKey     - The key value for which to search
//              cDefault - The default value if not found (optional)
//
//     Returns: cString - The string read from the file.
//

FUNCTION ProfileString ( cFile, cSection, cKey, cDefault )
LOCAL cString,       ; // The string read from the file
		nHandle,       ; // File handle for the read
		cBuffer,       ; // Buffer for the read
		nFileLen,      ; // Length of the file in bytes
		nSecPos,       ; // Position in the file of the specified section
		cSecBuf,       ; // Section subtring
		nKeyPos,       ; // Position in the file of the specified key value
		cChar            // Single character read from buffer

cKey:=cKey+"="
IF LEFT( cSection, 1 ) <> "["
	cSection := "[" + cSection
ENDIF

IF RIGHT( cSection, 1 ) <> "]"
	cSection += "]"
ENDIF

IF cDefault == NIL
	cDefault := ""
ENDIF

cString := cDefault

//
// If no extension is provided for the file, assume .INI.
//
IF RAT( ".", cFile ) == 0
	cFile := UPPER( ALLTRIM( cFile )) + ".INI"
ENDIF

nHandle := FOPEN( cFile, FO_READ + FO_SHARED )

IF nHandle > 0
	nFileLen := FSEEK( nHandle, 0, FS_END )

	FSEEK( nHandle, 0 , FS_SET )

	cBuffer := SPACE( nFileLen )

	//
	// Read in the entire file (.INI files should be less than 64K!).
	//
	IF FREAD( nHandle, @cBuffer, nFileLen ) == nFileLen
		//
		// Determine the position in the buffer
		// of the requested section.
		//
		nSecPos := AT( cSection, cBuffer )

		IF nSecPos > 0
			//
			// Extract the section from the buffer.
			//
			cSecBuf := RIGHT( cBuffer, nFileLen - ( nSecPos + LEN( cSection )))

			IF !EMPTY( cSecBuf )
				//
				// Get the position of the end of the section...
				//
				nSecPos := AT( "[", cSecBuf )

				//
				// ...and extract the section!
				//
				IF nSecPos > 0
					cSecBuf := LEFT( cSecBuf, nSecPos - 1 )
				ENDIF

				//
				// Now find the key within the section.
				//
				nKeyPos := AT( cKey, cSecBuf )

				IF nKeyPos > 0
					//
					// Load the return string with the value
					// until a carriage return is found.
					//
*					nKeyPos += LEN( cKey ) + 1
					nKeyPos += LEN( cKey )

					cString := cChar := ""

					DO WHILE cChar <> CHR(13)
						cChar := SUBSTR( cSecBuf, nKeyPos, 1 )

						IF cChar <> CHR(13)
							cString += cChar

							++ nKeyPos
						ENDIF
					ENDDO
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	FCLOSE( nHandle )
ENDIF

RETURN cString
//
// EOP: ProfileString
//


***************************
**  FUNCTION ProfileNum  **
*****************************************************************************
//
//  This function reads a number from the specified .INI file.
//
//  Parameters: cFile    - The .INI file name to be used
//              cSection - The section from which to read
//              cKey     - The key value for which to search
//              nDefault - The default value if not found (optional)
//
//     Returns: nValue - The numeric value read from the file.
//

FUNCTION ProfileNum ( cFile, cSection, cKey, nDefault )
LOCAL cValue,     ; // Profile string read from file
		cDefault,   ; // Default value converted to string
		nValue        // Profile string converted to numeric

IF nDefault == NIL
	nDefault := 0
ENDIF

nValue   := nDefault
cDefault := ALLTRIM( STR( nDefault ))

cValue := ProfileString( cFile, cSection, cKey, cDefault )

IF !EMPTY( cValue )
	nValue := VAL( cValue )
ENDIF

RETURN nValue
//
// EOP: ProfileNum
//


****************************
**  FUNCTION ProfileDate  **
*****************************************************************************
//
//  This function reads a date from the specified .INI file.
//
//  Parameters: cFile    - The .INI file name to be used
//              cSection - The section from which to read
//              cKey     - The key value for which to search
//              dDefault - The default date if not found (optional)
//
//     Returns: dDate - The date value read from the file.
//
FUNCTION ProfileDate ( cFile, cSection, cKey, dDefault )
LOCAL cDateFmt,   ; // Date format on entry
		cValue,     ; // Profile string read from file
		cDefault,   ; // Default value converted to string
		dDate         // Profile string converted to numeric

IF VALTYPE( dDefault ) <> "D"
	dDefault := CTOD( "" )
ENDIF

dDate    := dDefault
cDefault := ALLTRIM( DTOS( dDefault ))

cValue := ProfileString( cFile, cSection, cKey, cDefault )

IF !EMPTY( cValue )
	//
	// Try just converting the date as is.
	//
	dDate := CTOD( cValue )

	IF EMPTY( dDate )
		//
		// If that doesn't work, convert
		// using a standard date format.
		//
		cDateFmt := SET(_SET_DATEFORMAT, "mm/dd/yy" )

		dDate := CTOD( SUBSTR( cValue, 5, 2 ) + "/" + RIGHT( cValue, 2 ) + ;
						"/" + LEFT( cValue, 4 ))

		SET(_SET_DATEFORMAT, cDateFmt )
	ENDIF
ENDIF

RETURN dDate
//
// EOP: ProfileDate
//


***************************
**  FUNCTION SetProfile  **
*****************************************************************************
//
//  This function writes a value to the .INI file specified.
//
//  Parameters: cFile    - The .INI file name to be used
//              cSection - The section for which to search
//              cKey     - The key value for which to search
//              xValue   - The new value to be written
//
//     Returns: .T. if successful, .F. otherwise.
//

FUNCTION SetProfile ( cFile, cSection, cKey, xValue )
LOCAL lRetCode,      ; // Function's return code
		cType,         ; // Data type of the value
		cOldValue,     ; // Current value
		cNewValue,     ; // New value to be written
		nHandle,       ; // File handle for the read
		cBuffer,       ; // Buffer for the read
		nFileLen,      ; // Length of the file in bytes
		nSecStart,     ; // Start position in the file of the section
		nSecEnd,       ; // Ending position in the file of the section
		nSecLen,       ; // Initial length of the section
		cSecBuf,       ; // Section subtring
		nKeyStart,     ; // Start position in the file of the key
		nKeyEnd,       ; // Ending position in the file of the key
		nKeyLen,       ; // Initial length of the key
		lProceed,      ; // .T. if proceeding with the change
		cChar            // Single character read from file

IF LEFT( cSection, 1 ) <> "["
	cSection := "[" + cSection
ENDIF

IF RIGHT( cSection, 1 ) <> "]"
	cSection += "]"
ENDIF

//
// If no extension is provided for the file, assume .INI.
//
IF RAT( ".", cFile ) == 0
	cFile := UPPER( ALLTRIM( cFile )) + ".INI"
ENDIF

lProceed := .F.
nSecLen  := 0
cType    := VALTYPE( xValue )

DO CASE
	CASE cType == "C"
		cNewValue := xValue

	CASE cType == "N"
		cNewValue := ALLTRIM( STR( xValue ))

	CASE cType == "L"
		cNewValue := IF( xValue, "1", "0" )

	CASE cType == "D"
		cNewValue := DTOS( xValue )

	OTHERWISE
		cNewValue := ""
ENDCASE
nHandle := FOPEN( cFile, FO_READ + FO_EXCLUSIVE )

IF FERROR() == 2
	nHandle := FCREATE( cFile, 0 )
ENDIF

IF nHandle > 0
	nFileLen := FSEEK( nHandle, 0, FS_END )
	FSEEK( nHandle, 0 , FS_SET )
	cBuffer := SPACE( nFileLen )
	//
	// Read in the entire file (.INI files should be less than 64K!).
	//
	IF FREAD( nHandle, @cBuffer, nFileLen ) == nFileLen
		//
		// Determine the position in the buffer
		// of the requested section.
		//
		nSecStart := AT( cSection, cBuffer )
		IF nSecStart > 0
			nSecStart += LEN( cSection ) + 2 // Length of cSection + CR/LF

			//
			// Extract the section from the buffer.
			//
			cSecBuf := RIGHT( cBuffer, nFileLen - nSecStart + 1 )
			IF !EMPTY( cSecBuf )
				//
				// Get the position of the end of the section...
				//
				nSecEnd := AT( "[", cSecBuf )

				//
				// ...and extract the section!
				//
				IF nSecEnd > 0
					cSecBuf := LEFT( cSecBuf, nSecEnd - 1 )
				ENDIF
				nSecLen := LEN( cSecBuf )

				//
				// Now find the key within the section.
				//
				nKeyStart := AT( cKey, cSecBuf )
				IF nKeyStart > 0
					//
					// Load the return string with the value
					// until a carriage return is found.
					//
					nKeyStart += LEN( cKey ) + 1
					nKeyEnd   := nKeyStart

					cOldValue := cChar := ""
					DO WHILE cChar <> CHR(13)
						cChar := SUBSTR( cSecBuf, nKeyEnd, 1 )

						IF cChar <> CHR(13)
							cOldValue += cChar

							++ nKeyEnd
						ENDIF
					ENDDO

					//
					// Change the old value to the new one.
					//
					nKeyLen := LEN( cOldValue )
					cSecBuf := STUFF( cSecBuf, nKeyStart, nKeyLen, cNewValue )
					lProceed := .T.
				ELSE
					//
					// The key was not found - add it now!
					//
					//cSecBuf := _CRLF + cKey + "=" + cNewValue + _CRLF
					cSecBuf := cKey + "=" + cNewValue + _CRLF + cSecBuf
					lProceed := .T.
				ENDIF
			ENDIF
		ELSE
			//
			// The section was not found - add it now!
			//
			//cSecBuf := _CRLF + cSection + _CRLF + cKey + "=" + ;
			//               cNewValue + _CRLF
			cSecBuf := cSection + _CRLF + cKey + "=" + cNewValue + ;
							_CRLF + _CRLF
			lProceed := .T.
		ENDIF
	ENDIF

	IF lProceed
		//
		// Update the buffer with the new section.
		//
		IF nSecStart == 0
			nSecStart := LEN( cBuffer )
		ENDIF
		cBuffer := STUFF( cBuffer, nSecStart, nSecLen, cSecBuf )
		//
		// Replace the existing .INI file.
		//
		FCLOSE( nHandle )

		nHandle := FCREATE( cFile, 0 )
		IF FWRITE( nHandle, cBuffer ) == LEN( cBuffer )
			lRetCode := .T.
		ENDIF
	ENDIF
	FCLOSE( nHandle )
ENDIF
RETURN lRetCode
//
// EOP: SetProfile
//
