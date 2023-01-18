/*
Class	ScrollBarListener
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollEvent;

/**
 * Listener of a {@code ScrollBarModel}.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.0
 * @see			ch.component.scrollbar.ScrollBarModel
 */
interface ch.component.scrollbar.ScrollListener
{
	/**
	 * Method called when a scroll is performed on a
	 * {@code ScrollBarModel}.
	 * 
	 * @param	event	The event object.
	 */
	public function scrollPerformed(event:ScrollEvent):Void;
}