/*
Class	ScrollDragButton
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollType;
import ch.component.scrollbar.ScrollBar;
import ch.component.scrollbar.ScrollListener;
import ch.component.scrollbar.ScrollBarModel;
import ch.component.scrollbar.ScrollBarManager;
import ch.component.scrollbar.ScrollEvent;
import ch.component.scrollbar.AbstractScrollBarManager;
import ch.util.Delegate;

/**
 * Represent a button that manage a {@code ScrollBar} by being dragged.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.8.1
 */
class ch.component.scrollbar.ScrollDragButton extends AbstractScrollBarManager implements ScrollBarManager, ScrollListener
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Normal mode.
	 * <p>Constant value : 0.</p>
	 */
	public static function get NORMAL_MODE():Number { return 0; }
	
	/**
	 * Reverse mode.
	 * <p>Constant value : 1.</p>
	 */
	public static function get REVERSE_MODE():Number { return 1; }
	
	/**
	 * Determine the speed of the interval (in ms) to perform
	 * a scroll on the background when the {@code autoScroll} delay
	 * is over. The scroll value can be adjusted with the
	 * {@code backgroundScrollValue} variable.
	 * <p>Constant value : 40.</p>
	 */
	public static function get SPEED_SCROLL():Number { return 40; }
	
	//---------//
	//Variables//
	//---------//
	private var _scroller:MovieClip;
	private var _background:MovieClip;
	private var _type:ScrollType;
	private var _size:String;
	private var _position:String;
	private var	_dragging:Boolean;
	private var _backgroundPressed:Boolean;
	private var _mode:Number;
	private var _interval:Number;
	private var _oldMouseMove:Function;
	private var _scrollValue:Number;
	private var _scrollTop:Boolean;
	
	/**
	 * Scroll value on the background press.
	 * <p>Specifies the value to scroll when the
	 * user press on the background of the scroller.</p>
	 * <p>If this value is less than or equal to 0,
	 * the scroller will be direct scrolled to the mouse position.</p>
	 */
	public var backgroundScrollValue:Number;
	
	/**
	 * Time to wait before automatic scroll.
	 * <p>This value is linked with the {@code TIME_SCROLL} value. It specifies
	 * how many milliseconds to wait before the scroller is automatically
	 * scrolled when the user press the background.</p>
	 * <p>By default, this value is 400.</p>
	 */
	public var autoScroll:Number;
	
	/**
	 * Defines the minimum size of the scroller when
	 * the <code>autoAdjust</code> property is <code>true</code>.
	 */
	public var minimumSize:Number;
	
	/**
	 * Defines the maximum size of the scroller when
	 * the <code>autoAdjust</code> property is <code>true</code>.
	 */
	public var maximumSize:Number;
	
	/**
	 * Defines if the scroller should be adjusted automatically depending
	 * on the content size.
	 * <p>The size of the scroller will be set at the same ratio of
	 * the content whent the <code>refresh()</code> method will be
	 * invoked.</p>
	 */
	public var autoAdjust:Boolean;
	
	/**
	 * Defines if the scroller should automatically hide or not.
	 */
	public var autoHide:Boolean;
	
	/**
	 * Defines if the scroller should be resized each time an <code>actionPerformed</code>
	 * event is performed or only when the event is a refresh event.
	 */
	public var alwaysResize:Boolean;
	
	/**
	 * Defines if a refresh event must be dispatched when the mouse is pressed or only when
	 * the mouse is released.
	 */
	public var alwaysRefresh:Boolean;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollDragButton.
	 * 
	 * @param	scroller				The clip scroller.
	 * @param	scrollerBackgroudn		The background of {@code scroller}.
	 * @param	type					The {@code ScrollType} to use.
	 * @param	backgroundScrollValue	Scroll value on the press on the background (<=0 means that the scroller scrolls directly to the mouse position).
	 * @param	autoAdjust				If the scroller should adjust automatically. () 
	 * @param	autoHide				If the scroller should automatically hide.
	 * @param	alwaysResize			If the scroller should be resized at all events.
	 * @param	alwaysRefresh			If a refresh event must be dispatched when the mouse is pressed.
	 * @throws	Error					If {@code scroller} is {@code null}.
	 * @throws	Error					If {@code scrollerBackground} is {@code null}.
	 * @throws	Error					If {@code type} is {@code null}.
	 * @throws	Error					If {@code backgroundScrollValue} is {@code null}.
	 */
	public function ScrollDragButton(scroller:MovieClip,
									 scrollerBackground:MovieClip,
									 type:ScrollType, 
									 backgroundScrollValue:Number, 
									 autoAdjust:Boolean, 
									 autoHide:Boolean,
									 alwaysResize:Boolean,
									 alwaysRefresh:Boolean)
	{
		if (scroller == null)throw new Error(this+".<init> : scroller is not defined");
		if (scrollerBackground == null)throw new Error(this+".<init> : scrollerBackground is not defined");
		if (type == null)throw new Error(this+".<init> : type is not defined");
		if (backgroundScrollValue == null)throw new Error(this+".<init> : backgroundScrollValue is not defined");
		
		_scroller = scroller;
		_background = scrollerBackground;
		_type = type;
		_position = _type.getScrollProperty();
		_size = _type.getSizeProperty();
		_dragging = false;
		_mode = NORMAL_MODE;
		_interval = null;
		_scrollValue = null;
		_scrollTop = null;
		_backgroundPressed = null;
		_oldMouseMove = null;
		
		if (autoAdjust == null) autoAdjust = false;
		if (autoHide == null) autoHide = true;
		if (alwaysRefresh == null) alwaysRefresh = true;
		if (alwaysResize == null) alwaysResize = false;
		
		this.autoScroll = 400;
		this.backgroundScrollValue = backgroundScrollValue;
		this.autoAdjust = autoAdjust;
		this.autoHide = autoHide;
		this.alwaysResize = alwaysResize;
		this.alwaysRefresh = alwaysRefresh;
		this.minimumSize = 4;
		this.maximumSize = 1000;
		
		//actions
		_scroller.onPress = Delegate.getRedirect(this, "onScrollerPress");
		_scroller.onRelease = Delegate.getRedirect(this, "onScrollerRelease");
		_scroller.onReleaseOutside = Delegate.getRedirect(this, "onScrollerReleaseOutside");
		_background.onPress = Delegate.getRedirect(this, "onBackgroundPress");
		_background.onRelease = Delegate.getRedirect(this, "onBackgroundRelease");
		_background.onReleaseOutside = Delegate.getRedirect(this, "onBackgroundReleaseOutside");
		
		//update the scroll, so it goes directly to the right place
		setRatio(0);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Set if the {@code ScrollDragButton} is enabled or not.
	 * 
	 * 
	 * @param	value	{@code true} to enable the {@code ScrollDragButton}, {@code false} otherwise.
	 */
	public function setEnabled(value:Boolean):Void
	{
		//enabled or disable
		_scroller.enabled = value;
		_scroller._visible = value;
		_background.enabled = value;
		
		//call the super method
		super.setEnabled(value);
	}
	
	/**
	 * Get the scroller clip.
	 * 
	 * @return	The scroller.
	 */
	public function getScroller(Void):MovieClip
	{
		return _scroller;
	}
	
	/**
	 * Get the background of the scroller.
	 * 
	 * @return	The background.
	 */
	public function getBackground(Void):MovieClip
	{
		return _background;
	}
	
	/**
	 * Get the scroll type.
	 * 
	 * @return	The {@code ScrollType} used.
	 */
	public function getType(Void):ScrollType
	{
		return _type;
	}
	
	/**
	 * Get the mode.
	 * 
	 * @return	{@code NORMAL_MODE} or {@code REVERSE_MODE}.
	 */
	public function getMode(Void):Number
	{
		return _mode;
	}
	
	/**
	 * Set the mode.
	 * <p>The mode set how the {@code ScrollDragButton} must move. By normal mode,
	 * it will move up-down or left-right. By reverse mode, it will move down-up or
	 * right-left. This method automatically replace the scroller at his right place,
	 * depending on the current ratio, calling the {@code setRatio} method.</p>
	 * <p>If the <code>mode</code> is the same as the current mode, nothing append.</p>
	 * 
	 * @param	mode	{@code NORMAL_MODE} or {@code REVERSE_MODE}.
	 * @throws	Error	If {@code mode} is invalid.
	 */
	public function setMode(mode:Number):Void
	{
		if (mode == _mode) return; //mode already set
		if (mode == null || (mode != NORMAL_MODE && mode != REVERSE_MODE))
		{
			throw new Error(this+".setMode : mode is invalid ("+mode+")");
		}
		
		//store the ratio
		var r:Number = getRatio();
		
		//change the mode
		_mode = mode;
		
		//reinit the scroller position to the current ratio
		setRatio(r);
	}
	
	/**
	 * Method called when a scroll is performed on a {@code ScrollBarModel}.
	 * 
	 * @param	event	The event object.
	 */
	public function scrollPerformed(event:ScrollEvent):Void
	{
		//nothing because we are scrolling
		if (_dragging) return;

		//retrieves the source
		var mo:ScrollBarModel = ScrollBarModel(event.getSource());
	
		//enable / disable the scroller
		var scr:Boolean = mo.isScrollable();
		if (scr != isEnabled()) setEnabled(scr);

		//auto adjust the scroller
		if (autoAdjust && (alwaysResize || event.isRefresh()))
		{
			var cr:Number = getContentRatio();
			var sr:Number = mo.getScrollManager().getContentRatio();
			
			//calculate the new size
			var newSize:Number = _background[_size]*sr;
			if (newSize < minimumSize) newSize = minimumSize; //minimum size
			else if (newSize > maximumSize && maximumSize > 0) newSize = maximumSize; //maximum size
			if (sr >= 1) newSize = 0; //no scroll needed (no size)
			
			resize(newSize);
		}

		//ratio update
		setRatio(event.getRatio());
	}
	
	/**
	 * Get the size ratio between the content and the background.
	 * 
	 * @return	The size ratio of the content.
	 */
	public function getContentRatio(Void):Number
	{
		return _scroller[_size]/_background[_size];
	}
	
	/**
	 * Resize the scroller to the specified size.
	 * 
	 * @param	size	The size for the scroller.
	 */
	public function resize(size:Number):Void
	{
		_scroller[_size] = Math.floor(size);
	}
	
	/**
	 * Get if this {@code ScrollDragButton} is being dragged.
	 * 
	 * @return	{@code true} if the scroller is being dragged.
	 */
	public function isDragged(Void):Boolean
	{
		return _dragging;
	}
	
	/**
	 * Get if the background is pressed.
	 * 
	 * @return	{@code true} if the background is pressed.
	 */
	public function isBackgroundPressed(Void):Boolean
	{
		return _backgroundPressed;
	}
	
	/**
	 * Set the ratio of the scroller.
	 * <p>Calling this method won't affect the linked {@code ScrollBar} ! It only
	 * will move the scroller to the specified ratio, using the {@code scrollTo} method.
	 * When you want to adjust the {@code ScrollBar} linked to the {@code ScrollDragButton},
	 * use the {@code adjust} method.</p>
	 * <p>Note that a {@code ScrollDragButton} in {@code NORMAL_MODE} or
	 * in {@code REVERSE_MODE} will not be set at the same place within the same value. The
	 * {@code ScrollDragButton} in {@code REVERSE_MODE} will be automatically adjusted !</p>
	 * 
	 * @param	ratio	A {@code Number} between 0 and 1 inclusive.
	 * @see		ch.component.scrollbar.ScrollBarModel#adjust()
	 * @see		ch.component.scrollbar.AbstractScrollBarManager#adjust()
	 */
	public function setRatio(ratio:Number):Void
	{
		if (ratio < 0 || ratio > 1) throw new Error(this+".setRatio : invalid ratio ("+ratio+")");
		if (_mode == REVERSE_MODE) ratio = 1-ratio;

		scrollTo(_scroller, _position, ratio*(_background[_size]-_scroller[_size])+_background[_position]);
	}
	
	/**
	 * Get the ratio of the scroller.
	 * <p>Note that a {@code ScrollDragButton} in {@code NORMAL_MODE} or
	 * in {@code REVERSE_MODE} will return the same value !</p>
	 * 
	 * @return	A {@code Number} between 0 and 1 inclusive.
	 */
	public function getRatio(Void):Number
	{
		var scr:MovieClip = getScroller();
		var bcg:MovieClip = getBackground();
		var position:String = _position;
		var size:String = _size;
		var div:Number = bcg[size]-scr[size];
		var ratio:Number = (scr[position]-bcg[position])/div;
		
		if (_mode == ScrollDragButton.REVERSE_MODE) ratio = 1-ratio;
		
		return ratio;
	}
	
	/**
	 * Scroll to the specified value. This method moves directly the
	 * target clip property to the specified valu.
	 * 
	 * @param	target		The target clip.
	 * @param	property	The property to affect.
	 * @param	value		The position.
	 */
	public function scrollTo(target:MovieClip, property:String, value:Number):Void
	{
		target[property] = value;
		updateAfterEvent();
	}
	
	/**
	 * Action onRelease of the clip.
	 */
	public function onScrollerRelease(Void):Void
	{
		adjust(getRatio());
		
		_dragging = false;
		
		var scr:MovieClip = getScroller();
		scr.stopDrag();
		
		if (_oldMouseMove != null) scr.onMouseMove = _oldMouseMove;
		else delete scr.onMouseMove;
	}
	
	/**
	 * Action onPress of the clip.
	 */
	public function onScrollerPress(Void):Void
	{
		_dragging = true;
		
		var scr:MovieClip = getScroller();
		var bcg:MovieClip = getBackground();
		var me:ScrollDragButton = this;
		
		//calculate the limits of the dragging
		var left:Number = bcg._x;
		var top:Number = bcg._y;
		var right:Number = bcg._x+bcg._width-scr._width;
		var bottom:Number = bcg._y+bcg._height-scr._height;

		var oldRatio:Number = getRatio();
		
		_oldMouseMove = scr.onMouseMove;
		scr.startDrag(false, left, top, right, bottom);
		scr.onMouseMove = function(Void):Void
		{
			var ratio:Number = me.getRatio();
			
			//adjust the scroll only if the new ratio
			//is different from the old one
			if (me.alwaysRefresh && ratio != oldRatio)
			{
				me.adjust(ratio);
				oldRatio = ratio;
			}
			
			//old mouse move
			if (me._oldMouseMove != null) me._oldMouseMove();
		};
		
		//adjust the scroll
		adjust(oldRatio);
	}
	
	/**
	 * Action onReleaseOutside of the clip.
	 */
	public function onScrollerReleaseOutside(Void):Void
	{
		onScrollerRelease();
	}
	
	/**
	 * Action onPress of the background.
	 */
	public function onBackgroundPress(Void):Void
	{
		//when the backgroundScrollValue property is less than or equal to 0,
		//then the scroller goes directly to the mouse position
		if (backgroundScrollValue <= 0)
		{
			var si:Number = Math.floor(_scroller[_size]/2)+1;
			var mp:Number = _scroller._parent[_position+"mouse"]-si;
			
			//target position
			var tg:Number = mp;
			if(mp+_scroller[_size] > _background[_position]+_background[_size]) tg = _background[_position]+_background[_size]-_scroller[_size];
			else if(mp < _background[_position]) tg = _background[_position];
			
			_scroller[_position] = tg;
			adjust(getRatio());
			
			return;
		}
		
		//here the scroller won't come directly to the mouse position, but
		//will scroll sequentially to the mouse position
		
		_backgroundPressed = true;
		
		//checking if the scroll is going up to down or down to up
		_scrollTop = (_scroller[_position]>_scroller._parent[_position+"mouse"]);
		
		//set the scroll value
		_scrollValue = (_scrollTop) ? -backgroundScrollValue : backgroundScrollValue;
		if (_mode != REVERSE_MODE) _scrollValue = -_scrollValue;
		
		_interval = setInterval(this, "launchAutoScroll", autoScroll);
		scrollBackground();
	}
	
	/**
	 * Action onRelease of the background.
	 */
	public function onBackgroundRelease(Void):Void
	{
		_backgroundPressed = false;
		clearInterval(_interval);
	}
	
	/**
	 * Action onReleaseOutside of the background.
	 */
	public function onBackgroundReleaseOutside(Void):Void
	{
		onBackgroundRelease();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollDragButton instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollDragButton";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function launchAutoScroll(Void):Void
	{
		clearInterval(_interval);
		_interval = setInterval(this, "scrollBackground", SPEED_SCROLL);
	}
	
	private function scrollBackground(Void):Void
	{
		var pm:Number = _scroller._parent[_position+"mouse"];
		var pb:Number = _scroller[_position];
		
		if ((pm >= pb && pm <= pb+_scroller[_size])   ||	//check if the mouse is over the scroller
		    (_scrollTop && pm >= pb+_scroller[_size]) ||	//check if the scroll is going to top and the mouse is under the scroller
		    (!_scrollTop && pm <= pb))						//check if the scroll is going to down and the mouse is upper the scroller
		{
			onBackgroundRelease();
			return;
		}
		
		scroll(_scrollValue);
	}
}