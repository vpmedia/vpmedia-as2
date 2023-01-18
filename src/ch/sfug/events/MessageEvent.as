import ch.sfug.events.Event;

/**
* Generic event that can be used to dispatch a simple message
* 
* @author Stefan Thurnherr
*/
class ch.sfug.events.MessageEvent extends Event {
	
	public static var MESSAGE:String = "message";
	private var msg:String;
	
	/**
	* Constructor.
	* @param message the message for this event
	*/
	public function MessageEvent( type:String, message:String ){
		super(type);
		this.msg = message;
	}
	
	/**
	* returns the message of the event
	*/
	public function get message():String {
		return this.msg;
	}
	
	/**
	* overwrite default <code>toString()</code>.
	*/
	public function toString():String {
		return "MessageEvent: " + this.msg;
	}
	
}