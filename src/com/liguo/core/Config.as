

import com.liguo.core.*;

/**
 *Classe repr�sentant le point central de l'application
 *Elle sert de point d'acc�s global au controlleur. 
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
	 *Assigne le controlleur pour la pr�sente application
	 *@param name Le nom complet de la classe repr�sentant le controlleur 
	 */ 
	public static function setController (c:Controller) : Void {	
		_con = c;		
	}


	/**
	 *Retourne une r�f�rence au controlleur actuelle
	 *@return le controlleur
	 */ 
	public static function getController() : Controller {
		return _con;
	}
	
	
	/**
	 *Invoque la m�thode execute() sur le controlleur actuel
	 *@param action L'url de l'action
	 *@param param Un objet contenant des param�tres (optionel)
	 */ 
	public static function exec (action:String, param) : Void {
		_con.execute(action,param);
	}
	
	
	/**
	 *Invoque la m�thode notify() sur le controlleur actuel
	 *@param res la response qui doit �tre envoy� � la view	
	 */
	public static function notify (res:Response) : Void {
		_con.notify(res);
	}
		
		
	/**
	 *Invoque la m�thode getSession() sur le controlleur actuel
	 *@return Une session
	 */
	public static function getSession () : Session {
		return _con.getSession();
	}
	
	
	/**
	 *Assigne une propri�t� de l'application
	 *@param name:String Nom de la propri�t�
	 *@param value:String Valeur de la propri�t�
	 */
	public static function setProp (name:String, value:String) : Void {
		_props[name] = value;
	}  
	
	
	/**
	 *R�cup�re  une propri�t� de l'application. Utile pour stocker des infos globales
	 * qui ne doivent pas �tre conserv� dans la session.
	 *
	 *@param name:String om de la propri�t�
	 *@return La valeur de la propri�t�
	 */
	public static function getProp (name:String) : String {
		return _props[name];
	}
}
