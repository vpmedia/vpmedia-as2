import ch.sfug.events.MessageEvent;

/**
 * @author loop
 */
class ch.sfug.events.HTTPStatusEvent extends MessageEvent {

	private var _code:Number;

	public static var HTTPSTATUS:String = "httpstatus";

	public function HTTPStatusEvent( type:String, code:Number ) {
		super(type);
		this._code = code;
	}

	/**
	 * returns the httpstatus number
	 */
	public function get code(  ):Number {
		return _code;
	}

	/**
	 * overwrites the message property to return the message of the corresponding code
	 */
	public function get message(  ):String {
		if( _code < 100 ) return "flashError";
		if( _code < 200 ) return "informational";
		if( _code < 300 ) return "successful";
		if( _code < 400 ) return "redirection";
		if( _code < 500 ) return "clientError";
		if( _code < 600 ) return "serverError";
		return "no description for this http status";
	}

	/**
	 * overwrite default toString
	 */
	public function toString(  ):String {
		return "HTTPStatusEvent: " + message;
	}

}