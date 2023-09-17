*-------------------
*  MENU: Users  *      
*-------------------
FUNCTION menuUsers()
RETURN {{" @Browse Users    ","Browse Users.",{||UsersBrowse()},	'PA'},;
        {""},;
        {" @Add User        ","Add Users",{||CommingSoon()},'  '},;
		{" @Edit User       ","Add Users",{||CommingSoon()},'  '},;
		{" @Delete User     ","Add Users",{||CommingSoon()},'  '}}


FUNCTION UsersBrowse()
    LOCAL aUsers
    
   
    aUsers:=API("GetUsers")
    BrowseData(aUsers)
    
RETURN .T.