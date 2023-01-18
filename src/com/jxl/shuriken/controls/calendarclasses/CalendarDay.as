import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.controls.calendarclasses.CalendarDay extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.calendarclasses.CalendarDay";
	
	public var isToday:Boolean 				= false;
	public var background:Boolean			= false;
	public var label:String					= "";
	public var backgroundColor:Number		= 0xFFFFFF;
	public var selected:Boolean				= false;
	
	private var __selectionChangeCallback:Callback;
	private var __releaseCallback:Callback;
	
	private var __border_mc:MovieClip;
	private var __txt:TextField;
	
	public function CalendarDay()
	{
		super();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__txt == null)
		{
			__txt = createLabel("__txt");
			__txt.background = true;
			__txt.border = true;
			var fmt:TextFormat = __txt.getTextFormat();
			fmt.align = TextField.ALIGN_CENTER;
			__txt.setTextFormat(fmt);
			__txt.setNewTextFormat(fmt);
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		if(isToday == true)
		{
			if(__border_mc == null) __border_mc = createEmptyMovieClip("__border_mc", getNextHighestDepth());
			__border_mc.lineStyle(2, 0x660000);
			DrawUtils.drawBox(__border_mc, 0, 0, __width, __height);
			__border_mc.endFill();
		}
		else
		{
			if(__border_mc != null)
			{
				__border_mc.removeMovieClip();
				delete __border_mc;
			}
		}
		  
		__txt.text = label;
		
		if(selected == true)
		{
			__txt.borderColor = 0x224466;
		}
		else
		{
			__txt.borderColor = backgroundColor;
		}
		
		if(background == true)
		{
			__txt.backgroundColor = backgroundColor;
		}
		else
		{
			__txt.backgroundColor = __txt.borderColor;
		}
		
		__txt._width = __width - 1;
		__txt._height = __height - 1;
			
	}
	
	public function setSelectedNoEvent(bool:Boolean):Void
	{
		selected = bool;
		invalidate();
	}
	
	public function onRelease():Void
	{
		setSelected(!selected);
		__releaseCallback.dispatch(new ShurikenEvent(ShurikenEvent.RELEASE, this));
		invalidate();
	}
	
	public function setSelected(bool:Boolean):Void
	{
		selected = bool;
		__selectionChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.SELECTION_CHANGED, this));
	}
	
	public function setSelectionChangeCallback(scope:Object, func:Function):Void
	{
		__selectionChangeCallback = new Callback(scope, func);
	}
	
	public function setReleaseCallback(scope:Object, func:Function):Void
	{
		__releaseCallback = new Callback(scope, func);
	}
}