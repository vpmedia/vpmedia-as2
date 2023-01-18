/**
 * @author Barni
 */
interface gugga.common.IEventDispatcher
{
	
	public function dispatchEventLater(eventObj:Object):Void;
	
	/**
	* dispatch the event to all listeners
	* @param eventObj an Event or one of its subclasses describing the event
	*/
	function dispatchEvent(eventObj:Object):Void;

	/**
	* add a listener for a particular event
	* @param event the name of the event ("click", "change", etc)
	* @param the function or object that should be called
	*/
	function addEventListener(event:String, handler):Void;

	/**
	* remove a listener for a particular event
	* @param event the name of the event ("click", "change", etc)
	* @param the function or object that should be called
	*/
	function removeEventListener(event:String, handler):Void;
}