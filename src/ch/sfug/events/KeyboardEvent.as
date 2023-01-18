import ch.sfug.events.Event;

/**
 * @author loop
 */
class ch.sfug.events.KeyboardEvent extends Event {

	public static var KEY_DOWN:String = "keyDown";
	public static var KEY_UP:String = "keyUp";

	public var charCode:Number;
	public var keyCode:Number;
	public var ctrlKey:Boolean;
	public var shiftKey:Boolean;


	public function KeyboardEvent( type:String, keyCode:Number, charCode:Number, shiftKey:Boolean, ctrlKey:Boolean ) {
		super(type);
		this.keyCode = keyCode;
		this.charCode = charCode;
		this.shiftKey = shiftKey;
		this.ctrlKey = ctrlKey;
	}

	public function toString() : String {
		return "KeyboardEvent ( " + type + " ): key: " + keyCode + ", char: " + charCode + ", ctrlDown: " + ctrlKey + ", shiftDown: " + shiftKey;
	}

}