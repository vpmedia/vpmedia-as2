/*
Class	ScrollEvent
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.event.AbstractEvent;
import ch.component.scrollbar.ScrollBarModel;

/**
 * Event of a scroll.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.6
 */
class ch.component.scrollbar.ScrollEvent extends AbstractEvent
{
	//---------//
	//Variables//
	//---------//
	private var _scrolled:Number;
	private var _ratio:Number;
	private var _position:Number;
	private var _scroller:Object;
	private var _isRefresh:Boolean;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollEvent.
	 * 
	 * @param	source			The event source.
	 * @param	scroller		The object changing the scroll.
	 * @param	scrolled		The number of pixel scrolled.
	 * @param	ratio			The current ratio after the scroll.
	 * @param	position		The current position after the scroll.
	 * @param	isRefresh		Indicates if the event is only for the refresh.
	 */
	public function ScrollEvent(source:ScrollBarModel, scroller:Object, scrolled:Number, ratio:Number, position:Number, isRefresh:Boolean)
	{
		super(source);
		
		_scrolled = scrolled;
		_ratio = ratio;
		_position = position;
		_scroller = scroller;
		_isRefresh = isRefresh;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get if the current <code>ScrollEvent</code> is generated
	 * only for a <code>refresh</code> action.
	 * 
	 * @return	<code>true</code> if this is a <code>refresh</code> event.
	 */
	public function isRefresh(Void):Boolean
	{
		return _isRefresh;
	}
	
	/**
	 * Get the object that is scrolling the current source.
	 * <p>This value let you retrieve which object has been
	 * used to perform the scroll.<p>
	 * 
	 * @return	The scroller.
	 */
	public function getScroller(Void):Object
	{
		return _scroller;
	}
	
	/**
	 * Get the scrolled pixels.
	 * 
	 * @return	The scrolled pixels.
	 */
	public function getScrollValue(Void):Number
	{
		return _scrolled;
	}
	
	/**
	 * Get the current ratio of the content.
	 * 
	 * @return	The ratio.
	 */
	public function getRatio(Void):Number
	{
		return _ratio;
	}
	
	/**
	 * Get the current position of the content.
	 * 
	 * @return	The position.
	 */
	public function getPosition(Void):Number
	{
		return _position;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollEvent instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollEvent";
	}
}