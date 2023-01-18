

/**
 * implémentation de base de l'interface com.liguo.core.Session
 */

import com.liguo.core.*;

class com.liguo.core.SimpleSession extends SimpleContext implements Session {
	
	public static var className:String = "SimpleSession";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
		
	/**
	 *@constructor
	 */
	public function SimpleSession () {
		super();			
	}
	
	/**
	 * rétabli la session comme elle était lors de sa dernière utilisation
	 */
	public function restore () : Void {		
		setAttributes(SharedObject.getLocal("session").data.attributes);
	}
	
	
	/**
	 * sauvegarde la session afin de la réutiliser ultérieurement
	 */
	public function save () : Void {
		var so:SharedObject = SharedObject.getLocal("session");
		so.data.attributes = _atts;
		so.flush();
		so.close();
	}
}
