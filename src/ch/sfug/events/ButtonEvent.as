import ch.sfug.controls.EventButton;
import ch.sfug.events.Event;

/**
 * @author loop
 */
class ch.sfug.events.ButtonEvent extends Event {

	public static var PRESS:String = "press";
	public static var RELEASE:String = "release";
	public static var RELEASEOUTSIDE:String = "releaseoutside";
	public static var ROLLOUT:String = "rollout";
	public static var ROLLOVER:String = "rollover";
	public static var DRAGOUT:String = "dragout";
	public static var DRAGOVER:String = "dragover";

	public function ButtonEvent( type:String ) {
		super(type);
	}

	/**
	 * returns the event target. the object that dispatches the event
	 */
	public function get target(  ):EventButton {
		return EventButton( super.target );
	}
	

}