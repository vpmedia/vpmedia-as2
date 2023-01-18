/*
Class	ScrollBarModel
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 févr. 2006
*/

//import
import ch.component.scrollbar.ScrollType;
import ch.component.scrollbar.ScrollManager;
import ch.component.scrollbar.ScrollListener;
import ch.component.scrollbar.ScrollEvent;
import ch.event.EventDispatcher;

/**
 * Manager of content that can be scrolled.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 févr. 2006
 * @version		1.8
 */
class ch.component.scrollbar.ScrollBarModel extends EventDispatcher
{
	//---------//
	//Constants//
	//---------//
	
	//---------//
	//Variables//
	//---------//
	private var _oldStateScrollable:Boolean;
	private var _content:ScrollManager;
	
	/**
	 * Called when a scroll is performed.
	 * <p>Prototype : <br><code>
	 * scb.onScroll = function(eventSource:Object, scrolled:Number, ratio:Number, position:Number, refreshOnly:Boolean):Void { }
	 * </code></p>
	 */
	public var onScroll:Function;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollBarModel.
	 * <p>The {@code ScrollManager} is the manager that will be used
	 * for the scroll calculation and the position adjustment. So the
	 * {@code target} of the {@code ScrollManager} should be the content and the
	 * {@code delimiter} should be the mask.</p>
	 * 
	 * @param	scrollManager	The {@code ScrollManager} to use.
	 * @throws	Error			If {@code scrollManager} is {@code null}.
	 */
	public function ScrollBarModel(scrollManager:ScrollManager)
	{
		_content = null;
		onScroll = null;
		
		setScrollManager(scrollManager);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Add a listener.
	 * 
	 * @param	listener	The listener to add.
	 */
	public function addListener(listener:ScrollListener):Void
	{
		super.addListener(listener);
	}
	
	/**
	 * Remove a listener.
	 * 
	 * @param	listener	The listener to remove.
	 */
	public function removeListener(listener:ScrollListener):Void
	{
		super.removeListener(listener);
	}
	
	/**
	 * Get the {@code ScrollManager} of the model.
	 * <p>Note that if you call directly a method from the {@code ScrollManager},
	 * the events won't be dispatched. It may cause problems on the listeners of
	 * the {@code ScrollBarModel}.</p>
	 * 
	 * @return	The {@code ScrollManager}
	 */
	public function getScrollManager(Void):ScrollManager
	{
		return _content;
	}
	
	/**
	 * Set the {@code ScrollManager} of the {@code ScrollBarModel}.
	 * <p>If the {@code fireEvent} is {@code true}, an event {@code scrollPerformed} will
	 * be dispatched to the listeners, so they can update them to the current state of
	 * the new {@code ScrollManager}. The scroll value will be 0.</p>
	 * 
	 * @param	scrollManager		The new {@code ScrollManager}.
	 * @param	fireEvent			{@code true} to dispatch the event.
	 * @throws	Error				If {@code scrollManager} is {@code null}.
	 */
	public function setScrollManager(scrollManager:ScrollManager, fireEvent:Boolean):Void
	{
		if (scrollManager == null)throw new Error(this+".setScrollManager : scrollManager is not defined");
		
		_content = scrollManager;
		
		//event to the listener
		if (fireEvent) fireScrollPerformed(0, null, false);
	}
	
	/**
	 * Set the margins of the {@code ScrollManager}.
	 * <p>This method set {@code margin1} and {@code margin2} into the
	 * {@code ScrollManager} and call the {@code adjust} method with a
	 * ratio of 0 to reset the {@code ScrollBar}.</p>
	 * <p>If you want to manually set the margins and readjust the {@code ScrollBar},
	 * simply get the {@code ScrollManager}, set {@code margin1} and {@code margin2}, and
	 * finally call the {@code adjust} method within your own ratio.</p>
	 * 
	 * @param	topLeft		The top/left margin (depend of the {@code ScrollBarModel} type).
	 * @param	bottomRight	The bottom/right margin (depend of the {@code ScrollBarModel} type).
	 * @see		ch.component.scrollbar.ScrollManager#margin1
	 * @see		ch.component.scrollbar.ScrollManager#margin2
	 */
	public function setMargins(topLeft:Number, bottomRight:Number):Void
	{
		var m:ScrollManager = _content;
		
		m.margin1 = topLeft;
		m.margin2 = bottomRight;
		
		adjust(0);
	}
	
	/**
	 * Get the content clip.
	 * 
	 * @return	The content.
	 */
	public function getContent(Void):MovieClip
	{
		return _content.getTarget();
	}
	
	/**
	 * Get the mask of the content.
	 * 
	 * @return	The mask.
	 */
	public function getMask(Void):MovieClip
	{
		return _content.getDelimiter();
	}
	
	/**
	 * Get the scroll type.
	 * 
	 * @return	The {@code ScrollType} used.
	 */
	public function getType(Void):ScrollType
	{
		return _content.getType();
	}
	
	/**
	 * Scroll the target clip relatively with the specified value.
	 * <p>This method checks automatically the value to scroll. If the value
	 * is too big (or small), the it is automatically adjusted to scroll the exact
	 * value to reach the maximum (or minimum point). If this method returns 0, then
	 * no more scroll is available in the same direction.</p>
	 * <p>The direction of the scroll is determinated by the sign of {@code value}. If
	 * {@code value} is less thant 0, then the content clip will be scrolled down. It means
	 * that it has the same effect as if you click the up arrow on a classical scroll bar.</p>
	 * 
	 * @param	value	The value to scroll.
	 * @param	source	The object that is changing the scroll or {@code null}.
	 * @return	The number of pixels scrolled.
	 * @see		ch.component.scrollbar.ScrollManager#scroll(Number)
	 */
	public function scroll(value:Number, source:Object):Number
	{
		var scrolled:Number = _content.scroll(value);
		
		//event
		fireScrollPerformed(scrolled, source, false);
		
		return scrolled;
	}
	
	/**
	 * Adjust the scroll within the specified ratio.
	 * <p>This method ajust the content to the mask at the specified ratio. The ratio
	 * of the content position is calculated  on the size of the content minus the size
	 * of the mask.</p>
	 * <p>Since the version 1.8.1 the ratio value is automatically adjusted to 0 if the
	 * value is less than 0 and to 1 if the value is greater than 1.</p>
	 * 
	 * @param	ratio	A {@code Number} between 0 and 1 inclusive.
	 * @param	source	The object who is adjusting the scroll or {@code null}.
	 * @return	The number of pixels scrolled.
	 * @see		ch.component.scrollbar.ScrollManager#setRatio(Number)
	 */
	public function adjust(ratio:Number, source:Object):Number
	{
		//adjust the ratio
		if (ratio < 0) ratio = 0;
		else if (ratio > 1) ratio = 1;
		
		//scroll the content
		var scrolled:Number = _content.setRatio(ratio);
		
		//event
		fireScrollPerformed(scrolled, source, false);
		
		return scrolled;
	}
	
	/**
	 * Refresh the {@code ScrollBarModel}.
	 * <p>This method simply dispatch an event where
	 * the scroll value is 0. This will update all the
	 * listeners of the {@code ScrollBarModel}. Note
	 * that you can use this method when you update the
	 * content position directly ! It is important to not
	 * have tweens working on the content when you call
	 * this method, because the positions will not be correct.</p>
	 * 
	 * @param	source			The source object that perform the refresh or {@code null}.
	 * @param	updateContent	Indicates if the content must be moved when it is out of bounds (false by default).
	 * @see		ch.component.scrollbar.ScrollManager#updateCurrentPosition()
	 * @see		#fireScrollPerformed()
	 */
	public function refresh(source:Object, updateContent:Boolean):Void
	{
		if (updateContent == null) updateContent = false;
		
		//update the current position
		_content.updateCurrentPosition(updateContent);
		
		//dispatch the event
		fireScrollPerformed(0, source, true);
	}
	
	/**
	 * Get if the content can be scrolled.
	 * <p>If this method returns {@code false}, then a ScrollBar is
	 * not useful because the content can be completely shown in the mask.</p>
	 * 
	 * @return	{@code true} if a ScrollBar is needed.
	 */
	public function isScrollable(Void):Boolean
	{
		return _content.getMinMove() <= _content.getMaxMove();
	}
	
	/**
	 * Dispatch the {@code scrollPerformed} event to the listeners.
	 * <p>This method is conceptually public in order to be called
	 * by the subclasses ! It should not be called by the other classes.
	 * Use the <code>refresh</code> method in place.</p>
	 * 
	 * @param	scrolled	The number of pixels scrolled.
	 * @param	source		The object performing the event or {@code null}.
	 * @see		#refresh()
	 */
	public function fireScrollPerformed(scrolled:Number, source:Object, refreshOnly:Boolean):Void
	{
		var evt:ScrollEvent = new ScrollEvent(this, source, scrolled, _content.getRatio(), _content.getCurrentPosition(), refreshOnly);
		broadcastMessage("scrollPerformed", evt);
	
		//model event
		if (onScroll != null) onScroll(source, evt.getScrollValue(), evt.getRatio(), evt.getPosition(), refreshOnly);
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollBarModel instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollBarModel";
	}
}