/*
Class	ScrollClickButton
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollBar;
import ch.component.scrollbar.ScrollBarModel;
import ch.component.scrollbar.ScrollBarManager;
import ch.component.scrollbar.AbstractScrollBarManager;
import ch.util.Delegate;
import ch.component.scrollbar.ScrollListener;
import ch.component.scrollbar.ScrollEvent;

/**
 * Represent a button that manage a {@code ScrollBar} by being clicked.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.8
 */
class ch.component.scrollbar.ScrollClickButton extends AbstractScrollBarManager implements ScrollBarManager, ScrollListener
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Determine the speed of the interval (in ms) to perform
	 * a scroll  when the {@code autoScroll} delay is over.
	 * The scroll value can be adjusted with the
	 * {@code scrollValue} variable.
	 * <p>Constant value : 40.</p>
	 */
	public static function get SPEED_SCROLL():Number { return 40; }
	
	//---------//
	//Variables//
	//---------//
	private var _interval:Number;
	private var _button:MovieClip;
	
	/**
	 * Scroll value.
	 * <p>Determine the speed of the scroll when
	 * the button is pressed.</p>
	 */
	public var scrollValue:Number;
	
	/**
	 * Time to wait before automatic scroll.
	 * <p>By default, this value is 400.</p>
	 */
	public var autoScroll:Number;
	
	/**
	 * Define if the button should automatically activate/deactivate.
	 */
	public var autoDesactivate:Boolean;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollClickButton.
	 * 
	 * @param	button			The clip to set as button.
	 * @param	scrollValue		The value to scroll.
	 * @param	autoDesactivate	If the button should automatically activate/deactivate
	 * @throws	Error			If {@code button} is {@code null}.
	 * @throws	Error			If {@code scrollValue} is {@code null}.
	 */
	public function ScrollClickButton(button:MovieClip, scrollValue:Number, autoDesactivate:Boolean)
	{
		if (button == null)throw new Error(this+".<init> : button is not defined");
		if (scrollValue == null)throw new Error(this+".<init> : scrollValue is not defined");
		
		_button = button;
		_interval = null;
		
		if (autoDesactivate == null) autoDesactivate = true;
		
		this.scrollValue = scrollValue;
		this.autoScroll = 400;
		this.autoDesactivate = autoDesactivate;
		
		//actions
		_button.onRelease = Delegate.getRedirect(this, "onRelease");
		_button.onReleaseOutside = Delegate.getRedirect(this, "onReleaseOutside");
		_button.onPress = Delegate.getRedirect(this, "onPress");
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
		//enable or disable
		_button.enabled = value;
		
		//call the super method
		super.setEnabled(value);
	}
	
	/**
	 * Get the button clip.
	 * 
	 * @return	The clip.
	 */
	public function getClip(Void):MovieClip
	{
		return _button;
	}
	
	/**
	 * Method called when a scroll is performed on a
	 * {@code ScrollBarModel}.
	 * 
	 * @param	event	The event object.
	 */
	public function scrollPerformed(event:ScrollEvent):Void
	{
		var mo:ScrollBarModel = ScrollBarModel(event.getSource());
		var scr:Boolean = mo.isScrollable();
		
		if (scr != isEnabled()) setEnabled(scr);
	}
	
	/**
	 * Action onRelease of the clip.
	 */
	public function onRelease(Void):Void
	{
		clearInterval(_interval);
	}
	
	/**
	 * Action onPress of the clip.
	 */
	public function onPress(Void):Void
	{
		scroll(scrollValue);
		
		var me:ScrollClickButton = this;
		var now:Number = getTimer();
		
		_interval = setInterval(this, "automaticScroll", autoScroll);
	}
	
	/**
	 * Action onReleaseOutside of the clip.
	 */
	public function onReleaseOutside(Void):Void
	{
		onRelease();
	}
		
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollClickButton instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollClickButton";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function automaticScroll(Void):Void
	{
		clearInterval(_interval);
		_interval = setInterval(this, "scroll", SPEED_SCROLL, scrollValue);
	}
}