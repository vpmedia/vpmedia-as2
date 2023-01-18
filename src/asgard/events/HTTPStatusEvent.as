import vegas.events.DynamicEvent;

/**
 * The HTTPStatusEvent are dispatched when a network request returns an HTTP status code. 
 * There is only one type of HTTPStatus event : {@code HTTPStatusEvent.HTTP_STATUS}.
 * @author eKameleon
 */
class asgard.events.HTTPStatusEvent extends DynamicEvent 
{
	
	/**
	 * Creates an Event object that contains specific information about HTTP status events.
	 * @param type the string type of the instance.
	 * @param status Numeric status. Event listeners can access this information through the status property (default 0).
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function HTTPStatusEvent(type : String, status:Number, target, context, bubbles : Boolean, eventPhase : Number, time : Number, stop : Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop);
		_status = isNaN(status) ? 0 : status ;
	}
	
	/**
	 * Defines the value of the type property of a httpStatus event object.
	 */
	static public var HTTP_STATUS:String = "httpStatus" ;
	
	/**
	 * (read only) The HTTP status code returned by the server. 
	 * For example, a value of 404 indicates that the server has not found a match for the requested URI. 
	 * HTTP status codes can be found in sections 10.4 and 10.5 of the HTTP specification at ftp://ftp.isi.edu/in-notes/rfc2616.txt.
	 */
	public function get status():Number
	{
		return _status ;	
	}
	
	/**
	 * The internal HTTP status code.
	 */
	private var _status:Number ;

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new HTTPStatusEvent(getType(), _status, getTarget(), getContext()) ;
	}

}