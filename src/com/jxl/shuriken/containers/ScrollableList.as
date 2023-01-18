import mx.effects.Tween;
import mx.transitions.easing.Strong;
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ButtonList;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.managers.TweenManager;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;

[InspectableList("scrollSpeed", "direction", "showButtons")]
class com.jxl.shuriken.containers.ScrollableList extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.ScrollableList";
	
	private static var DEPTH_PREV_SCROLL_BUTTON:Number = 3;
	private static var DEPTH_NEXT_SCROLL_BUTTON:Number = 4;
	
	[Inspectable(type="Number", defaultValue=500, name="Scroll Speed")]
	public var scrollSpeed:Number = 500; // milliseconds
	
	[Inspectable(type="List", enumeration="horizontal,vertical", name="Direction")]
	public function get direction():String { return __direction; }
	
	public function set direction(pVal:String):Void
	{
		if(pVal != __direction)
		{
			__direction = pVal;
			__mcList.direction = __direction;
			invalidate();
		}
	}
	
	public function get horizontalPageSize():Number { return __horizontalPageSize; }
	
	public function get verticalPageSize():Number { return __verticalPageSize; }
	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(pClass:Function):Void
	{
		__childClass = pClass;
		__mcList.childClass = pClass;
	}

	public function get childSetValueScope():Object { return __childSetValueScope; }
	
	public function set childSetValueScope(pScope:Object):Void
	{
		__childSetValueScope = pScope;
		__mcList.childSetValueScope = pScope;
	}
	
	public function get childSetValueFunction():Function { return __childSetValueFunction; }
	
	public function set childSetValueFunction(pFunc:Function):Void
	{
		__childSetValueFunction = pFunc;
		__mcList.childSetValueFunction = pFunc;
	}
	
	public function get columnWidth():Number { return __mcList.columnWidth; }
	
	public function set columnWidth(pVal:Number):Void
	{
		if(pVal != __columnWidth)
		{
			__columnWidth = pVal;
			__mcList.columnWidth = pVal;		
		}
	}
	
	public function get rowHeight():Number { return __mcList.rowHeight; }	
	
	public function set rowHeight(pVal:Number):Void
	{
		if(pVal != __rowHeight)
		{
			__rowHeight = pVal;
			__mcList.rowHeight = pVal;
		}
	}
	
	public function get align():String
	{
		return __align;
	}
	
	public function set align(pAlign:String):Void
	{
		__align = pAlign;
	}
	
	public function get childHorizontalMargin():Number { return __mcList.childHorizontalMargin; }
	
	public function set childHorizontalMargin(val:Number):Void
	{
		__mcList.childHorizontalMargin = val;
	}
	
	public function get childVerticalMargin():Number { return __mcList.childVerticalMargin; }
	
	public function set childVerticalMargin(val:Number):Void
	{
		__mcList.childVerticalMargin = val;
	}
	
	public function get autoSizeToChildren():Boolean { return __autoSizeToChildren; }
	
	public function set autoSizeToChildren(pVal:Boolean):Void
	{
		__autoSizeToChildren = pVal;
	}
	
	public function get dataProvider():Collection
	{
		return __dataProvider;
	}
	
	public function set dataProvider(p_val:Collection):Void
	{
		//trace("------------------");
		//trace("ScrollableList::dataProvider setter, p_val: " + p_val);
		//trace("__mcList: " + __mcList);
		__dataProvider = p_val;
		__mcList.dataProvider = p_val;
		
	}
	
	public function get toggle():Boolean { return __toggle; }	
	
	public function set toggle(pBoolean:Boolean):Void
	{
		if(pBoolean != __toggle)
		{
			__toggle = pBoolean;
			__mcList.toggle = pBoolean;
		}
	}
	
	public function get selectedIndex():Number { return __mcList.selectedIndex; }	
	
	public function set selectedIndex(val:Number):Void
	{
		//trace("-------------");
		//trace("ScrollableList::selectedIndex setter, val: " + val);
		//trace("__mcList: " + __mcList);
		//trace("__mcList.selectedIndex: " + __mcList.selectedIndex);
		__mcList.selectedIndex = val;
		//trace("__mcList.selectedIndex: " + __mcList.selectedIndex);
	}
	
	public function get selectedItem():Object { return __selectedItem; }
	public function set selectedItem(val:Object):Void
	{
		__selectedItem = val;
		__mcList.selectedItem = __selectedItem;
	}
	
	
	
	[Inspectable(type="Boolean", defaultValue=true, name="Show Buttons")]
	public function get showButtons():Boolean { return __showButtons; }
	
	public function set showButtons(pVal:Boolean):Void
	{
		if(pVal != __showButtons)
		{
			__showButtons = pVal;
			invalidate();
		}
	}
	
	public function get pageTotal():Number{	
		
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);
		
		return lastPage;
	}
	
	public function get pageCurrent():Number { return pageIndex + 1; }
	
	public function get buttonList():ButtonList { return __mcList; }
	
	
	private var __childSetValueScope:Object;
	private var __childClass:Function						= Button;
	private var __childSetValueFunction:Function;
	private var __dataProvider:Collection;
	private var __direction:String;
	private var __horizontalPageSize:Number					= 0;
	private var __verticalPageSize:Number					= 0;
	private var __align:String								= "left";
	private var __childHorizontalMargin:Number				= 0;
	private var __childVerticalMargin:Number				= 0;
	private var __autoSizeToChildren:Boolean				= true;
	private var __showButtons:Boolean 						= true;
	private var __tweenScroll:Tween;
	private var __columnWidth:Number						= 0;
	private var __rowHeight:Number 							= 0;
	private var __toggle:Boolean 							= false;
	private var __selectedItem:Object;
	
	private var __mcList:ButtonList;
	private var __mcScrollPrevious:SimpleButton;
	private var __mcScrollNext:SimpleButton;
	private var __mcListMask:MovieClip;

	private var pageIndex:Number = 0;
	
	public function ScrollableList()
	{
		super();
	}
	
	public function getPreferredHeight(visibleRowCount:Number):Number
	{
		var preferredHeight:Number = 0;

		if (__showButtons == true)
		{
			preferredHeight = __mcList.getPreferredHeight(visibleRowCount) + __mcScrollPrevious.height + __mcScrollNext.height;
		}
		else
		{
			preferredHeight = __mcList.getPreferredHeight(visibleRowCount);
		}
		
		return preferredHeight;
	}
	
	public function getPreferredWidth(visibleColCount:Number):Number
	{
		var preferredWidth:Number = 0;

		if (__showButtons == true)
		{
			preferredWidth = __mcList.getPreferredWidth(visibleColCount) + __mcScrollPrevious.width + __mcScrollNext.width;
		}
		else
		{
			preferredWidth  = __mcList.getPreferredWidth(visibleColCount);
		}
			
		return preferredWidth;
	}
	
	private function createChildren():Void
	{
		super.createChildren();		

		setupList();
		setupButtons();
		
		__mcListMask = createEmptyMovieClip("__mcListMask", getNextHighestDepth());
		__mcList.setMask(__mcListMask);
	}
	
	// Exposed for a child class
	private function setupList():Void
	{
		//trace("----------------");
		//trace("ScrollableList::setupList");
		__mcList = ButtonList(attachMovie(ButtonList.SYMBOL_NAME, "__mcList", getNextHighestDepth()));
		__mcList.childClass = __childClass;
		var f:Function = __mcList.onDoneBuilding;
		__mcList.onDoneBuilding = function():Void
		{
			//trace("__mcList::onDoneBuilding");
			f.call(this);
			this._parent.invalidate();
		};
	}
	
	private function setupButtons():Void
	{
		__mcScrollPrevious = SimpleButton(attachMovie(SimpleButton.SYMBOL_NAME, "__mcScrollPrevious", getNextHighestDepth()));
		__mcScrollPrevious.setReleaseCallback(this, onScrollPrevious);
		__mcScrollPrevious.setSize(__width, 4);
		
		__mcScrollNext = SimpleButton(attachMovie(SimpleButton.SYMBOL_NAME, "__mcScrollNext", getNextHighestDepth()));
		__mcScrollNext.setReleaseCallback(this, onScrollNext);		
		__mcScrollNext.setSize(__width, 4);
	}
	
	private function redraw():Void
	{
		if(__mcList.isBuilding == true) return;
		
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ScrollableList::size, __width: " + __width + ", __columnWidth: " + __columnWidth);
		
		super.redraw();
		if (__showButtons == true)
		{	
			__mcScrollPrevious.move(0, 0);
			
			if(__mcList.direction == List.DIRECTION_HORIZONTAL)
			{
				var listWidth:Number = width - __mcScrollPrevious.width - __mcScrollNext.width;
				listWidth = Math.max(0, listWidth);
				
				__mcList.setSize(listWidth, __height);
				
				__mcList.move(__mcScrollPrevious.x + __mcScrollPrevious.width, 0);
				__mcScrollNext.move(__mcList.x + __mcList.width, 0);
			}
			else
			{
				var listHeight:Number = Math.max(0, height - __mcScrollPrevious.height - __mcScrollNext.height);
				__mcList.setSize(width, listHeight);
				__mcList.move(0, __mcScrollPrevious.y + __mcScrollPrevious.height);
				
				__mcScrollNext.move(0, __mcList.y + __mcList.height);
				__mcScrollNext.swapDepths(Math.max(__mcScrollNext.getDepth(), 9999));
			}
			
			__mcScrollPrevious.setSize(__width, __mcScrollPrevious.height);
			__mcScrollNext.setSize(__width, __mcScrollNext.height);
			
			__mcScrollPrevious.clear();
			__mcScrollPrevious.lineStyle(0, 0x333333);
			__mcScrollPrevious.beginFill(0xCCCCCC);
			DrawUtils.drawBox(__mcScrollPrevious, 0, 0, __mcScrollPrevious.width - 1, __mcScrollPrevious.height);
			var centerX:Number = __width / 2;
			var tW:Number = 6;
			var tH:Number = 4;
			DrawUtils.drawTriangle(__mcScrollPrevious, centerX - (tW / 2), tH, tW, tH);
			__mcScrollPrevious.beginFill(0x333333);
			DrawUtils.drawTriangle(__mcScrollPrevious, centerX - (tW / 2), tH, tW, tH);
			__mcScrollPrevious.endFill();
		
			__mcScrollNext.clear();
			__mcScrollNext.lineStyle(0, 0x333333);
			//__mcScrollNext.lineStyle(0, 0xFF0000);
			__mcScrollNext.beginFill(0xCCCCCC);
			//__mcScrollNext.beginFill(0x0000FF);
			DrawUtils.drawBox(__mcScrollNext, 0, 0, __mcScrollNext.width - 1, __mcScrollNext.height);
			DrawUtils.drawTriangle(__mcScrollNext, centerX - (tW / 2), 0, tW, tH, 180);
			__mcScrollNext.beginFill(0x333333);
			DrawUtils.drawTriangle(__mcScrollNext, centerX - (tW / 2), 0, tW, tH, 180);
			__mcScrollNext.endFill();
			
			__mcScrollPrevious._visible = true;
			__mcScrollNext._visible = true;			
		}
		else
		{
			__mcScrollPrevious._visible = false;
			__mcScrollNext._visible = false;
			
			__mcScrollPrevious.move(0, 0);
			__mcScrollNext.move(0, 0);
			
			__mcList.setSize(width, height);
			__mcList.move(0, 0);
			
			//__mcScrollPrevious.setSize(0, 0) 
			//__mcScrollNext.setSize(0, 0) 
		}
		
		__mcListMask._x = __mcList.x;
		__mcListMask._y = __mcList.y;

		com.jxl.shuriken.utils.DrawUtils.drawMask(__mcListMask, 0, 0, __mcList.width, __mcList.height);	
		
		
		//clear();
		//lineStyle(0, 0x666666);
		//DrawUtils.drawDashLineBox(this, 0, 0, width, height, 3, 3);
		//endFill();
	}
	
	public function onScrollPrevious(event:Object):Void
	{
		if(__mcList.isBuilding == true) return;
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;	
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);
	
		if(pageIndex - 1 > -1)
		{
			pageIndex--;
			scrollToNewPosition();
		}
		
	}
	
	public function onScrollNext(event:Object):Void
	{
		if(__mcList.isBuilding == true) return;
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);

		if (pageIndex + 1 < lastPage){
			pageIndex++;
			scrollToNewPosition();
		}
	}
	
	private function scrollToNewPosition():Void
	{
		if(__tweenScroll != null) TweenManager.abortTween(__tweenScroll);
		
		if(__mcList.direction == List.DIRECTION_HORIZONTAL)
		{			
			if(__mcList.horizontalPageSize == null || __mcList.horizontalPageSize == 0) return;
			
			var newIndex:Number = Math.min( pageIndex * __mcList.horizontalPageSize, (__dataProvider.getLength() - __mcList.horizontalPageSize));
			
			
			
			if(newIndex + __mcList.horizontalPageSize > __dataProvider.getLength()){
				newIndex = __dataProvider.getLength() - (newIndex + __mcList.horizontalPageSize);
			}
						
			var targetX:Number =  newIndex * (__mcList.columnWidth + __mcList.childHorizontalMargin);
			targetX -= __mcList.childHorizontalMargin;
			targetX -= __mcScrollPrevious.x + __mcScrollPrevious.width - __mcList.childHorizontalMargin;
					
			targetX = -targetX;
			
			__tweenScroll = new Tween(this, __mcList.x, targetX, scrollSpeed);
			__tweenScroll.easingEquation = Strong.easeOut;
			__tweenScroll.setTweenHandlers("onTweenHScrollUpdate", "onTweenHScrollEnd");
		}
		else
		{
			if(__mcList.verticalPageSize == null || __mcList.verticalPageSize == 0) return;
			
			var newIndex:Number = Math.min( pageIndex * __mcList.verticalPageSize, (__dataProvider.getLength() - __mcList.verticalPageSize));
			
			if(newIndex + __mcList.verticalPageSize > __dataProvider.getLength())
			{
				newIndex = __dataProvider.getLength() - (newIndex + __mcList.verticalPageSize);
			}
			
			var targetY:Number = newIndex * (__mcList.rowHeight + __mcList.childVerticalMargin);
			targetY -= __mcList.childVerticalMargin;
			targetY -= __mcScrollPrevious.y + __mcScrollPrevious.height - __mcList.childVerticalMargin;
			targetY = -targetY;
			
			__tweenScroll = new Tween(this, __mcList.y, targetY, scrollSpeed);
			__tweenScroll.easingEquation = Strong.easeOut;
			__tweenScroll.setTweenHandlers("onTweenVScrollUpdate", "onTweenVScrollEnd");
		}
	}
	
	private function onTweenHScrollUpdate(pVal:Number):Void
	{
		__mcList.move(pVal, __mcList.y);
	}
	
	private function onTweenHScrollEnd(pVal:Number):Void
	{
		onTweenHScrollUpdate(pVal);
	}
	
	private function onTweenVScrollUpdate(pVal:Number):Void
	{
		__mcList.move(__mcList.x, pVal);
	}
	
	private function onTweenVScrollEnd(pVal:Number):Void
	{
		onTweenVScrollUpdate(pVal);
	}
	
	// *********************************************************************************
	// Proxy Callbacks
	// TODO: maybe __resolve would be faster?  Need
	// to satisfy strong-typing via vars if you change
	
	// ButtonList's
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		__mcList.setItemClickCallback(scope, func);
	}
	
	public function setItemSelectionChangedCallback(scope:Object, func:Function):Void
	{
		__mcList.setItemSelectionChangedCallback(scope, func);
	}
	
	public function setItemRollOverCallback(scope:Object, func:Function):Void
	{
		__mcList.setItemRollOverCallback(scope, func);
	}
	
	// List's
	public function setColumnWidthChangedCallback(scope:Object, func:Function):Void
	{
		__mcList.setColumnWidthChangedCallback(scope, func);
	}
	
	public function setRowHeightChangedCallback(scope:Object, func:Function):Void
	{
		__mcList.setRowHeightChangedCallback(scope, func);
	}
	
	public function setSetupChildCallback(scope:Object, func:Function):Void
	{
		__mcList.setSetupChildCallback(scope, func);
	}
	
}