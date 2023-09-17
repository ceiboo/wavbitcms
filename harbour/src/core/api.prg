FUNCTION API(method)
LOCAL cFile

    cFile := "../.storage/data/" + fulltime() + ".json"

    __Run("php ../php/command " + method + " > " + cFile)
    __Run( "command" ) 

RETURN( hb_jsonDecode( memoRead( cFile ) ) )