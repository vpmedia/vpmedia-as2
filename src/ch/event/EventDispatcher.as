/*
Class	EventDispatcher
Package	ch.event
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

/**
 * Manage events.
 * <p>This class uses the AsBroadcaster to init the {@code addListener}, {@code removeListener}
 * and {@code broadcastMessage} methods.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.event.EventDispatcher
{
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new EventDispatcher.
	 */
	public function EventDispatcher(Void)
	{
		//init the broadcaster
		AsBroadcaster.initialize(this);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Add a listener.
	 * 
	 * @param	listener	The listener.
	 */
	public function addListener(listener:Object):Void {}
	
	/**
	 * Remove a listener.
	 * 
	 * @param	listener	The listener.
	 */
	public function removeListener(listener:Object):Void {}
	
	/**
	 * Broadcast a message.
	 * 
	 * @param	methodName	The method name to call.
	 * @param	event		The event object.
	 */
	public function broadcastMessage(methodName:String, event:Object):Void{}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the EventDispatcher instance.
	 */
	public function toString(Void):String
	{
		return "ch.event.EventDispatcher";
	}
}