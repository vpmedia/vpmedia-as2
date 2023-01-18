class gugga.utils.ValidationBase
{

	 public static var MonthsLength:Array = [31,28,31,30,31,30,31,31,30,31,30,31];

	
	public static function isValid(aDay:Number,aMonth:Number,aYear:Number):Boolean
	{
	
		if (aYear == undefined || aDay == undefined || aMonth == undefined )
			return false; 

		if (aYear <= 0 )
			return false; 			
	
	    if (aMonth <= 0 || aMonth > 12)
			return false; 			

		if (aDay <=0 )
			return false; 			

		if (aMonth != 2 )
		{	
			if( aDay > MonthsLength[aMonth-1])
				return false; 			
		}
		else // check for FEB 29
		{
			if ( aDay > 29 )
				return false;
			if (aDay == 29) 
			{
				if ((aYear % 100) == 0  && (aYear % 400) != 0)
					return false; 

				if ((aYear % 4) != 0 )
					return false; 
			}
		}

		return true; 
	}

	
	public static function isEmpty(aVal)
	{
		var val = Trim(aVal);
		if (val == "" || val == undefined || val == null)
			return true;
		else 
			return  false;
	}
	
	public static function isEMail(val)
	{
		var email:String = val;
		email = Trim(email);
		var atIndex:Number = email.indexOf("@");
		var dotIndex:Number = email.lastIndexOf(".");

		//forbidden characters
		var iChars = " *|,\":<>[]{}`'\\;()&$#%";
		for (var i = 0; i < email.length; i++) {
			if (iChars.indexOf(email.charAt(i)) != -1) return false;
		}
		
		// is there second @ 
		if  (email.indexOf("@",atIndex+1) > 0  )
			return false;
			
		if (atIndex > 0 && dotIndex >0 && atIndex+1 < dotIndex && dotIndex < val.length-2 )
			return true;
		else 
			return  false;
	}
	
	public static function isNumeric(val){
		var iChars = "0123456789";
		for (var i = 0; i < val.length; i++) {
			if (iChars.indexOf(val.charAt(i)) == -1) return false;
		}
		return true;
	}
	
	
	//**************************************************
	//*                                                *
	//*  Removes white spaces from both String sides   *
	//*                                                *
	//**************************************************
	public static function Trim(pStringValue:String):String {
				
		return TrimRight(TrimLeft(pStringValue));		
	}

	//**************************************************
	//*                                                *
	//*  Removes White Spaces from the left side of a  *
	//*  String                                        *
	//*                                                *
	//**************************************************
	public static function TrimLeft(pStringValue:String):String {
		
		return TrimString(pStringValue, true);		
	}

	//**************************************************
	//*                                                *
	//*  Removes White Spaces from the right side of a *
	//*  String                                        *
	//*                                                *
	//**************************************************
	public static function TrimRight(pStringValue:String):String {
		return TrimString(pStringValue, false);	
	}

	//**************************************************
	//*                                                *
	//*  Trims String, either from the left side or f  *
	//*  from the right side                           *
	//*                                                *
	//**************************************************
	private static function TrimString(pStringValue:String, pIsLeftTrim:Boolean):String {
		
		var iCounter:Number;		
		
		if (pStringValue == undefined) {
			return null;
		}
				
		if (pIsLeftTrim) {
			for (iCounter=0; iCounter < pStringValue.length; iCounter++) {
				
				var sTmp:String = pStringValue.charAt(iCounter);				
				if (sTmp != " ") {
					return pStringValue.substring(iCounter,pStringValue.length - iCounter + 2);
				}			
			}
		}	
		else {
			for (iCounter=pStringValue.length -1 ; iCounter > -1; iCounter--) {

				var sTmp:String = pStringValue.charAt(iCounter);
				if (sTmp != " ") {
					return pStringValue.substring(0,iCounter+1);
				}			
			}
		}
		return "";
	}
	
}