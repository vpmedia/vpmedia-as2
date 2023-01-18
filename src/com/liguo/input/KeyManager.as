

/**
 * Classe pour la gestion des touches du clavier.
 * Elle permet d'avoir les événement onKeyDown et onKeyUp pour une combinaison de touches. 
 */
 
import com.liguo.input.*;

class com.liguo.input.KeyManager {
	
	public static var className:String = "KeyManager";
	public static var classPackage:String = "com.liguo.input";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _handlers:Array; 	
	private var _intervalID:Number;
			
	/**
	 *@contructor
	 */
	private function KeyManager(){		
		_handlers = [];		
		resume(50);
	}

  	
	/**
	 *Ajoute un écouteur
	 *@param keys:Array Une combinaison de touches
	 *@param listener Un objet qui implémente l'interface KeyListener
	 *@return Une référence au KeyHandler (seulement utile si on prévoit supprimer l'écouteur)
	 */
	public function addKeyListener(keys:Array, listener:KeyListener):KeyHandler{		
		var h:KeyHandler = new KeyHandler(keys,listener)
		_handlers.push(h);		
		return h;
	}
	
	
	/**
	 *Supprime un écouteur
	 *@param handler Le KeyHandler qui a été retourné par la méthode addKeyListener()	 
	 */
	public function removeKeyListener(handler:KeyHandler):Void {
		var handlers:Array = _handlers;
		var i:Number = handlers.length;	
		while(--i > -1) {
			if(handlers[i] === handler){
				handlers.splice(i, 1);
				break;
			}
		}
	}
		
		
	/**
	 *démarre la manager
	 *@param speed:Number la vitesse de l'interval
	 */
	public function resume(speed:Number):Void{
		_intervalID = setInterval(this, "_trigger", speed);
	}		
		
		
	/**
     *stop le manager
     */
	public function pause():Void{
		clearInterval(_intervalID);
	}
		
					
	/**
	 * méthode qui est invoqué par l'interval
	 */
	private function _trigger():Void{			
		var handlers:Array = _handlers;
		var i:Number = handlers.length;	
		while(--i > -1) handlers[i].update();
	}	
	
	
	/**
	 * Singleton
	 */
	private static var _o:KeyManager; 
	public static function getInstance():KeyManager{
		return _o ? _o : (_o = new KeyManager());
	}		
}
