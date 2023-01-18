import com.FlashDynamix.events.EventArgs
//
class com.FlashDynamix.events.Event {
	//
	public static var CLICK:String = "click";
	public static var KEYDOWN:String = "keyDown";
	public static var MOVE:String = "move";
	public static var DRAG:String = "drag";
	public static var PROGRESS:String = "progress";
	public static var ERROR:String = "error";
	public static var ZOOM:String = "zoom";
	public static var CHANGE:String = "change";
	public static var LOADED:String = "loaded";
	public static var LOADCOMPLETE:String = "loadComplete";
	public static var RESIZE:String = "resize";
	public static var ABORT:String = "abort";
	public static var FOCUS:String = "focus";
	public static var UNFOCUS:String = "unfocus";
	public static var MOUSE:String = "mouse";
	//
	private var _name:String;
	private var _args:EventArgs;
	//
	public function Event(n:String, a:EventArgs){
		_name = n;
		_args = a;
	}
	public function get name():String{
		return _name
	}
	public function get value():EventArgs{
		return _args
	}
}