import mx.utils.Delegate;

import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.controls.calendarclasses.CalendarDay;
import com.jxl.shuriken.core.MDArray;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.utils.LoopUtils;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.controls.calendarclasses.CalendarBase extends List
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.calendarclasses.CalendarBase";
	
	public static var EVENT_DATE_CHANGE:String = "dateChange";
	
	private var __currentDate:Date;
	private var __selectedDate:Date;
	private var __date_mdarray:MDArray;
	private var __color_mdarray:MDArray;
	private var __child_mdarray:MDArray;
	private var __childClass:Function;
	private var __weekendColor:Number 				= 0x99BBDD;
	private var __weekdayColor:Number 				= 0xAACCEE;
	private var __nextMonthWeekendColor:Number 		= 0xE8EEF7;
	private var __nextMonthWeekdayColor:Number		= 0xFFFFFF;
	private var __finishedDrawing:Boolean			= false;
	private var __lastDaySelected:CalendarDay;
	private var __itemClickCallback:Callback;
	private var __dateCallback:Callback;
	
	private var __loop_mc:MovieClip;
	private var __status_mc:MovieClip;
	
	// Delete these after onDateBuilderLoop
	private var __dateBuilder_lu:LoopUtils;
	private var __lastMonth:Date;
	private var __todayCopy:Date;
	private var __intoNextMonthFlag:Boolean;
	
	private var __draw_lu:LoopUtils;
	private var __size_lu:LoopUtils;
	private var __refresh_lu:LoopUtils;
	private var __colors_lu:LoopUtils;
	
	
	private var startTime:Number;
	
	public function get currentDate():Date { return __currentDate; }
	public function set currentDate(p_val:Date):Void
	{
		//trace("------------------");
		//trace("CalendarBase::currentDate setter, p_val: " + p_val);
		__currentDate = p_val;
		//startTime = getTimer();
		// TODO: fix this; for now, wax it
		deselectLastSelected();
		delete __lastDaySelected;
		
		//if(enabled == true) enabled = false;
		
		abortAllLoops();
		
		var rows:Number = 6;
		var cols:Number = 7;
		
		__lastMonth = DateUtils.clone(__currentDate);
		DateUtils.getLastMonth(__lastMonth);
		DateUtils.setEndOfMonth(__lastMonth);
		DateUtils.setFirstDayOfWeek(__lastMonth);
		
		__todayCopy = DateUtils.clone(__currentDate);
		DateUtils.setBeginningOfMonth(__todayCopy);
		
		__date_mdarray = new MDArray(rows, cols);
		__color_mdarray = new MDArray(rows, cols);
		
		__intoNextMonthFlag = false;
		
		if(__dateBuilder_lu != null)
		{
			__dateBuilder_lu.stopProcessing();
		}
		else
		{
			__dateBuilder_lu = new LoopUtils(getLoopMC());
		}
		//trace("----------------------");
		//trace("Date Builder loop...");
		showStatus();
		__status_mc.gotoAndStop("dates");
		//trace("__status_mc: " + __status_mc);
		__dateBuilder_lu.gridLoop(0,
									1,
									0,
									0,
									rows,
									cols,
									1,
									1,
									this,
									onDateBuilderLoop,
									onDateBuilderLoopDone);
		__dateCallback.dispatch(new Event(EVENT_DATE_CHANGE, this));
	}
	
	public function get selectedDate():Date { return __selectedDate; }
	public function set selectedDate(p_val:Date):Void
	{
		__selectedDate = p_val;
		if(__finishedDrawing == true)
		{
			if(__selectedDate != null)
			{
				callLater(this, refreshSetValues);
			}
			else
			{
				deselectLastSelected();
			}
		}
	}
	
	public function CalendarBase()
	{
		super();
		
		__childClass						= CalendarDay;
		__childSetValueFunction 			= refreshSetValue;
		__childSetValueScope				= this;
		__autoSizeToChildren 				= true;
	}
	
	public function onLoad():Void
	{
		if(__currentDate == null) 			currentDate = new Date();
	}
	
	/*
	private function setEnabled(p_enabled:Boolean):Void
	{
		if(p_enabled == true)
		{
			tabChildren = true;
		}
		else
		{
			Selection.setFocus(null);
			tabChildren = false;
		}
	}
	*/
	
	private function getLoopMC():MovieClip
	{
		var d:Number;
		var ref_mc:MovieClip;
		if(__loop_mc == null)
		{
			var process_depth:Number = getNextNonChildDepth();
			if(process_depth > -1)
			{
				__loop_mc = createEmptyMovieClip("__loop_mc", process_depth);
				d = __loop_mc.getNextHighestDepth();
				ref_mc = __loop_mc.createEmptyMovieClip("l" + d, d);
				return ref_mc;
			}
			else
			{
				// Oh, sshhhhii... *BOOM!!!*
				// TODO: throw an error or something indicating
				// we're all dead
				return null;
			}
		}
		else
		{
			d = __loop_mc.getNextHighestDepth();
			ref_mc = __loop_mc.createEmptyMovieClip("l" + d, d);
			return ref_mc;
		}
	}
	
	private function onDateBuilderLoop(p_currentVal:Number, p_currentRow:Number, p_currentCol:Number):Void
	{
		var dateValue:Number;
		var theDate:Date;
		var r:Number = p_currentRow;
		var c:Number = p_currentCol;
		
		//trace("----------------------");
		//trace("onDateBuilderLoop r: " + r + ", c: " + c);
		//trace("__status_mc: " + __status_mc);
		
		if(r == 0)
		{
			var lastMonthYesterday:Date = DateUtils.clone(__lastMonth);
			lastMonthYesterday.setDate(lastMonthYesterday.getDate() - 1);
			if(DateUtils.isEndOfMonth(lastMonthYesterday) == false)
			{
				dateValue = __lastMonth.getDate();
				theDate = DateUtils.clone(__lastMonth);
				__lastMonth.setDate(__lastMonth.getDate() + 1);
				
				if(c == 0 || c == 6)
				{
					__color_mdarray.setCell(r, c, __nextMonthWeekendColor);
				}
				else
				{
					__color_mdarray.setCell(r, c, __nextMonthWeekdayColor);
				}
				
			}
			else
			{
				dateValue = __todayCopy.getDate();
				theDate = DateUtils.clone(__todayCopy);
				__todayCopy.setDate(__todayCopy.getDate() + 1);
				
				if(c == 0 || c == 6)
				{
					__color_mdarray.setCell(r, c, __weekendColor);
				}
				else
				{
					__color_mdarray.setCell(r, c, __weekdayColor);
				}
				
			}
		}
		// this month or next month
		else
		{
			if(__intoNextMonthFlag == false)
			{
				var yesterday:Date = DateUtils.clone(__todayCopy);
				yesterday.setDate(yesterday.getDate() - 1);
				var isYesterdayCurrentMonth:Boolean = yesterday.getMonth() == __todayCopy.getMonth();
				var isYesterdayThisMonth:Boolean = yesterday.getMonth() == __currentDate.getMonth();
				var isYesterdayEndOfMonth:Boolean = DateUtils.isEndOfMonth(yesterday);
				
				// true, true, false = go
				// false, true, true = next month
				// false, false, true = go
				
				var isItNextMonth:Boolean = false;
				if(isYesterdayCurrentMonth == false)
				{
					if(isYesterdayThisMonth == true)
					{
						isItNextMonth = true;
					}
				}
				
				if(isItNextMonth == false)
				{
					
					if(c == 0 || c == 6)
					{
						__color_mdarray.setCell(r, c, __weekendColor);
					}
					else
					{
						__color_mdarray.setCell(r, c, __weekdayColor);
					}
				}
				else
				{
					__intoNextMonthFlag = true;
					
					
					if(c == 0 || c == 6)
					{
						__color_mdarray.setCell(r, c, __nextMonthWeekendColor);
					}
					else
					{
						__color_mdarray.setCell(r, c, __nextMonthWeekdayColor);
					}
				}
			}
			else
			{
				
				if(c == 0 || c == 6)
				{
					__color_mdarray.setCell(r, c, __nextMonthWeekendColor);
				}
				else
				{
					__color_mdarray.setCell(r, c, __nextMonthWeekdayColor);
				}
			}
			dateValue = __todayCopy.getDate();
			theDate = DateUtils.clone(__todayCopy);
			__todayCopy.setDate(__todayCopy.getDate() + 1);
		}
		
		__date_mdarray.setCell(r, c, theDate);

	}
	
	private function onDateBuilderLoopDone():Void
	{
		//DebugWindow("----------------------");
		//DebugWindow("Date Builder done.");
		
		__dateBuilder_lu.destroy();
		delete __dateBuilder_lu;
		delete __lastMonth;
		delete __todayCopy;
		delete __intoNextMonthFlag;
		
		//setSelectedDate();
		//invalidate();

		//[gb] do we need this?
		//selectedDate = selectedDate;
		//invalidate();
		
		callLater(this, draw);
	}
	
	private function draw():Void
	{
		if(__dateBuilder_lu) return;
		
		//startTime = getTimer();
		if(__finishedDrawing == true)
		{
			callLater(this, refreshSetValues);
			return;
		}
		
		removeAllChildren();
		
		showStatus();
		__status_mc.gotoAndStop("drawing");
		
		if(__date_mdarray.length == 0 || __date_mdarray == null) return;
		__child_mdarray = new MDArray(__date_mdarray.rows, __date_mdarray.cols);
		var i:Number = 0;
		var child:UIComponent = createChildAt(i, __childClass);
		child._visible = false;
		child.data = {r: 0, c: 0};
		Button(child).setSelectionChangeCallback(this, onDaySelectionChanged);
		__child_mdarray.setCell(0, 0, child);
		
		if(__autoSizeToChildren == true)
		{
			__columnWidth = child.width;
			calculateHorizontalPageSize();
			__colWChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
		
			__rowHeight = child.height;
			calculateVerticalPageSize();
			__rowHChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));
		}
		
		setupChild(child);
		
		if(__draw_lu != null)
		{
			__draw_lu.stopProcessing();
		}
		else
		{
			__draw_lu = new LoopUtils(getLoopMC());
		}
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("Draw loop...");
		__draw_lu.gridLoop(0,
							1,
							0,
							1,
							__date_mdarray.rows,
							__date_mdarray.cols,
							1,
							1,
							this,
							drawNext,
							finishedDrawing);
		
	}
	
	private function drawNext(p_val:Number, p_currentRow:Number, p_currentCol:Number):Void
	{
		var child:UIComponent = createChildAt(++p_val, __childClass);
		child._visible = false;
		child.data = {r: p_currentRow, c: p_currentCol};
		CalendarDay(child).setSelectionChangeCallback(this, onDaySelectionChanged);
		__child_mdarray.setCell(p_currentRow, p_currentCol, child);
		setupChild(child);
	}
	
	private function finishedDrawing():Void
	{
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("Draw done.");
		
		__draw_lu.destroy();
		delete __draw_lu;
		__finishedDrawing = true;
		callLater(this, redraw);
	}
	
	private function redraw():Void
	{
		if(__finishedDrawing == false) return;
		
		if(__draw_lu || __dateBuilder_lu) return;
		
		super.redraw();
		
		__status_mc.gotoAndStop("sizing");
		
		if(__size_lu != null)
		{
			__size_lu.stopProcessing();
		}
		else
		{
			__size_lu = new LoopUtils(getLoopMC());
		}
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("Size loop...");
		__size_lu.gridLoop(0,
							1,
							0,
							0,
							__date_mdarray.rows,
							__date_mdarray.cols,
							1,
							1,
							this,
							sizeNext,
							finishedSizing);
	}
	
	private function sizeNext(p_val:Number, p_currentRow:Number, p_currentCol:Number):Void
	{
		var child:UIComponent = getChildAt(p_val);
		
		var theX:Number = (__columnWidth + __childHorizontalMargin) * (p_currentCol);
		var theY:Number = (__rowHeight + __childVerticalMargin) * (p_currentRow);
		
		child.move(theX, theY);
	}
	
	private function finishedSizing():Void
	{
		//trace("----------------------");
		//trace("CalendarBase::finishedSizing");
		//trace("Size done.");
		__size_lu.destroy();
		delete __size_lu;
		__status_mc.gotoAndStop("done");
		callLater(this, hideStatus);
		callLater(this, refreshSetValues);
	}
	
	public function lastMonth():Void
	{
		var todayCopy:Date = DateUtils.clone(__currentDate);
		DateUtils.lastMonth(todayCopy);
		currentDate = todayCopy;
	}
	
	public function nextMonth():Void
	{
		var todayCopy:Date = DateUtils.clone(__currentDate);
		DateUtils.nextMonth(todayCopy);
		currentDate = todayCopy;
	}
	
	public function refreshSetValues():Void
	{
		if(__size_lu) return;
		
		//if(enabled == true) enabled = false;
		
		if(__refresh_lu != null)
		{
			__refresh_lu.stopProcessing();
		}
		else
		{
			__refresh_lu = new LoopUtils(getLoopMC());
		}
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("Refresh loop...");
		
		__refresh_lu.gridLoop(0,
								1,
								0,
								0,
								__date_mdarray.rows,
								__date_mdarray.cols,
								1,
								1,
								this,
								nextRefreshSetValue,
								finishedRefreshing);
	}
	
	private function nextRefreshSetValue(p_val:Number, p_currentRow:Number, p_currentCol:Number):Void
	{
		var item = __date_mdarray.getCell(p_currentRow, p_currentCol);
		var theDate:Date = item;
		var child:UIComponent = getChildAt(p_val);
		child._visible = true;
		__childSetValueFunction.call(__childSetValueScope, child, p_val, theDate);
	}
	
	private function finishedRefreshing():Void
	{
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("Refresh done.");
		__refresh_lu.destroy();
		delete __refresh_lu;
		//callLater(this, refreshColors);
		//if(enabled == false) enabled = true;
		hideStatus();
		//if(__finishedDrawing == true)
		//{
			//var ct:Number = getTimer();
			//var et:Number = (ct - startTime) / 1000;
			//_root.debug("elapsed time: " + et);
			//_root.doneBuilding();
		//}
	}
	
	public function refreshSetValue(p_child:UIComponent, p_index:Number, p_item:Object):Void
	{
		CalendarDay(p_child).label = p_item.getDate();
		var val = p_item;
		var theDate:Date = val;
		if(DateUtils.isEqualByDate(new Date(), theDate) == true)
		{
			CalendarDay(p_child).isToday = true;
		}
		else
		{
			CalendarDay(p_child).isToday = false;
		}
		
		var isSelectedDate:Boolean = DateUtils.isEqualByDate(__selectedDate, theDate);
		//DebugWindow.debug("----------------------");
		//DebugWindow.debug("__selectedDate: " + __selectedDate + ", theDate: " + theDate);
		//DebugWindow.debug("isSelectedDate: " + isSelectedDate);
		//__selectedDate: Thu Dec 21 16:54:38 GMT-0500 2006, theDate: Mon Dec 4 16:54:23 GMT-0500 2006
		//isSelectedDate: false
		//You selected Mon Dec 4 16:54:23 GMT-0500 2006
		if(isSelectedDate == true)
		{
			//DebugWindow.debug("A match!");
			setCalendarDaySelected(CalendarDay(p_child));
		}
		else
		{
			//CalendarDay(p_child).removeEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			//CalendarDay(p_child).selected = false;
			//CalendarDay(p_child).addEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			CalendarDay(p_child).setSelectedNoEvent(false);
		}
		
		var obj:Object = p_child.data;
		var bgColor = __color_mdarray.getCell(obj.r, obj.c);
		if(CalendarDay(p_child).selected == false)
		{
			CalendarDay(p_child).background = true;
			CalendarDay(p_child).backgroundColor = bgColor;
		}
		
		CalendarDay(p_child).invalidate();
	}
	
	/*
	public function refreshColors():Void
	{
		if(__refresh_lu) return;
		
		if(__colors_lu != null)
		{
			__colors_lu.stopProcessing();
		}
		else
		{
			__colors_lu = new LoopUtils(getLoopMC());
		}
		DebugWindow("----------------------");
		DebugWindow("Colors loop...");
		__colors_lu.gridLoop(0,
								1,
								0,
								0,
								__date_mdarray.rows,
								__date_mdarray.cols,
								1,
								1,
								this,
								colorNext,
								finishedColoring);
	}
	
	private function colorNext(p_val:Number, p_currentRow:Number, p_currentCol:Number):Void
	{
		var bgColor = __color_mdarray.getCell(p_currentRow, p_currentCol);
		var child:UIComponent = getChildAt(p_val);
		if(CalendarDay(child).selected == false)
		{
			CalendarDay(child).background = true;
			CalendarDay(child).backgroundColor = bgColor;
		}
	}
	
	private function finishedColoring():Void
	{
		DebugWindow("----------------------");
		DebugWindow("Colors done.");
		__colors_lu.destroy();
		delete __colors_lu;
		if(__finishedDrawing == true)
		{
			var ct:Number = getTimer();
			var et:Number = (ct - startTime) / 1000;
			_root.debug("elapsed time: " + et);
		}
	}
	*/
	
	private function onDaySelectionChanged(p_event:ShurikenEvent):Void
	{
		//trace("---------------");
		//trace("CalendarBase::onDaySelectionChanged");
		
		if(__dateBuilder_lu || __draw_lu || __size_lu || __refresh_lu || __colors_lu) return;
		setCalendarDaySelected(CalendarDay(p_event.target));
	}
	
	private function abortAllLoops():Void
	{
		__dateBuilder_lu.destroy();
		delete __dateBuilder_lu;
		
		__draw_lu.destroy();
		delete __draw_lu;
		
		__size_lu.destroy();
		delete __size_lu;
		
		__refresh_lu.destroy();
		delete __refresh_lu;
		
		__colors_lu.destroy();
		delete __colors_lu;
	}
	
	private function setCalendarDaySelected(p_tar:CalendarDay):Void
	{
		//trace("--------------");
		//trace("CalendarBase::setCalendarDaySelected");
		//DebugWindow.debug("p_tar: " + p_tar);
		//DebugWindow.debug("__lastDaySelected: " + __lastDaySelected);
		
		deselectLastSelected();
		
		var obj:Object = p_tar.data;
		// HACK: casting hack
		var theDate = __date_mdarray.getCell(obj.r, obj.c);
		//trace("You selected " + theDate);
		__selectedDate = theDate;
		__lastDaySelected = p_tar;
		
		//trace("p_tar.selected: " + p_tar.selected);
		if(p_tar.selected == false)
		{
			//p_tar.removeEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			//p_tar.selected = true;
			//p_tar.addEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			p_tar.setSelectedNoEvent(true);
		}
	}
	
	private function deselectLastSelected():Void
	{
		if(__lastDaySelected != undefined)
		{
			//__lastDaySelected.removeEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			//__lastDaySelected.selected = false;
			//__lastDaySelected.addEventListener(ShurikenEvent.SELECTION_CHANGED, __daySelectionChanged);
			__lastDaySelected.setSelectedNoEvent(false);
			var bgColor = __color_mdarray.getCell(__lastDaySelected.data.r, __lastDaySelected.data.c);
			__lastDaySelected.background = true;
			__lastDaySelected.backgroundColor = bgColor;
		}
	}
	
	private function setSelectedDate():Void
	{
		//DebugWindow.debug("------------------");
		//DebugWindow.debug("CalendarBase::setSelectedDate");
		//DebugWindow.debug("__finishedDrawing: " + __finishedDrawing);
		
		if(__finishedDrawing == true)
		{
			if(__selectedDate != null)
			{
				callLater(this, refreshSetValues);
			}
			else
			{
				deselectLastSelected();
			}
		}
	}
	
	/*
	private var __currentSelRow:Number;
	private var __currentSelCol:Number;
	
	private function findSelDate():Void
	{
		//DebugWindow("------------------");
		//DebugWindow("CalendarBase::findSelDate");
		//DebugWindow("__currentSelRow: " + __currentSelRow + ", __currentSelCol: " + __currentSelCol);
		if(__currentSelRow + 1 <= __date_mdarray.rows)
		{
			if(__currentSelCol + 1 <= __date_mdarray.cols)
			{
				var item = __date_mdarray.getCell(__currentSelRow, __currentSelCol);
				var theDate:Date = item;
				//if(__selectedDate == theDate)
				if(DateUtils.isEqualByDate(__selectedDate, theDate) == true)
				{
					//DebugWindow("Found a match!");
					var child:CalendarDay = CalendarDay(__child_mdarray.getCell(__currentSelRow, __currentSelCol));
					setCalendarDaySelected(child);
					return;
				}
				__currentSelCol++;
				callLater(this, findSelDate);
			}
			else
			{
				__currentSelCol = 0;
				if(__currentSelRow + 1 < __date_mdarray.rows)
				{
					__currentSelRow++;
					var item = __date_mdarray.getCell(__currentSelRow, __currentSelCol);
					var theDate:Date = item;
					//if(__selectedDate == theDate)
					if(DateUtils.isEqualByDate(__selectedDate, theDate) == true)
					{
						//DebugWindow("Found a match!");
						var child:CalendarDay = CalendarDay(__child_mdarray.getCell(__currentSelRow, __currentSelCol));
						setCalendarDaySelected(child);
						return;
					}
					callLater(this, findSelDate);
				}
				else
				{
					delete __currentSelRow;
					delete __currentSelCol;
				}
				
			}
		}
		else
		{
			delete __currentSelRow;
			delete __currentSelCol;
		}
	}
	*/
	
	private function showStatus():Void
	{
		if(__status_mc == null)
		{
			//DebugWindow("__width: " + __width);
			//DebugWindow("__height: " + __height);
			//DebugWindow("__status_mc._width: " + __status_mc._width);
			__status_mc = attachMovie("CalendarLoading", "__status_mc", getNextHighestDepth());
			// KLUDGE: hardcoded values
			__status_mc._x = Math.round((175 / 2) - (__status_mc._width / 2));
			__status_mc._y = Math.round((114 / 2) - (__status_mc._height / 2));
		}
	}
	
	private function hideStatus():Void
	{
		//trace("----------------");
		//trace("CalendarBase::hideStatus");
		if(__status_mc != null)
		{
			__status_mc.removeMovieClip();
			delete __status_mc;
		}
	}
	
	// override
	public function setupChild(p_child:UIComponent):Void
	{
		//CalendarDay(p_child).addEventListener(ShurikenEvent.RELEASE, __dayClickedDelegate);
		//CalendarDay(p_child).buttonRelease = __dayClickedDelegate;
		CalendarDay(p_child).setReleaseCallback(this, onListItemClicked);
	}
	
	// override; ButtonList is using base dataProvider; we aren't
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		//trace("---------------");
		//trace("CalendarBase::onListItemClicked");
		var index:Number = getChildIndex(UIComponent(p_event.target));
		//var item:Object = __dataProvider.getItemAt(index);
		var o:Object = UIComponent(p_event.target).data;
		var item:Object = __date_mdarray.getCell(o.r, o.c);
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		
		//trace("child: " + event.child);
		//trace("item: " + event.item);
		//trace("index: " + event.index);
		
		__itemClickCallback.dispatch(event);
	}
	
	
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		__itemClickCallback = new Callback(scope, func);
	}
	
	public function setDateChangeCallback(scope:Object, func:Function):Void
	{
		__dateCallback = new Callback(scope, func);
	}
}