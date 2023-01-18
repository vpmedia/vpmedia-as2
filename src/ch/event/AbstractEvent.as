/*
Class	AbstractEvent
Package	ch.event
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	13 févr. 2006
*/

/**
 * Represents an event.
 * <p>This class is designed to be inherited by the specified event classes.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		13 févr. 2006
 * @version		1.0
 */
class ch.event.AbstractEvent
{
	//---------//
	//Variables//
	//---------//
	private var _source:Object;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new AbstractEvent.
	 * 
	 * @param	source	The source object or {@code null}.
	 */
	public function AbstractEvent(source:Object)
	{
		_source = source;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the source object of the event.
	 * 
	 * @return	The source object.
	 */
	public function getSource(Void):Object
	{
		return _source;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the AbstractEvent instance.
	 */
	public function toString(Void):String
	{
		return "ch.event.AbstractEvent";
	}
}