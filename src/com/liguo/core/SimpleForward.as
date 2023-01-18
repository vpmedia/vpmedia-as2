
/**
 *Implémentation de base de l'interface com.liguo.core.Forward 
 */ 

import com.liguo.core.*;

class com.liguo.core.SimpleForward implements Forward {
	
	public static var className:String = "SimpleForward";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
		
	private var _name:String;
	private var _action:String;
	private var _view:String;		
	
	
	/**
	 *@constructor
	 */
	public function SimpleForward (name:String, action:String, view:String) {
		_name = name;
		_action = action;
		_view = view;
	}
	
	
	/**
	 * assigne le nom du Forward. (success, error, etc...)
	 */
	public function setName (name:String) : Void {
		_name = name;
	}
	
	
	/**
	 * récupère le nom du Forward
	 */
	public function getName () : String {
		return _name;
	}
	
	
	/**
	 * Assigne le mapping de l'Action que le Forward utilisera
	 */
	public function setActionMapping (mapping:String) : Void{
		_action = mapping
	}
	
	
	/**
	 * Récupère le mapping de l'Action que le Forward utilise
	 */
	public function getActionMapping() : String {
		return _action;
	}
	
	
	/**
	 * Assigne le mapping de la View que le Forward utilisera
	 */
	public function setViewMapping (mapping:String) : Void{
		_view = mapping;
	}
	
	
	/**
	 * Récupère le mapping de la View que le Forward utilise
	 */
	public function getViewMapping () : String {
		return _view;
	}
	
	
	/**
	 * Procède à l'exécution du Forward 
	 */
	public function doFoward (response:Response) : Void {
		Config.getController().getView(_view).render(response);
	}
}

