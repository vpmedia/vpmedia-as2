/**
 * The Event class is used as the base class for Event objects, which are passed as the parameter
 * to event listeners when an event occurs.
 *
 * @langversion Actionscript 2.0
 * @playerversion Flash 8
 * 
 * @author Michael Avila
 */
class com.avila.events.Event
{
	public static var COMPLETE:String = 'complete';
	
	private var _type:String;
	/**
	 * The type of the event that was dispatched.
	 */
	public function get type():String { return _type; };
	
	/**
	 * Creates a new Event object.
	 *
	 * @param String the type of event that occurred.
     */
	public function Event( type:String )
	{
		_type = type;
	}
	
	/**
	 * Returns an exact copy of this event.
	 */
	public function clone():Event
	{
		return new Event( type );
	}

	/**
	 * Returns a string in the form of [Event type=eventType] where eventType is 
	 * the value specified by the Event object's type property.
	 */ 
	public function toString():String
	{
		return "[Event type=" + type + "]";
	}
}