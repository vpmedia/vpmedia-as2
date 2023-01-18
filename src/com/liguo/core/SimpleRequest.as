

/**
 * impl�mentation de base de l'interface com.liguo.core.Request
 */

import com.liguo.core.*;

class com.liguo.core.SimpleRequest extends SimpleContext implements Request {
	
	public static var className:String = "SimpleRequest";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _action:String;
	
	/**
	 *@constructor
	 */
	public function SimpleRequest (url:String, params:Object) {
		super();
		_decodeURL(url);
		setAttributes(params);			
	}
	
	/**
	 *R�cup�re la session du controlleur
	 *@return Retourne une r�f�rence � la session du controlleur
	 */
	public function getSession () : Session {
		return Config.getSession();
	}
	
	
	/**
	 *Retourne le mapping de l'action que le controlleur doit ex�cuter
	 *@return le mapping de l'action
	 */
	public function getAction () : String {
		return _action;
	}
	
	
	/**
	 *Retourne la r�ponse qui doit par la suite �tre notifi� au controlleur	 
	 *@param forward Le mapping du Forward qui sera utilis� pour renvoyer le data � la bonne View
	 *@return la Response
	 */
	public function getResponse (forward:String) : Response {
		return new SimpleResponse(_action, forward);
	}
	
	private function _decodeURL (url:String) : Void {
		var index:Number = url.indexOf("?");		
		
		if(index > -1){			
			
			_action = url.substring (0,index);
			
			var param:String = url.substring(index+1);			
			var params:Array = param.split("&");
			
			for(var i in params){
				var tempAtt:Array = params[i].split("=");
				
				if(tempAtt.length == 2){
					setAttribute(tempAtt[0],tempAtt[1]);	
				}else{
					throw new InvalidURLException(url);
				}					
			}			
		}else{			
			_action = url;
		}
	}
}
