

/**
 * Implémentation de l'interface KeyListener
 * Les événements onKeyDown et onKeyUp seront délégé au objet envoyé au constructeur 
 */

import mx.utils.*;
import com.liguo.input.*;

class com.liguo.input.DelegatedKeyListener implements KeyListener {
	
	public static var className:String = "DelegatedKeyListener";
	public static var classPackage:String = "com.liguo.input";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _keyUp:Function;
	private var _keyDown:Function;
	
	/**
	 *@contructor
	 */
	public function DelegatedKeyListener(oDown, fDown:Function, oUp, fUp:Function){
		
		if(oDown != undefined && fDown != undefined){
			_keyDown = Delegate.create(oDown, fDown);
		}
		
		if(oUp != undefined && fUp != undefined){
			_keyUp = Delegate.create(oUp, fUp);
		}			
	}
	
	public function onKeyDown():Void{
		if(_keyDown != undefined) _keyDown();
	}
	
	public function onKeyUp():Void{
		if(_keyUp != undefined) _keyUp();
	}	
}

