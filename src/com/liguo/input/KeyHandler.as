

/**
 * Classe qui sert � faire le lien entre le KeyManager et le KeyListener
 * Elle s'occupe de lancer les �v�nements
 * NB : l'instanciation se fait habituellement par le KeyManager
 */

import com.liguo.input.*;

class com.liguo.input.KeyHandler {
	
	public static var className:String = "KeyHandler";
	public static var classPackage:String = "com.liguo.input";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";

			
	private var _listener:KeyListener;
	private var _isActive:Boolean;
	private var _keys:Array;
	
	
	/**
	 *@contructor
	 *@param keys:Array Une combinaison de touche
	 *@param l:KeyListener Un �couteur
	 */
	public function KeyHandler(keys:Array, l:KeyListener){
		_keys = keys;
		_listener = l;	
		_isActive = false;
	}
	
	
	/**
	 *d�termine l'�tat des touches de la combinaison et lance les �v�nement si n�cessaire.
	 *NB: cette m�thode est habituellement invoqu� par le KeyManager	
	 */
	public function update() :Void {		
		
		var keys:Array = _keys;	
		var i:Number = 0;
		var j:Number = keys.length;		
		
		while(--j > -1)	{
			if(Key.isDown(keys[j]))	i++;	
		}						
		
		if(!_isActive && i == keys.length){
			_listener.onKeyDown();
			_isActive = true;
		}
		else 
		if(_isActive && i < keys.length){			
			_listener.onKeyUp();
			_isActive = false;			
		}
	}	
}
