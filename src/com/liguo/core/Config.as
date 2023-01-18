

import com.liguo.core.*;

/**
 *Classe représentant le point central de l'application
 *Elle sert de point d'accès global au controlleur. 
 */ 
class com.liguo.core.Config {
	
	public static var className:String = "Config";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
				
	private static var _con:Controller ;
	private static var _props:Object = {};
	
	
	/**
	 *Assigne le controlleur pour la présente application
	 *@param name Le nom complet de la classe représentant le controlleur 
	 */ 
	public static function setController (c:Controller) : Void {	
		_con = c;		
	}


	/**
	 *Retourne une référence au controlleur actuelle
	 *@return le controlleur
	 */ 
	public static function getController() : Controller {
		return _con;
	}
	
	
	/**
	 *Invoque la méthode execute() sur le controlleur actuel
	 *@param action L'url de l'action
	 *@param param Un objet contenant des paramètres (optionel)
	 */ 
	public static function exec (action:String, param) : Void {
		_con.execute(action,param);
	}
	
	
	/**
	 *Invoque la méthode notify() sur le controlleur actuel
	 *@param res la response qui doit être envoyé à la view	
	 */
	public static function notify (res:Response) : Void {
		_con.notify(res);
	}
		
		
	/**
	 *Invoque la méthode getSession() sur le controlleur actuel
	 *@return Une session
	 */
	public static function getSession () : Session {
		return _con.getSession();
	}
	
	
	/**
	 *Assigne une propriété de l'application
	 *@param name:String Nom de la propriété
	 *@param value:String Valeur de la propriété
	 */
	public static function setProp (name:String, value:String) : Void {
		_props[name] = value;
	}  
	
	
	/**
	 *Récupère  une propriété de l'application. Utile pour stocker des infos globales
	 * qui ne doivent pas être conservé dans la session.
	 *
	 *@param name:String om de la propriété
	 *@return La valeur de la propriété
	 */
	public static function getProp (name:String) : String {
		return _props[name];
	}
}
