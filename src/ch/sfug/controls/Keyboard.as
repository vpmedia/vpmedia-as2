import ch.sfug.events.EventDispatcher;
import ch.sfug.events.KeyboardEvent;

/**
 * @author loop
 */
class ch.sfug.controls.Keyboard extends EventDispatcher {

	private static var instance:Keyboard;
	// holdes all the keys that are down
	private var down:Object;

	public function Keyboard() {
		super();
		this.down = new Object();
		Key.addListener( this );
	}

	/**
	 * catch the key event
	 */
	private function onKeyDown(  ):Void {
		var code:Number = Key.getCode();
		if( down[ code ] == undefined ) {
			down[ code ] = true;
			dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, Key.getCode(), Key.getAscii(), Key.isDown( Key.SHIFT ), Key.isDown( Key.CONTROL ) ) );
		}
	}
	private function onKeyUp(  ):Void {
		var code:Number = Key.getCode();
		if( down[ code ] ) {
			down[ code ] = undefined;
			dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, Key.getCode(), Key.getAscii(), Key.isDown( Key.SHIFT ), Key.isDown( Key.CONTROL ) ) );
		}
	}

	/**
	 * returns the Keyboard instance
	 */
	private static function getInstance(  ):Keyboard {
		if( instance == undefined ) instance = new Keyboard();
		return instance;
	}

	/**
	 * adds an eventlistener to the keyboard.
	 */
	public static function addEventListener( type:String, func:Function, obj:Object ):Void {
		getInstance().addEventListener( type, func, obj );
	}

	/**
	 * removes an event listener from the keyboard
	 */
	public static function removeEventListener( type:String, func:Function, obj:Object ):Void {
		getInstance().removeEventListener( type, func, obj );
	}

	/**
	 * returns true if the keyboard has a listener on the given type
	 */
	public static function hasEventListener( type:String ):Boolean {
		return getInstance().hasEventListener( type );
	}
}