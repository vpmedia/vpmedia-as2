import ch.sfug.events.EventDispatcher;
/**
 * @author mich
 */
class ch.sfug.events.Event {

	private var _target:EventDispatcher;
	private var _type:String;

	public static var COMPLETE:String = "complete";
	public static var CANCEL:String = "cancel";
	public static var CLOSE:String = "close";
	public static var CONNECT:String = "connect";
	public static var INIT:String = "init";
	public static var OPEN:String = "open";
	public static var RESIZE:String = "resize";
	public static var CHANGE:String = "change";
	public static var SOUND_COMPLETE:String = "sound_complete";
	public static var ID3:String = "sound_id3";

	public function Event( type:String ) {
		this._type = type;
	}

	/**
	 * sets the target of the event. for where the event comes
	 */
	public function set target( t:EventDispatcher ):Void {
		this._target = t;
	}

	/**
	 * will return the type of the event. for example Event.COMPLETE etc
	 */
	public function get type( ):String {
		return this._type;
	}

	/**
	 * returns the event target. the object that dispatches the event
	 */
	public function get target(  ):EventDispatcher {
		return this._target;
	}

	public function toString() : String {
		return "Event: " + _type;
	}

}