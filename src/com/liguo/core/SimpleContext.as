

/**
 * implémentation de base de l'interface com.liguo.core.Context
 */
import com.liguo.core.*;

class com.liguo.core.SimpleContext implements Context {
			
	public static var className:String = "SimpleContext";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	private var _atts:Object;
	
	/**
	 *@constructor
	 */
	public function SimpleContext () {
		_atts = new Object();
	}
	
	/**
	 *Ajoute un attribut dans ce context
	 *@param key La clé de l'attribut
	 *@param La valeur de l'attribut
	 */
	public function setAttribute (key:String, value) : Void {
		_atts[key] = value;
	}
	
	
	/**
	 *Ajoute plusieur attributs dans ce context.
	 *@param obj Un object contenant les attributs
	 */
	public function setAttributes (obj) : Void {
		for(var i in obj){			
			_atts[i] = obj[i];
		}
	}
	
	
	/**
	 *Récupère un attribut qui est dans ce context.
	 *@param key La clé de l'attribut
	 *@return La valeur de l'attribut (null si l'attribut est absent)
	 */
	public function getAttribute (key:String) {
		return _atts[key];
	}
	
	
	/**	 
	 *@return un objet contenant tout les attibuts	
	 */
	public function getAttributes () : Object {
		return _atts;
	}
	
	/**
	 *Supprime un attribut qui est dans ce context.
	 *@param key La clé de l'attribut	 
	 */
	public function remove (key:String) : Void {
		delete _atts[key];
	}
	
	
	/**
	 *Supprime tous les attributs du context.	
	 */
	public function removeAll () : Void {
		for(var i in _atts){
			delete _atts[i];
		}
	}
	
	
	/**
	 *Récupère la liste de clé des attributs du context 
	 *@return Un Array contenant le nom des clés
	 */
	public function getAttributesNames () : Array {
		var names:Array = new Array();
		for(var i in _atts){
			names.push(i);
		}		
		return names;
	}
}
