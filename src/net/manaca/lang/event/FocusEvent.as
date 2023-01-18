import net.manaca.lang.event.Event;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-16
 */
class net.manaca.lang.event.FocusEvent extends Event {
	private var className : String = "net.manaca.lang.event.FocusEvent";
	static public var FOCUS_IN:String = "focusIn";
	static public var FOCUS_OUT:String = "focusOut";
	static public var KEY_FOCUS_CHANGE:String = "keyFocusChange";
	static public var MOUSE_FOCUS_CHANGE:String = "mouseFocusChange";
	
	public function FocusEvent(type : String, value, target : Object) {
		super(type, value, target);
	}

}