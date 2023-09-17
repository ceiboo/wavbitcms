*-------------------
*  MENU: Customers *      
*-------------------
FUNCTION menuCustomers()
RETURN {{" @Browse Customers   ","Browse Customers.",{||CustomersBrowse()},	'PA'},;
        {""},;
        {" @Add Customers      ","Add Users",{||CommingSoon()},'  '},;
		{" @Edit Customers     ","Add Users",{||CommingSoon()},'  '},;
		{" @Delete Customers   ","Add Users",{||CommingSoon()},'  '}}


FUNCTION CustomersBrowse()
    LOCAL aUsers
   
    aUsers:=API("GetUsers")
    BrowseData(aUsers)
    
RETURN .T.