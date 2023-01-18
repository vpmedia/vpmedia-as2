import mx.utils.Delegate;

import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Loader;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

[InspectableList("alignIcon", "background", "backgroundColor", "bold", "border", "borderColor", "embedFonts", "label", "color", "textSize", "multiline", "wordWrap", "font", "password", "selectable", "restrict", "maxChars", "toggle", "selected")]
class com.jxl.shuriken.controls.Button extends SimpleButton
{
	public static var SYMBOL_NAME:String 				= "com.jxl.shuriken.controls.Button";
	
	public static var ALIGN_ICON_LEFT:String 			= "alignIconLeft";
	public static var ALIGN_ICON_CENTER:String 			= "alignIconCenter";
	public static var ALIGN_ICON_RIGHT:String 			= "alignIconRight";
	
	public static var SELECTED_STATE:String 			= "selected";
	public static var DEFAULT_STATE:String 				= "default";
	public static var OVER_STATE:String 				= "over";
	
	[Inspectable(type="String", defaultValue="", name="Label")]
	public function get label():String { return __label; }
	public function set label(pVal:String):Void
	{
		__label = pVal;
		__mcLabel.text = pVal;
	}
	
	/**
	* A Boolean that indicates whether toggling is enabled.
	* 
	* Setting this to true will make the button's selected state toggle,
	* when it is clicked.
	*/
	[Inspectable(type="Boolean", defaultValue=false, name="Toggle")]
	public function get toggle ():Boolean { return __toggle; }
	public function set toggle (value:Boolean):Void 
	{
		if(value != __toggle)
		{
			__toggle = value;
			invalidate();
		}
	}
	
	/**
	* A Boolean that indicates whether the button is in its selected state
	* 
	* This property is only updated (and is only relevant) when toggle is set to true.
	* 
	*/
	[Inspectable(type="Boolean", defaultValue=false, name="Selected")]
	public function get selected ():Boolean {return __selected;}
	
	public function set selected (value:Boolean):Void
	{
		if(value != __selected && __toggle == true)
		{
			__selected = value;
			
			if (__selected == true)
			{
				setState(SELECTED_STATE);
			}
			else
			{
				setState(DEFAULT_STATE);
			}
			__selectionChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.SELECTION_CHANGED, this));
			invalidate();
		}
		
	}
	
	public function get icon():String { return __icon; }
	
	public function set icon(pVal:String):Void
	{
		if(pVal != __icon)
		{
			__icon = pVal;
			if(__icon != null && __icon != "")
			{
				if(__mcIcon == null) __mcIcon = Loader(attachMovie(Loader.SYMBOL_NAME , "__mcIcon", getNextHighestDepth()));
				__mcIcon.scaleContent = false;
				__mcIcon.load(pVal);
				__mcIcon.setLoadInitCallback(this, onIconLoaded);
			}
			else
			{
				__mcIcon.removeMovieClip();
				delete __mcIcon;
			}
		}
	}
	
	
	// Proxying styles from 
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get background():Boolean
	{
		return __mcLabel.background;
	}
	
	public function set background(pVal:Boolean):Void
	{		
		if(pVal != __background)
		{
			__background = pVal;
			__mcLabel.background = pVal;
		}
		
	}	
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#FFFFFF", type="Color")]
	public function get backgroundColor():Number
	{
		return __mcLabel.backgroundColor;
	}
	
	public function set backgroundColor(p_val:Number):Void
	{
		__backgroundColor = p_val;
		__mcLabel.backgroundColor = p_val;
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get bold():Boolean
	{
		return __mcLabel.bold;
	}
	
	public function set bold(pVal:Boolean):Void
	{		
		if(pVal != __bold)
		{
			__bold = pVal;
			__mcLabel.bold = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get border():Boolean
	{
		return __mcLabel.border;
	}
	
	public function set border(pVal:Boolean):Void
	{		
		if(pVal != __border)
		{
			__border = pVal;
			__mcLabel.border = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#000000", type="Color")]
	public function get borderColor():Number
	{
		return __mcLabel.borderColor;
	}
	
	public function set borderColor(pVal:Number):Void
	{		
		if(pVal != __borderColor)
		{
			__borderColor = pVal;
			__mcLabel.borderColor = pVal;
		}
		
	}


	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get embedFonts():Boolean
	{
		return __mcLabel.embedFonts;
	}
	
	public function set embedFonts(pVal:Boolean):Void
	{		
		if(pVal != __embedFonts)
		{
			__embedFonts = pVal;
			__mcLabel.embedFonts = pVal;
		}
	
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#000000", type="Color")]
	public function get color():Number
	{
		return __mcLabel.color;
	}
	
	public function set color(pVal:Number):Void
	{		
		if(pVal != __color)
		{
			__color = pVal;
			__mcLabel.color = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=12, type="Number")]
	public function get textSize():Number
	{
		return __mcLabel.textSize;
	}
	
	public function set textSize(pVal:Number):Void
	{		
		if(pVal != __textSize)
		{
			__textSize = pVal;
			__mcLabel.textSize = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get multiline():Boolean
	{
		return __mcLabel.multiline;
	}
	
	public function set multiline(pVal:Boolean):Void
	{		
		if(pVal != __multiline)
		{
			__multiline = pVal;
			__mcLabel.multiline = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get wordWrap():Boolean
	{
		return __mcLabel.wordWrap;
	}
	
	public function set wordWrap(pVal:Boolean):Void
	{		
		if(pVal != __wordWrap)
		{
			__wordWrap = pVal;
			__mcLabel.wordWrap = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="_sans", type="Font Name")]
	public function get font():String
	{
		return __mcLabel.font;
	}
	
	public function set font(pVal:String):Void
	{		
		if(pVal != __font)
		{
			__font = pVal;
			__mcLabel.font = pVal;
		}
	
	}
	
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=undefined, type="Boolean")]
	public function get password():Boolean
	{
		return __mcLabel.password;
	}
	
	public function set password(pVal:Boolean):Void
	{		
		if(pVal != __password)
		{
			__password = pVal;
			__mcLabel.password = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get selectable():Boolean
	{
		return __mcLabel.selectable;
	}
	
	public function set selectable(pVal:Boolean):Void
	{		
		if(pVal != __selectable)
		{
			__selectable = pVal;
			__mcLabel.selectable = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(type="String")]
	public function get restrict():String
	{
		return __mcLabel.restrict;
	}
	
	public function set restrict(pVal:String):Void
	{		
		if(pVal != __restrict)
		{
			__restrict = pVal;
			__mcLabel.restrict = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=null, type="Number")]
	public function get maxChars():Number
	{
		return __mcLabel.maxChars;
	}
	
	public function set maxChars(pVal:Number):Void
	{		
		if(pVal != __maxChars)
		{
			__maxChars = pVal;
			__mcLabel.maxChars = pVal;
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=alignIconLeft, type="List", enumeration="alignIconLeft,alignIconCenter,alignIconRight")]
	public function get alignIcon():String { return __alignIcon; }
	
	public function set alignIcon(pVal:String):Void
	{
		if(pVal != __alignIcon)
		{
			__alignIcon = pVal;
			invalidate();
		}
	}
	
	public function get underline():Boolean { return __underline; }
	
	public function set underline(p_val:Boolean):Void
	{
		__underline = p_val;
		__mcLabel.underline = p_val;
	}
	
	public function get currentState():String { return __currentState; }
	
	private var __label:String;
	private var __selected:Boolean						= false;
	private var __toggle:Boolean						= false;
	private var __currentState:String 					= "default";
	private var __lastState:String 						= "";
	private var __icon:String;
	private var __background:Boolean					= false;
	private var __backgroundColor:Number;
	private var __bold:Boolean							= false;
	private var __border:Boolean;
	private var __borderColor:Number;		
	private var __embedFonts:Boolean;
	private var __color:Number;
	private var __textSize:Number;	
	private var __multiline:Boolean;	
	private var __wordWrap:Boolean;		
	private var __font:String;
	private var __password:Boolean;
	private var __selectable:Boolean					= false;
	private var __restrict:String;		
	private var __maxChars:Number;
	private var __alignIcon:String						= "alignIconLeft";
	private var __underline:Boolean						= false;

	private var __selectionChangeCallback:Callback;
	
	private var __mcLabel:TextField;
	private var __mcIcon:Loader;
	
	public function onRelease():Void
	{
		if (__toggle == true)
		{
			selected = !__selected;
		}
		
		super.onRelease();
	}
	
	public function onRollOver():Void
	{
		super.onRollOver();
		setState(OVER_STATE);
		invalidate();
	}
	
	public function onRollOut():Void
	{
		super.onRollOut();
		if (__selected == true)
		{
			setState(SELECTED_STATE);
		}
		else
		{
			setState(DEFAULT_STATE);
		}
		invalidate();
	}
	
	public function get textField():TextField
	{
		return __mcLabel;
	}
	
	//CORE METHODS/------------------------------------------
	
	//Constructor
	public function Button()
	{
		super();
		
		//trace("Button::constructor");
		
		focusEnabled		= true;
		tabEnabled			= true;
		tabChildren			= false;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		createTextField("__mcLabel", getNextHighestDepth(), 0, 0, 100, 100);
		__mcLabel.align 		= TextField.ALIGN_CENTER;
		__mcLabel.bold			= __bold;
		__mcLabel.multiline 	= __multiline;
		__mcLabel.wordWrap 		= __wordWrap;
		defaultTextFormat.align = "center";
		__mcLabel.setTextFormat(defaultTextFormat);
		__mcLabel.setNewTextFormat(defaultTextFormat);
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var iconExists:Boolean;
		
		var label_x:Number;
		

		if(__mcIcon == null)
		{
			iconExists = false;
		}
		else if(__mcIcon.contentPath == null || __mcIcon.contentPath == "")
		{
			iconExists = false;
		}
		else
		{
			iconExists = true;
		}
		
		// icon doesn't exist, center label
		if(iconExists == false)
		{
			
			// TODO: supporting centering, both horizontal and vertical
			if (__mcLabel.height > __height)
			{
					// text field is larger than container
					// FIXME
			}
						
			var targetY:Number = Math.max((__height / 2) - (__mcLabel.height / 2), 0);
			__mcLabel.move(0, targetY);
			__mcLabel.setSize(__width, __height);
		}
		else
		{

				
			if(__alignIcon == ALIGN_ICON_LEFT)
			{	
				__mcIcon.move(0, 0);
				label_x =__mcIcon.width;

				
			}
			else if(__alignIcon == ALIGN_ICON_CENTER)
			{
				__mcIcon.move(Math.round((__width / 2) - (__mcIcon.width / 2)), 
							  Math.round((__height / 2) - (__mcIcon.height / 2)));
			}
			else if(__alignIcon == ALIGN_ICON_RIGHT)
			{
				__mcIcon.move(width - __mcIcon.width, 0);
				__mcLabel.align = TextField.ALIGN_RIGHT
				label_x = __mcLabel.x;
			}
			
			__mcLabel.move(label_x, (__height / 2) - (__mcIcon.height / 2));
			__mcLabel.setSize(__width-__mcIcon.width, __height);
		}
		
		/*
		clear();
		lineStyle(0, 0x999999);
		beginFill(0xCCCCCC, 90);
		com.jxl.shuriken.utils.DrawUtils.drawBox(this, 0, 0, width, height);
		endFill();
		*/
	}
	
	public function measureText():Object
	{
		return __mcLabel.measureText();
	}
	
	private function onIconLoaded(pEvent:Object):Void
	{
		invalidate();
	}
	
	private function setState(pState:String):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("Button::setState, pState: " + pState);
		__lastState = __currentState;
		__currentState = pState;
	}
	
	public function setSelectionChangeCallback(scope:Object, func:Function):Void
	{
		if(scope == null)
		{
			delete __selectionChangeCallback;
			return;
		}
		__selectionChangeCallback = new Callback(scope, func);
	}
}
