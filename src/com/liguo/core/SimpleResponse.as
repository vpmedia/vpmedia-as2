

/**
 * implémentation de base de l'interface com.liguo.core.Response
 */
 
import com.liguo.core.*;

class com.liguo.core.SimpleResponse extends SimpleContext implements Response {
	
	public static var className:String = "SimpleResponse";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _forward:String;
	private var _action:String;
		
	/**
	 *@constructor
	 */
	public function SimpleResponse(action:String, forward:String){
		super();		
		_action = action;
		_forward = forward;		
	}
	
	
	/**
	 *Rècupère la session du controlleur
	 *@return Retourne une référence à la session du controlleur
	 */
	public function getSession () : Session {
		return Config.getSession();
	}
	
	
	/**
	 *Retourne le forward
	 */
	public function getForward () : String {
		return _forward;
	}	
	
	
	/**
	 *Assigne le forward
	 */
	public function setForward (f:String) : Void {
		_forward = f;
	}
	
	
	/**
	 *retourne le mapping de l'action qui a été exécuté
	 */
	public function getAction () : String {
		return _action;
	}
}
