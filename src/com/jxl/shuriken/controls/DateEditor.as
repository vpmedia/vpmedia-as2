import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.NumericStepper;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.shuriken.controls.DateEditor extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.DateEditor";
	
	public static var FIELD_YEAR:Number 						= 1;
	public static var FIELD_YEAR_MONTH:Number 					= 2;
	public static var FIELD_YEAR_MONTH_DAY:Number 				= 3;
	public static var FIELD_YEAR_MONTH_DAY_HOUR:Number 			= 4;
	public static var FIELD_YEAR_MONTH_DAY_HOUR_MIN:Number 		= 5;
	public static var FIELD_DAY_HOUR_MIN:Number 				= 6;
	
	private var __currentDate:Date;
	private var __currentDateDirty:Boolean						= false;
	private var __fieldType:Number 								= 3;
	private var __currentChild:Number;
	
	private var __year_lbl:TextField;
	private var __year_nms:NumericStepper;
	private var __month_lbl:TextField;
	private var __month_nms:NumericStepper;
	private var __day_lbl:TextField;
	private var __day_nms:NumericStepper;
	private var __hour_lbl:TextField;
	private var __hour_nms:NumericStepper;
	private var __min_lbl:TextField;
	private var __min_nms:NumericStepper;
	
	public function get fieldType():Number { return __fieldType; }
	public function set fieldType(p_val:Number):Void
	{
		__fieldType = p_val;
		callLater(this, createChildren);
	}
	
	public function get currentDate():Date { return __currentDate; }
	public function set currentDate(p_val:Date):Void
	{
		__currentDate = p_val;
		__year_nms.value 		= __currentDate.getFullYear();
		__month_nms.value 		= __currentDate.getMonth() + 1;
		__day_nms.value 		= __currentDate.getDate();
		__hour_nms.value 		= __currentDate.getHours();
		__min_nms.value 		= __currentDate.getMinutes();
		
		//trace("-----------------");
		//trace("DateEditor::currentDate");
		//trace("__currentDate.getFullYear(): " + __currentDate.getFullYear());
		//trace("__year_nms.value: " + __year_nms.value);
		//trace("__month_nms.value: " + __month_nms.value);
		//trace("__day_nms.value: " + __day_nms.value);
		//trace("__hour_nms.value: " + __hour_nms.value);
		//trace("__min_nms.value: " + __min_nms.value);
	}
	
	public function DateEditor()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(isConstructing == false)
		{
			var clipArray:Array = ["__year_lbl",
								   "__year_nms",
								   "__month_lbl",
								   "__month_nms",
								   "__day_lbl",
								   "__day_nms",
								   "__hour_lbl",
								   "__hour_nms",
								   "__min_lbl",
								   "__min_nms"];
			var i:Number = clipArray.length;
			while(i--)
			{
				this[clipArray[i]].removeMovieClip();
				delete this[clipArray[i]];
			}
		}
		
		_visible = false;
		__currentChild = 0;
		callLater(this, buildNext);
	}
	
	private function buildNext():Void
	{
		__currentChild++;
		
		if(__fieldType != FIELD_DAY_HOUR_MIN)
		{
		
			if(__year_lbl == null)
			{
				__year_lbl = createLabel("__year_lbl");
				__year_lbl.text = "Year";
			}
			
			if(__currentChild == 1)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__year_nms == null)
			{
				__year_nms = NumericStepper(createComponent(NumericStepper, "__year_nms"));
				__year_nms.setChangeCallback(this, onValueChange);
				__year_nms.setMinMax(1000, 9999);
			}
			
			if(__fieldType == FIELD_YEAR)
			{
				doneBuilding();
				return;
			}
			
			if(__currentChild == 2)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__month_lbl == null)
			{
				__month_lbl = createLabel("__month_lbl");
				__month_lbl.text = "Month";
			}
			
			if(__currentChild == 3)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__month_nms == null)
			{
				__month_nms = NumericStepper(createComponent(NumericStepper, "__month_nms"));
				__month_nms.setChangeCallback(this, onValueChange);
				__month_nms.setMinMax(1, 12);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH)
			{
				doneBuilding();
				return;
			}
			
			if(__currentChild == 4)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__day_lbl == null)
			{
				__day_lbl = createLabel("__day_lbl");
				__day_lbl.text = "Day";
			}
			
			if(__currentChild == 5)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__day_nms == null)
			{
				__day_nms = NumericStepper(createComponent(NumericStepper, "__day_nms"));
				__day_nms.setChangeCallback(this, onValueChange);
				// TODO: this should keep track of the month instead of being hardcoded
				// to 31; some months have 28 and 30 days, not 31
				__day_nms.setMinMax(1, 31);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH_DAY)
			{
				doneBuilding();
				return;
			}
			
			if(__currentChild == 6)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__hour_lbl == null)
			{
				__hour_lbl = createLabel("__hour_lbl");
				__hour_lbl.text = "Hour";
			}
			
			if(__currentChild == 7)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__hour_nms == null)
			{
				__hour_nms = NumericStepper(createComponent(NumericStepper, "__hour_nms"));
				__hour_nms.setChangeCallback(this, onValueChange);
				__hour_nms.setMinMax(0, 23);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH_DAY_HOUR)
			{
				doneBuilding();
				return;
			}
			
			if(__currentChild == 8)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__min_lbl == null)
			{
				__min_lbl = createLabel("__min_lbl");
				__min_lbl.text = "Minute";
			}
			
			if(__currentChild == 9)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__min_nms == null)
			{
				__min_nms = NumericStepper(createComponent(NumericStepper, "__min_nms"));
				__min_nms.setChangeCallback(this, onValueChange);
				__min_nms.setMinMax(0, 59);
			}
			
			doneBuilding();
		}
		else
		{
			// KLUDGE: for now, assumes __fieldType is FIELD_DAY_HOUR_MIN
			if(__day_lbl == null)
			{
				__day_lbl = createLabel("__day_lbl");
				__day_lbl.text = "Day";
			}
			
			if(__currentChild == 1)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__day_nms == null)
			{
				__day_nms = NumericStepper(createComponent(NumericStepper, "__day_nms"));
				__day_nms.setChangeCallback(this, onValueChange);
				// TODO: this should keep track of the month instead of being hardcoded
				// to 31; some months have 28 and 30 days, not 31
				__day_nms.setMinMax(1, 31);
			}
			
			if(__currentChild == 2)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__hour_lbl == null)
			{
				__hour_lbl = createLabel("__hour_lbl");
				__hour_lbl.text = "Hour";
			}
			
			if(__currentChild == 3)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__hour_nms == null)
			{
				__hour_nms = NumericStepper(createComponent(NumericStepper, "__hour_nms"));
				__hour_nms.setChangeCallback(this, onValueChange);
				__hour_nms.setMinMax(0, 23);
			}
			
			if(__currentChild == 4)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__min_lbl == null)
			{
				__min_lbl = createLabel("__min_lbl");
				__min_lbl.text = "Minute";
			}
			
			if(__currentChild == 5)
			{
				callLater(this, buildNext);
				return;
			}
			
			if(__min_nms == null)
			{
				__min_nms = NumericStepper(createComponent(NumericStepper, "__min_nms"));
				__min_nms.setChangeCallback(this, onValueChange);
				__min_nms.setMinMax(0, 59);
			}
			
			doneBuilding();
		}
	}
	
	private function doneBuilding():Void
	{
		delete __currentChild;
		if(__currentDate == null)
		{
			currentDate = new Date();
		}
		else
		{
			currentDate = currentDate;
		}
		invalidate();
	}
	
	
	private function redraw():Void
	{
		if(__currentChild != null) return;
		
		_visible = true;
		
		super.redraw();
		
		var margin:Number = 2;
	
		__year_lbl.move(0, 0);
		__year_lbl.setSize(40, 16);
		__year_nms.move(__year_lbl._x, __year_lbl._y + __year_lbl._height + 2);
		__year_nms.setSize(40, __year_nms.height);
		
		__month_lbl.move(__year_lbl._x + __year_lbl._width + margin, __year_lbl._y);
		__month_lbl.setSize(40, 16);
		__month_nms.move(__month_lbl._x, __month_lbl._y + __month_lbl._height + 2);
		
		__day_lbl.move(__month_lbl._x + __month_lbl._width + margin, __month_lbl._y);
		__day_lbl.setSize(40, 16);
		__day_nms.move(__day_lbl._x, __day_lbl._y + __day_lbl._height + margin);
		
		__hour_lbl.move(__year_nms._x, __year_nms._y + __year_nms._height + margin);
		__hour_lbl.setSize(40, 16);
		__hour_nms.move(__hour_lbl._x, __hour_lbl._y + __hour_lbl._height + margin);
		
		__min_lbl.move(__hour_lbl._x + __hour_lbl._width + margin, __hour_lbl._y);
		__min_lbl.setSize(40, 16);
		__min_nms.move(__min_lbl._x, __min_lbl._y + __min_lbl._height + margin);
	}
	
	private function onValueChange(p_event:ShurikenEvent):Void
	{
		switch(p_event.target)
		{
			case __year_nms:
				__currentDate.setFullYear(__year_nms.value);
				break;
			
			case __month_nms:
				__currentDate.setMonth(__month_nms.value - 1);
				break;
			
			case __day_nms:
				__currentDate.setDate(__day_nms.value);
				break;
			
			case __hour_nms:
				__currentDate.setHours(__hour_nms.value);
				break;
			
			case __min_nms:
				__currentDate.setMinutes(__min_nms.value);
				break;
		}
	}
	
	
}