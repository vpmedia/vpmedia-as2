

/**
 *Classe permettant d'instancier des classes � partir de leur nom. 
 */ 
class com.liguo.core.Class {
	
	
	public static var className:String = "Class";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	/**
	 *r�f�rence au constructeur
	 */
	public var clazz:Function;
	
	
	/**
	 *constructeur
	 */ 
	public function Class (clazz:Function) {
		this.clazz = clazz;
	}
			
	
	/**
	 *Instancie la classe en question en envoyant des param�tres au constructeur
	 *<b>usage :</b> clazz.newInstance([1, 2, 3, "toto"]);
	 *@param args Un Array contenant les param�tres (facultatif)
	 *@return un Instance de la classe 
	 */ 
	public function newInstance (args:Array) : Object {
		var obj:Object = {__constructor__:clazz, __proto__:clazz.prototype};
                clazz.apply(obj,args);
                return obj;
	}
	
	
	/**
	 *R�cup�re une classe d'apr�s son nom
	 *@param name Le nom complet de la classe (avec les package)
	 *@return Un objet de type com.liguo.core.Class 
	 */  
	public static function forName (name:String) : Class {
		return new Class(evalClassName(name));
	}
		
	
	/**
	 *Instancie une classe d'apr�s son nom
	 *@param name Le nom complet de la classe (avec les package)
	 *@return Un instance de la classe 
	 */
	public static function newForName (name:String) {		
		return new (evalClassName(name))();
	}	
	
	
	/**
	 *R�cup�re la classe d'une instance
	 *NB: ne fonctionne pas avec les types natifs
	 *@param instance Une instance
	 *@return Un objet de type com.liguo.core.Class 
	 */
	public static function forInstance (instance) : Class {
		return new Class(instance.__constructor__);
	}
	
	
	/**
	 *�value le nom d'une classe pour r�cup�rer son constructeur
	 *@param name Le nom complet de la classe (avec les package) 
	 *@return le constructeur de la classe
	 */ 	 
	 public static function evalClassName (name:String) : Function {
		return eval("_global." + name);
	 }
}
