
/**
 * Implémentation basique de l'interface KeyListener
 * Les événements onKeyDown et onKeyUp seront invoqué directement sur la cible envoyé au constructeur 
 */
import com.liguo.input.*;

class com.liguo.input.SimpleKeyListener implements KeyListener {
	
	public static var className:String = "SimpleKeyListener";
	public static var classPackage:String = "com.liguo.input";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _target;		
	
	public function SimpleKeyListener(target){		
		_target = target;
	}
	
	public function onKeyDown():Void{
		_target.onKeyDown();
	}
	
	public function onKeyUp():Void{
		_target.onKeyUp();
	}	
}
