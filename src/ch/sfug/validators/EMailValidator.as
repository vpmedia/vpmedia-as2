/**
 * @author Marcel
 */

class ch.sfug.validators.EMailValidator
{
	private function EMailValidator() {};

	public static function isValidEmail(e:String):Boolean {
		var isEmailCheckOk:Boolean = false;
		var isEmailLengthOk:Boolean = true;
		
		var arrEmail:Array = e.split("@");
		
		if(arrEmail.length == 2){
			if(arrEmail[0].length >= 1){
				var arrEmailR:Array = arrEmail[1].split(".");
				if(arrEmailR.length >= 2){
					for(var i:Number=0;i<arrEmailR.length;i++){
						if(arrEmailR[i].length < 1){
							isEmailLengthOk = false;
						}
					}
					if(isEmailLengthOk){
						if(arrEmailR[arrEmailR.length-2].length >= 2 && (arrEmailR[arrEmailR.length-1].length >= 2 && arrEmailR[arrEmailR.length-1].length <= 4)){
							isEmailCheckOk = true;
						}
					}
				}
			}
		}
		
		//return boolean
		return isEmailCheckOk;
	}
	
	public static function isNotEmpty(e:String):Boolean {
		if ( e != '' ) 	{
			return true;
		}
		else{
			return false;
		}
	}

	 	
}