/*
Class	VirtualScroller
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	19 nov. 2005
*/

/**
 * Provides the calculation of a scroller.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		19 nov. 2005
 * @version		1.0
 */
class ch.util.VirtualScroller
{
	//---------//
	//Variables//
	//---------//
	private var			_sizeContent:Number; //size content
	private var			_sizeScroller:Number; //size scroller
	private var			_sizeMask:Number; //size mask
	private var			_sizePlaceScroller:Number; //size place scroller	
	private var			_realSizeContent:Number; //calculated size
	private var			_realSizeScroller:Number; //calculated size
	private var			_currentPlaceContent:Number; //current place content
	private var			_currentPlaceScroller:Number; //current place scroller
	private var			_ratioContent:Number; //ratio of the content
	
	/**
	 * Called when a content is scrolled.
	 * <p>Prototype of the function :<br>
	 * <code>myVirtualScroller.onScroll = function(posContent:Number,
	 *                                             posScroller:Number):Void { ... }</code></p>
	 */
	public var onScroll:Function;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new VirtualScroller.
	 * 
	 * @param		sizeContent			Size of the content that must be scrolled.
	 * @param		sizeMask			Size of the mask of the content.
	 * @param		sizeScroller		Size of the scroller.
	 * @param		sizePlaceScroller	Size of the place of the scroller (by default {@code sizeMask}).
	 * @throws		Error				If {@code sizeContent} is {@code null} or less than 0.
	 * @throws		Error				If {@code sizeMask} is {@code null} or less than 0.
	 * @throws		Error				If {@code sizeScroller} is {@code null} or less than 0.
	 */
	public function VirtualScroller(sizeContent:Number, sizeMask:Number,
									sizeScroller:Number, sizePlaceScroller:Number)
	{
		if (sizeContent == null)
		{
			throw new Error(this+".<init> : sizeContent is undefined");
		}
		
		if (sizeContent < 0)
		{
			throw new Error(this+".<init> : sizeContent is invalid ("+sizeContent+")");
		}
		
		if (sizeMask == null)
		{
			throw new Error(this+".<init> : sizeMask is undefined");
		}
		
		if (sizeMask < 0)
		{
			throw new Error(this+".<init> : sizeMask is invalid ("+sizeMask+")");
		}
		
		if (sizeScroller == null)
		{
			throw new Error(this+".<init> : sizeScroller is undefined");
		}
		
		if (sizeScroller < 0)
		{
			throw new Error(this+".<init> : sizeScroller is invalid ("+sizeScroller+")");
		}
		
		if (sizePlaceScroller == null || sizePlaceScroller < 0)
		{
			sizePlaceScroller = sizeMask;
		}
		
		//init
		_sizeScroller = sizeScroller;
		_sizeMask = sizeMask;
		_sizePlaceScroller = sizePlaceScroller;
		_sizeContent = sizeContent;
		_realSizeContent = sizeContent-sizeMask;
		_realSizeScroller = sizePlaceScroller-sizeScroller;
		_currentPlaceContent = 0;
		_currentPlaceScroller = 0;
		_ratioContent = 1;
		onScroll = null;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the size of the content.
	 * 
	 * @return	The size of the content.
	 */
	public function getContentSize(Void):Number
	{
		return _sizeContent;
	}
	
	/**
	 * Get the size of the scroller.
	 * 
	 * @return	The size of the scroller.
	 */
	public function getScrollerSize(Void):Number
	{
		return _sizeScroller;
	}
	
	/**
	 * Get the size of the mask.
	 * 
	 * @return	The size of the mask.
	 */
	public function getMaskSize(Void):Number
	{
		return _sizeMask;
	}
	
	/**
	 * Get the size of the place of the scroller.
	 * 
	 * @return	The size of the place of the scroller.
	 */
	public function getPlaceScrollerSize(Void):Number
	{
		return _sizePlaceScroller;
	}
	
	/**
	 * Get the virtually place of the scroller.
	 * 
	 * @return	The current place of the scroller.
	 */
	public function getCurrentPlaceScroller(Void):Number
	{
		return _currentPlaceScroller;
	}
	
	/**
	 * Get the virtually place of the content.
	 * 
	 * @param	The current place of the content.
	 */
	public function getCurrentPlaceContent(Void):Number
	{
		return _currentPlaceContent;
	}
	
	/**
	 * Get if the {@code VirtualScroller} can be scrolled or not.
	 * <p>A non scrollable {@code VirtualScroller} means that the mask is
	 * bigger thant the content (so the content is already totaly visible) or
	 * that the size of the scroller is bigger than the place it has for scrolling.</p>
	 * 
	 * @return	{@code true} if the {@code VirtualScroller} is scrollable.
	 */
	public function isScrollable(Void):Boolean
	{
		return (_sizeMask < _sizeContent && _sizeScroller < _sizePlaceScroller);
	}
	
	/**
	 * Get the maximum value for the {@link #moveContentTo(Number)} method.
	 * <p>Note that the minimal value is 0.</p>
	 * 
	 * @return	The maximum value for the content move.
	 */
	public function getMaxMoveContent(Void):Number
	{
		return _realSizeContent;
	}
	
	/**
	 * Get the maximum value for the {@link #moveScrollerTo(Number)} method.
	 * <p>Note that the minimal value is 0.</p>
	 * 
	 * @return	The maximum value for the scroller move.
	 */
	public function getMaxMoveScroller(Void):Number
	{
		return _realSizeScroller;
	}
	
	/**
	 * Get if the content can move further of if it is
	 * at the max of its position.
	 * 
	 * @return	{@code true} if the content can't move further.
	 */
	public function isMaxContent(Void):Boolean
	{
		return _currentPlaceContent == getMaxMoveContent();
	}
	
	/**
	 * Get if the content is at his start place (0).
	 * 
	 * @return	{@code true} if the content is at his start place.
	 */
	public function isMinContent(Void):Boolean
	{
		return _currentPlaceContent==0;
	}
	
	/**
	 * Get if the scroller is at his start place (0).
	 * 
	 * @return	{@code true} if the scroller is at his start place.
	 */
	public function isMinScroller(Void):Boolean
	{
		return _currentPlaceScroller==0;
	}
	
	/**
	 * Get if the scroller can move further of if it is
	 * at the max of its position.
	 * 
	 * @return	{@code true} if the scroller can't move further.
	 */
	public function isMaxScroller(Void):Boolean
	{
		return _currentPlaceScroller == getMaxMoveScroller();
	}
	
	/**
	 * Move the content (relative).
	 * <p>This method simply call the {@link #moveContentTo(Number)} method,
	 * taking the current place and adding {@code append}.</p>
	 * <p>Note that if the current place of the content adding {@code append}
	 * is bigger than {@link #getMaxMoveContent()}, no {@code Error} is thrown,
	 * it will go to the max position.</p>
	 * 
	 * @param	append	The new relative place.
	 */
	public function appendContent(append:Number):Void
	{
		var np:Number = _currentPlaceContent+append;
		
		if (np > getMaxMoveContent())
		{
			np = getMaxMoveContent();
		}
		else if (np < 0)
		{
			np = 0;
		}
		
		moveContentTo(np);
	}
	
	/**
	 * Move the scroller (relative).
	 * <p>This method simply call the {@link #moveScrollerTo(Number)} method,
	 * taking the current place and adding the {@code append} value.</p>
	 * <p>Note that if the current place of the scroller adding {@code append}
	 * is bigger than {@link #getMaxMoveScroller()}, no {@code Error} is thrown,
	 * it will go to the max position.</p>
	 * 
	 * @param	append	The new relative place.
	 */
	public function appendScroller(append:Number):Void
	{
		var np:Number = _currentPlaceScroller+append;
		
		if (np > getMaxMoveScroller())
		{
			np = getMaxMoveScroller();
		}
		else if (np < 0)
		{
			np = 0;
		}
		
		moveScrollerTo(np);
	}
	
	/**
	 * Move the content (absolute).
	 * <p>This method call the {@link #onScroll} function with the associated
	 * parameters and adjust the scroller position.</p>
	 * 
	 * @param	target		The new place of the content.
	 * @throws	Error		If {@code target} is less than 0 or bigger
	 * 						than {@link #getMaxMoveContent()}.
	 */
	public function moveContentTo(target:Number):Void
	{
		//check
		if (target < 0 || target > getMaxMoveContent())
		{
			throw new Error(this+".moveContentTo : invalid target ("+target+")");
		}
		
		var ratio:Number = target / getMaxMoveContent();
		_currentPlaceContent = target;
		_currentPlaceScroller = getMaxMoveScroller()*ratio;
		
		//scroll event
		onScroll(_currentPlaceContent*_ratioContent, _currentPlaceScroller);
	}
	
	/**
	 * Move the scroller (absolute).
	 * <p>This method call the {@link #onScroll} function with the associated
	 * parameters and adjust the content position.</p>
	 * 
	 * @param	target		The new place of the scroller.
	 * @throws	Error		If {@code target} is less than 0 or bigger
	 * 						than {@link #getMaxMoveScroller()}.
	 */
	public function moveScrollerTo(target:Number):Void
	{
		//check
		if (target < 0 || target > getMaxMoveScroller())
		{
			throw new Error(this+".moveScrollerTo : invalid target ("+target+")");
		}
		
		var ratio:Number = target / getMaxMoveScroller();
		_currentPlaceContent = getMaxMoveContent()*ratio;
		_currentPlaceScroller = target;
		
		//scroll event
		onScroll(_currentPlaceContent*_ratioContent, _currentPlaceScroller);
	}
	
	/**
	 * Get the ratio.
	 * 
	 * @return	The ratio.
	 */
	public function getRatio(Void):Number
	{
		return _ratioContent;
	}
	
	/**
	 * Set the ratio.
	 * <p>The ratio is used when dispatching the {@link #onScroll}
	 * event for the new content position. It is very useful to have directly
	 * the inverted position (ratio = -1).</p>
	 * <p>By default, the ratio is set to 1.</p>
	 * 
	 * @param	ratio	The new ratio.
	 */
	public function setRatio(ratio:Number):Void
	{
		_ratioContent = ratio;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the VirtualScroller instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.VirtualScroller";
	}
}