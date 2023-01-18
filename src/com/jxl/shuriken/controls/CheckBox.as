import com.jxl.shuriken.controls.Button;

class com.jxl.shuriken.controls.CheckBox extends Button
{
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.CheckBox";
	
	private var __mcCheckBoxOutline:MovieClip;
	private var __mcCheckBoxCenter:MovieClip;
	
	public function CheckBox()
	{
		super();
		
		Key.addListener(this);
		
		__toggle 		= true;
		
		focusEnabled 	= true;
		tabEnabled 		= true;
		tabChildren 	= false;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		// overwrite properties
		__mcLabel.align 		= TextField.ALIGN_LEFT;
		__mcLabel.bold			= false;
		__mcLabel.multiline 	= true;
		__mcLabel.wordWrap 		= true;
		var fmt:TextFormat = __mcLabel.getTextFormat();
		fmt.align 				= TextField.ALIGN_LEFT;
		__mcLabel.setTextFormat(fmt);
		__mcLabel.setNewTextFormat(fmt);
		
		// TODO: below should be 2 factories taht create the MovieClip's;
		// that way, easier to extend
		__mcCheckBoxOutline = attachMovie("CheckBoxOutline", "__mcCheckBoxOutline", getNextHighestDepth());
		__mcCheckBoxCenter = attachMovie("CheckBoxCenter", "__mcCheckBoxCenter", getNextHighestDepth());
	}
	
	// overwriting
	private var drawButton:Function;
	
	private function redraw():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("CheckBox::draw, __currentState: " + __currentState);
		//DebugWindow.debug("selected: " + selected);
		switch (__currentState)
		{
				
			case DEFAULT_STATE:
				__mcCheckBoxCenter._visible = false;
				break;
				
			case SELECTED_STATE:
				__mcCheckBoxCenter._visible = true;
				break;
				
			case OVER_STATE:
				break;
		}
		
		__mcCheckBoxOutline._x = 0;
		__mcCheckBoxOutline._y = 0;
		var centerBiggerThanOutline:Boolean;
		
		if(__mcCheckBoxOutline._width > __mcCheckBoxCenter._width && __mcCheckBoxOutline._height > __mcCheckBoxCenter._height)
		{
			__mcCheckBoxCenter._x = __mcCheckBoxOutline._x + (__mcCheckBoxOutline._width / 2) - (__mcCheckBoxCenter._width / 2);
			__mcCheckBoxCenter._y = __mcCheckBoxOutline._y + (__mcCheckBoxOutline._height / 2) - (__mcCheckBoxCenter._height / 2);
			centerBiggerThanOutline = false;
		}
		else
		{
			__mcCheckBoxCenter._x = 0;
			__mcCheckBoxCenter._y = 0;
			centerBiggerThanOutline = true;
		}
		
		var theLeft:Number;
		if(centerBiggerThanOutline == false)
		{
			theLeft = __mcCheckBoxOutline._x + __mcCheckBoxOutline._width;
		}
		else
		{
			theLeft = __mcCheckBoxCenter._x + __mcCheckBoxCenter._width;
		}
		
		var iconExists:Boolean;
		
		// icon doesn't exist, center label
		if(__mcIcon == null)
		{
			iconExists = false;
		}
		// icon exists, but his content is blank
		else if(__mcIcon.contentPath == null || __mcIcon.contentPath == "")
		{
			iconExists = false;
		}
		else
		{
			iconExists = true;
		}

		var textMargin:Number = 4;
		if(iconExists == false)
		{
			
			if (__mcLabel.height > __height)
			{
				// FIXME
			}
			
			__mcLabel.move(theLeft + textMargin, 0);
			__mcLabel.setSize(__width - __mcLabel.x, height);
		}
		else
		{
			__mcIcon.move(theLeft + textMargin, 0);
			__mcLabel.move(__mcIcon.x + __mcIcon.width + textMargin, 0);
			__mcLabel.setSize(__width - __mcLabel.x, height);
		}
		
	}
	
}