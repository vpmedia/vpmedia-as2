import com.avila.events.Event;

/**
 * The IEventDispatcher interface defines methods for adding or removing event listeners, checks whether
 * specific types of event listeners are registered, and dispatches events.
 *
 * @langversion Actionscript 2.0
 * @playerversion Flash 8
 *
 * @author Michael Avila
 */
interface com.avila.events.IEventDispatcher
{
	/**
 	* Registers an event listener object with the dispatcher object so that when an event with
 	* the proper type is broadcast the listener can be notified.  The listener is passed the event
 	* that was dispatched as an argument.
 	*
 	* @param String the type of event which triggers notification for this listener.
 	* @param Object the object which contains the listener method to be invoked.
 	* @param Function the listener method to be invoked when the event is triggered.
 	*/
	public function addEventListener( type:String, scope:Object, listener:Function ):Void;
	
	/**
	 * Removes a listener from the dispatcher object.
	 *
	 * @param String the type property of the event to be removed.
	 * @param Object the object which contains the listener method of the event to be removed.
	 * @param Function the listener method of the event to be removed.
 	 */
	public function removeEventListener( type:String, scope:Object, listener:Function ):Void;
	
	/**
	 * Specifies whether or not the dispatcher object has any listeners registered for events of some type.
	 *
	 * @param String the type of event to check for.
	 */
	public function hasEventListener( type:String ):Boolean;
	
	/**
	 * Dispatches an event object.
     *
	 * @param Event the event object to dispatch.
	 */
	public function dispatchEvent( event:Event ):Void;
}