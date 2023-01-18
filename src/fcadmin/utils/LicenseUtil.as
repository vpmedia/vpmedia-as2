/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-14
 ******************************************************************************/


/**
 * Internal use only.
 * @exclude
 */
class fcadmin.utils.LicenseUtil
{
	static function editionString(rawInfo:Object):String
	{
		var str:String="";
		switch(rawInfo.edition)
		{			
		      case 4 : 
			  str = "DEVNET";
			  break;
		      case 5 : 
			  str = "VOLUME";
			  break;
		      case 6 : 
			  str = "TRIAL";
			  break;
		      case 7 : 
			  str = "NOT FOR RESALE";
			  break;
		      case 8 : 
			  str = "BETA";
			  break;
		      case 9 : 
			  str = "OEM";
			  break;
		      default :
			  str = "UNKNOWN";
		}
		return str;
	}


	static function typeString(rawInfo:Object):String
	{
		var type:String="";
		
		if(rawInfo.max_connections == 5)
		{
			type="Developer";
		}
		else
		{
			type=rawInfo.type==0?"Commercial":"Educational";
		}
		return type;
	}


	static function familyString(rawInfo:Object):String
	{
		return rawInfo.family==0?"Personal":"Professional";
	}



	static function productCodeString(rawInfo:Object):String
	{
		 var str:String="";
		 
		 switch (rawInfo.product_code) {
                    case 362 : 
                        str = "Personal";
                        break;
                    case 681 : 
                        str = "Personal (Educational)";
                        break;
                    case 420 : 
                        str = "Professional";
                        break;
                    case 529 : 
                        str = "Capacity Upgrade";
                        break;
                    case 828 : 
                        str = "Professional (Educational)";
                        break;
                    case 32 : 
                        str = "Capacity Upgrade";
                        break;
                    case 130 : 
                        str = "Personal";
                        break;
                    case 416 : 
                        str = "Personal";
                        break;
                    case 814 : 
                        str = "Personal Upgrade";
                        break;
                    case 729 : 
                        str = "Personal Upgrade";
                        break;
                    case 77 : 
                        str = "Professional";
                        break;
                    case 631 : 
                        str = "Professional";
                        break;
                    case 552 : 
                        str = "Professional Upgrade";
                        break;
                    case 407 : 
                        str = "Professional Upgrade";
                        break;
                    case 195 : 
                        str = "Professional 2Yr Sub";
                        break;
                    case 888 : 
                        str = "Professional 2Yr Sub";
                        break;
                    case 374 : 
                        str = "Capacity Upgrade";
                        break;
                    case 243 : 
                        str = "Capacity Upgrade";
                        break;
                    case 766 : 
                        str = "Capacity Upgrade";
                        break;
                    case 142 : 
                        str = "Capacity Upgrade";
                        break;
                    default : 
                        str = "Product Unknown ";
                        break;
                }

		return str;
	}


	static function hasExpire(rawInfo:Object):Boolean
	{
            return (((((rawInfo.edition == 6) || (((rawInfo.product_code == 32) || (rawInfo.product_code == 529)) && ((rawInfo.edition == 2) || (rawInfo.edition == 3)))) || (rawInfo.product_code == 374)) || (rawInfo.product_code == 243)) || ((rawInfo.edition == 1) && ((((rawInfo.product_code == 77) || (rawInfo.product_code == 631)) || (rawInfo.product_code == 766)) || (rawInfo.product_code == 142)))) 
	}



	static function isCapacityUpgrade(rawInfo:Object):Boolean
	{
		return ((((rawInfo.product_code == 374) || (rawInfo.product_code == 243)) || (rawInfo.product_code == 766)) || (rawInfo.product_code == 142))
	}

}
