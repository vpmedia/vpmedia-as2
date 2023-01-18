import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.utils.DateUtils;

import com.jxl.shuriken.controls.calendarclasses.CalendarBase;

class com.jxl.shuriken.controls.Calendar extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.Calendar";
	
	private var __cal:CalendarBase;
	private var __left_mc:MovieClip;
	private var __right_mc:MovieClip;
	private var __date_txt:TextField;
	private var __days_txt:TextField;
	
	public function Calendar()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__cal == null)
		{
			__cal = CalendarBase(createComponent(CalendarBase, "__cal"));
			__cal.setDateChangeCallback(this, onDateChange);
		}
		
		if(__left_mc == null)
		{
			__left_mc = createEmptyMovieClip("__left_mc", getNextHighestDepth());
			__left_mc.createTextField("t", 0, 0, 0, 60, 20);
			var ltxt:TextField = __left_mc.t;
			ltxt.selectable = false;
			ltxt.autoSize = "left";
			var ltf:TextFormat = new TextFormat();
			ltf.size = 9;
			ltf.color = 0x112ABB;
			ltxt.setNewTextFormat(ltf);
			ltxt.setTextFormat(ltf);
			ltxt.text = "<<";
			__left_mc.onRelease = function():Void
			{
				this._parent.__cal.lastMonth();
			};
		}
		
		if(__right_mc == null)
		{
			__right_mc = createEmptyMovieClip("__right_mc", getNextHighestDepth());
			__right_mc.createTextField("t", 0, 0, 0, 60, 20);
			var rtxt:TextField = __right_mc.t;
			rtxt.selectable = false;
			rtxt.autoSize = "left";
			var rtf:TextFormat = new TextFormat();
			rtf.size = 9;
			rtf.color = 0x112ABB;
			rtxt.setNewTextFormat(rtf);
			rtxt.setTextFormat(rtf);
			rtxt.text = ">>";
			__right_mc.onRelease = function():Void
			{
				this._parent.__cal.nextMonth();
			};
		}
		
		if(__date_txt == null)
		{
			__date_txt = createLabel("__date_txt");
			__date_txt.selectable = false;
			var dtf:TextFormat = new TextFormat();
			dtf.align = TextField.ALIGN_CENTER;
			dtf.bold = true;
			dtf.font = "Verdana";
			dtf.size = 11;
			dtf.color = 0x112ABB;
			__date_txt.setTextFormat(dtf);
			__date_txt.setNewTextFormat(dtf);
		}
		
		if(__days_txt == null)
		{
			__days_txt = createLabel("__days_txt");
			__days_txt.autoSize = "left";
			var dtf:TextFormat = __days_txt.getTextFormat();
			dtf.tabStops = [23, 46, 69, 92, 115, 138, 161];
			dtf.font = "EmbeddedVerdana";
			dtf.size = 11;
			__days_txt.embedFonts = true;
			__days_txt.setNewTextFormat(dtf);
			__days_txt.setTextFormat(dtf);
			__days_txt.text = "S\tM\tT\tW\tT\tF\tS";
		}
	}
	
	public function onLoad():Void
	{
		onDateChange();
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		// KLUDGE: hardcoded layouts are fun
		__left_mc._x = 9;
		__left_mc._y = 2;
		
		__right_mc._x = __width - 9 - __right_mc._width;
		__right_mc._y = 2;
		
		__date_txt.move(__left_mc._x + __left_mc._width, __left_mc._y);
		__date_txt.setSize(__width - __date_txt._x - (__right_mc._width + 9));
		
		__cal.move(9, 36);
		
		__days_txt.move(__cal.x + 4, __cal.y - __days_txt._height);
		
		clear();
		beginFill(0xC3D9FF);
		DrawUtils.drawRoundRect(this, 0, 0, __width, __height, 3);
		endFill();
		
		lineStyle(0, 0xA2BBDD);
		DrawUtils.drawBox(this, __cal.x - 1, __cal.y - 1, __cal.width + 1, __cal.height + 1);
		endFill();
	}
	
	private function onDateChange(event:Event):Void
	{
		callLater(this, updateTitle);
	}
	
	private function updateTitle():Void
	{
		__date_txt.text = DateUtils.getMonthName(__cal.currentDate) + " " + __cal.currentDate.getFullYear();
	}
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		__cal.setItemClickCallback(scope, func);
	}
	
	public function onIdle():Void
	{
		if(__left_mc != null)
		{
			__left_mc.removeMovieClip();
			delete __left_mc;
		}
		
		if(__right_mc != null)
		{
			__right_mc.removeMovieClip();
			delete __right_mc;
		}
		
		if(__date_txt != null)
		{
			__date_txt.removeTextField();
			delete __date_txt;
		}
		
		if(__days_txt != null)
		{
			__days_txt.removeTextField();
			delete __days_txt;
		}
	}
	
	public function onNonIdle():Void
	{
		callLater(this, createChildren);
		callLater(this, updateTitle);
		invalidate();
	}
}