/*
Class	ScrollBar
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollType;
import ch.component.scrollbar.ScrollBarModel;
import ch.component.scrollbar.ScrollManager;
import ch.component.scrollbar.ScrollListener;
import ch.component.scrollbar.ScrollEvent;
import ch.component.scrollbar.ScrollClickButton;
import ch.component.scrollbar.ScrollDragButton;
import ch.component.scrollbar.ScrollWheelButton;
import ch.component.scrollbar.ScrollHandButton;

/**
 * Represent a ScrollBar in flash.
 * <p>A {@code ScrollBar} is totally virtual ! It provides you all the methods
 * to calculate and move your content as you want to. All the graphical components are let to you ! You
 * can link your graphical elements for the scroll management with the following methods :<br>
 * <ul>
 * 	<li>{@link #getClickButton()}</li>
 * 	<li>{@link #getUpButton()}</li>
 * 	<li>{@link #getDownButton()}</li>
 * 	<li>{@link #getScroller()}</li>
 * 	<li>{@link #getWheelButton()}</li>
 * 	<li>{@link #getHandButton()}</li>
 * </ul></p>
 * <p>Although the {@code ScrollBar} class provides you some methods to easly link the content to be
 * managed :<br>
 * <ul>
 * 	 <li>{@link #create()}</li>
 * 	 <li>{@link #createFromScrollManager()}</li>
 * </ul></p>
 * <p>The code beside shows how to create a classical vertical scrollbar associated with
 * his buttons</p>
 * <strong>Using :</strong><br><code>
 * var myScrollBar:ScrollBar = ScrollBar.create(this.content, this.mask, ScrollType.VERTICAL);<br>
 * <br>
 * //set the buttons<br>
 * var btnUp:ScrollClickButton = myScrollBar.getUpButton(this.up);<br>
 * var btnDn:ScrollClickButton = myScrollBar.getDownButton(this.down);<br>
 * var scroller:ScrollDragButton = myScrollBar.getScroller(this.scroller, this.scrollerBar, ScrollType.VERTICAL);<br>
 * <br>
 * //a button that scroll with 10 pixels<br>
 * //var simpleBtn:ScrollClickButton = myScrollBar.getClickButton(this.up, 10); //up button<br>
 * //var simpleBtn:ScrollClickButton = myScrollBar.getClickButton(this.down, -10); //down button<br>
 * <br>
 * //wheel button with a scroll of 10 pixels<br> 
 * //var wheel1:ScrollWheelButton = myScrollBar.getWheelButton(this.content, false, 10);<br>
 * //wheel button with the delta scroll value<br>
 * //var wheel2:ScrollWheelButton = myScrollBar.getWheelButton(this.content, false);<br>
 * //wheel button with the default scroll value<br>
 * var wheel3:ScrollWheelButton = myScrollBar.getWheelButton(this.content, true);<br>
 * </code><br></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.7
 * @see			ch.component.scrollbar.ScrollBarModel
 */
class ch.component.scrollbar.ScrollBar
{
	//---------//
	//Variables//
	//---------//
	private var _model:ScrollBarModel;
	
	/**
	 * Default scroll value for the buttons.
	 * <p>By default this value is 4.</p>
	 */
	public var defaultScrollValue:Number;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollBar.
	 * 
	 * @param	model		The model.
	 * @throws	Error		If {@code model} is {@code null}.
	 */
	public function ScrollBar(model:ScrollBarModel)
	{
		_model = null;
		
		setModel(model);
		
		defaultScrollValue = 4;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Create a new {@code ScrollBar}.
	 * 
	 * @param	target				The clip container.
	 * @param	mask				The mask of the target.
	 * @param	type				The {@code ScrollType} to use.
	 * @param	setMaskDynamically	Indicates if the mask must be set dynamically (using the {@code setMask} method).
	 * 								<code>false</code> by default.
	 * @return	A new {@code ScrollBar}.
	 */
	public static function create(target:MovieClip, mask:MovieClip, type:ScrollType, setMaskDynamically:Boolean):ScrollBar
	{
		if (setMaskDynamically) target.setMask(mask);
		
		var sm:ScrollManager = new ScrollManager(target, mask, type);
		return createFromScrollManager(sm);
	}
	
	/**
	 * Create a new {@code ScrollBar}.
	 * 
	 * @param	scm		{@code ScrollManager} to use.
	 * @return	A new {@code ScrollBar}.
	 */
	public static function createFromScrollManager(scm:ScrollManager):ScrollBar
	{
		var mo:ScrollBarModel = new ScrollBarModel(scm);
		return new ScrollBar(mo);
	}
	
	/**
	 * Set the model of the scroll bar.
	 * 
	 * @param	model	The model.
	 * @throws	Error	If {@code model} is {@code null}.
	 */
	public function setModel(model:ScrollBarModel):Void
	{
		if (model == null) throw new Error(this+".setModel : model is not defined");
		
		_model = model;
	}
	
	/**
	 * Get the model.
	 * 
	 * @return	The model.
	 */
	public function getModel(Void):ScrollBarModel
	{
		return _model;
	}
	
	/**
	 * Get a button associated with this {@code ScrollBar}.
	 * 
	 * @param	clip		The clip to be set as button.
	 * @param	scrollValue	The scroll value of the {@code ScrollClickButton}.
	 * @return	A new {@code ScrollClickButton} associated with this {@code ScrollBar}.
	 */
	public function getClickButton(clip:MovieClip, scrollValue:Number):ScrollClickButton
	{
		var scb:ScrollClickButton = new ScrollClickButton(clip, scrollValue);
		scb.addScrollBarModel(this.getModel());
		this.getModel().addListener(scb);
		return scb;
	}
	
	/**
	 * Get an up/right button associated with this {@code ScrollBar} with the default scroll value.
	 * 
	 * @param	clip		The clip to be set as button.
	 * @return	A new {@code ScrollClickButton} associated with this {@code ScrollBar}.
	 * @see		#defaultScrollValue
	 */
	public function getUpButton(clip:MovieClip):ScrollClickButton
	{
		return getClickButton(clip, defaultScrollValue);
	}
	
	/**
	 * Get a down/left button associated with this {@code ScrollBar} with the negative default scroll value.
	 * 
	 * @param	clip		The clip to be set as button.
	 * @return	A new {@code ScrollClickButton} associated with this {@code ScrollBar}.
	 * @see		#defaultScrollValue
	 */
	public function getDownButton(clip:MovieClip):ScrollClickButton
	{
		return getClickButton(clip, -defaultScrollValue);
	}
	
	/**
	 * Get a {@code ScrollWheelButton} associated with this {@code ScrollBar}.
	 * <p>The {@code clip} corresponds to the clip that will be checked when the
	 * {@link ch.component.scrollbar.ScrollWheelButton#onWheelMouse()} method will be called.</p>
	 * <p>There is three ways to use this method :<br>
	 * <code>sc.getWheelButton(clip, true); //will use the ScrollBar.defaultScrollValue<br>
	 * sc.getWheelButton(clip, false); //will use the delta of Mouse.onMouseWheel<br>
	 * sc.getWheelButton(clip, false, 10); //will use the value (10)<br>
	 * </code></p>
	 * 
	 * @param	clip					The clip that will be used for the manager.
	 * @param	useDefaultScrollValue	A value specifing if the {@code defaultScrollValue} will
	 * 									be used instead of the {@code delta} of the mouse wheel. By default,
	 * 									this value is {@code true}.
	 * @param	scrollValue				A value specifing the number of pixel to scroll or {@code null}.
	 * @return	A new {@code ScrollWheelButton} associated with this {@code ScrollBar}.
	 */
	public function getWheelButton(clip:MovieClip, useDefaultScrollValue:Boolean, scrollValue:Number):ScrollWheelButton
	{
		var toScroll:Number = defaultScrollValue;
		
		if (!useDefaultScrollValue) toScroll = scrollValue;
		
		var wh:ScrollWheelButton = new ScrollWheelButton(clip, toScroll);
		wh.addScrollBarModel(this.getModel());
		return wh;
	}
	
	/**
	 * Get a scroller associated with this {@code ScrollBar}.
	 * <p>A scroller is composed of two parts : the scroller that
	 * you can move and the delimiter (background of the scroller).</p>
	 * <p>By default, the {@code backgroundScrollValue} of the {@code ScrollDragButton} is
	 * <code>defaultScrollValue*3</code>.</p>
	 * 
	 * @param	scroller				The scroller.
	 * @param	background				The background of the scroller.
	 * @param	type					The {@code ScrollType} to use.
	 * @param	backgroundScrollValue	The background scroll value or {@code null}. If this value is <= 0, the scroller
	 * 									goes directly to the mouse position.
	 * @param	autoSize				Defines if the scroller is automatically resized or not depending on the content.									
	 * @return	A new {@code ScrollDragButton} associated with this {@code ScrollBar}.
	 */
	public function getScroller(scroller:MovieClip, background:MovieClip, type:ScrollType, backgroundScrollValue:Number, autoSize:Boolean):ScrollDragButton
	{
		if (backgroundScrollValue == null) backgroundScrollValue = defaultScrollValue*3;
		if (autoSize == null) autoSize = false;
		
		var sc:ScrollDragButton = new ScrollDragButton(scroller, background, type, backgroundScrollValue, autoSize);
		sc.addScrollBarModel(this.getModel());
		_model.addListener(sc);
		return sc;
	}
	
	/**
	 * Get a hand button linked to the content of this {@code ScrollBar} and the 
	 * {@code ScrollManager} of the content.
	 * <p>Note that the {@code ScrollHandButton} created by this method will only
	 * allows the drag of the content on one side (horizontal or vertical).<p>
	 * 
	 * @return	A new {@code ScrollHandButton} associated with the {@code ScrollBarModel} of this {@code ScrollBar}.
	 */
	public function getHandButton(Void):ScrollHandButton
	{
		var shb:ScrollHandButton = new ScrollHandButton(_model.getContent());
		shb.addScrollBarModel(_model);
		_model.addListener(shb);
		
		//set the depending scroll manager
		if (_model.getType() == ScrollType.VERTICAL)shb.setVerticalScrollManager(_model.getScrollManager());
		else shb.setHorizontalScrollManager(_model.getScrollManager());
		
		return shb;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollBar instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollBar";
	}
}