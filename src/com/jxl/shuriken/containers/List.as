import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.Container;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

[InspectableList("direction", "columnWidth", "rowHeight", "align", "childHorizontalMargin", "childVerticalMargin")]
class com.jxl.shuriken.containers.List extends Container
{
	public static var SYMBOL_NAME:String 					= "com.jxl.shuriken.containers.List";
	
	public static var ALIGN_LEFT:String 					= "left";
	public static var ALIGN_CENTER:String 					= "center";
	
	public static var DIRECTION_HORIZONTAL:String 			= "horizontal";
	public static var DIRECTION_VERTICAL:String 			= "vertical";
	
	[Inspectable(type="List", enumeration="horizontal,vertical", defaultValue="horizontal")]
	public function get direction():String { return __direction; }
	
	public function set direction(pVal:String):Void
	{
		__direction = pVal;
		callLater(this, draw);
	}
	
	public function get horizontalPageSize():Number { return __horizontalPageSize; }
	
	public function get verticalPageSize():Number { return __verticalPageSize; }
	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(p_class:Function):Void
	{
		__childClass = p_class;
		callLater(this, draw);
	}
	
	public function get childSetValueFunction():Function { return __childSetValueFunction; }
	
	public function set childSetValueFunction(pFunc:Function):Void
	{
		__childSetValueFunction = pFunc;
		refreshSetValues();
	}
	
	public function get childSetValueScope():Object { return __childSetValueScope; }
	
	public function set childSetValueScope(pScope:Object):Void
	{
		__childSetValueScope = pScope;
		refreshSetValues();
	}
	
	[Inspectable(defaultValue=null, type="Number", name="Column Width")]
	public function get columnWidth():Number { return __columnWidth; }
	
	public function set columnWidth(p_val:Number):Void
	{
		__columnWidth = p_val;
		calculateHorizontalPageSize();
		__columnWidthDirty = true;
		__autoSizeToChildren = false;
		invalidate();
		__colWChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
	}
	
	[Inspectable(defaultValue=null, type="Number", name="Row Height")]
	public function get rowHeight():Number { return __rowHeight; }
	
	public function set rowHeight(pVal:Number):Void
	{
		__rowHeight = pVal;
		calculateVerticalPageSize();
		__rowHeightDirty = true;
		__autoSizeToChildren = false;
		invalidate();
		__rowHChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));
	}
	
	
	
	[Inspectable(type="List", enumeration="left,center", defaultValue="left")]
	public function get align():String
	{
		return __align;
	}
	
	public function set align(pAlign:String):Void
	{
		__align = pAlign;
		invalidate();
	}
	
	[Inspectable(type="Number", defaultValue=0, name="Horizontal Margin")]
	public function get childHorizontalMargin():Number { return __childHorizontalMargin; }
	
	public function set childHorizontalMargin(pVal:Number):Void
	{
		__childHorizontalMargin = pVal;
		invalidate();
	}
	
	[Inspectable(type="Number", defaultValue=0, name="Vertical Margin")]
	public function get childVerticalMargin():Number { return __childVerticalMargin; }
	
	public function set childVerticalMargin(pVal:Number):Void
	{	
		__childVerticalMargin = pVal;
		invalidate();
	}
	
	public function get autoSizeToChildren():Boolean { return __autoSizeToChildren; }
	
	public function set autoSizeToChildren(pVal:Boolean):Void
	{
		__autoSizeToChildren = pVal;
		callLater(this, draw);
	}
	
	public function get dataProvider():Collection { return __dataProvider; }
	
	public function set dataProvider(p_val:Collection):Void
	{
		//trace("------------------");
		//trace("List::dataProvider::setter, p_val: " + p_val);
		__isBuilding = true;
		if(__dataProvider != null)
		{
			var oldDP:Collection = __dataProvider;
			__dataProvider.setChangeCallback();
		}
		__dataProvider = p_val;
		__dataProvider.setChangeCallback(this, onCollectionChanged);
		callLater(this, draw);
	}
	
	public function get isBuilding():Boolean { return __isBuilding; }
	
	private var __isBuilding:Boolean 							= true;
	private var __childClass:Function;
	private var __childSetValueFunction:Function				= refreshSetValue;
	private var __childSetValueScope:Object;
	

	private var __align:String									= "left";
	
	private var __childHorizontalMargin:Number					= 0;
	private var __horizontalPageSize:Number						= 0;
	private var __rowHeight:Number								= 18;
	private var __rowHeightDirty:Boolean;
		
	private var __childVerticalMargin:Number					= 0;
	private var __verticalPageSize:Number						= 0;
	private var __columnWidth:Number							= 100;	
	private var __columnWidthDirty:Boolean;	
	
	private var __direction:String								= "vertical";
	private var __autoSizeToChildren:Boolean					= true;
	
	private var __highestChildDepth:Number;
	
	private var __dataProvider:Collection;
	private var __dataProviderDirty:Boolean						= false;
	private var __colWChangeCallback:Callback;
	private var __rowHChangeCallback:Callback;
	private var __setupChildCallback:Callback;
	
	private var debugC:Number = 1;
	
	public function List()
	{
		super();
		
		__childSetValueScope = this;
		__childClass = Button;
		
		//DebugWindow.debugHeader();
		//DebugWindow.debug("List::constructor");
		//DebugWindow.debug("__childClass: " + __childClass);
	}
	
	// Overriding
	public function setSize(p_width:Number, p_height:Number):Void
	{
		super.setSize(p_width, p_height);
		
		calculateHorizontalPageSize();
		calculateVerticalPageSize();
	}
	
	public function refreshSetValues():Void
	{
		var i:Number = __dataProvider.getLength();
		while(i--)
		{
			var item:Object = __dataProvider.getItemAt(i);
			var child:UIComponent = getChildAt(i);
			//trace("getChildAt(i): " + getChildAt(i));
			//trace("child: " + child);
			__childSetValueFunction.call(__childSetValueScope, child, i, item);
		}
	}
	
	// Should be set via outside class, by default is to look for data setter
	public function refreshSetValue(p_child:UIComponent, p_index:Number, p_item:Object):Void
	{
		//trace("-------------");
		//trace("List::refreshSetValue, p_child: " + p_child + ", p_index: " + p_index + ", p_item: " + p_item);
		//trace("p_child: " + p_child);
		//trace("p_child.toString(): " + p_child.toString());
		//trace("__childClass: " + __childClass);
		if(p_child instanceof Button)
		{
			//trace("button");
			// FIXME: Dependency; could possibly re-factor to ensure
			// this class isn't included in the SWF if the developer
			// doesn't want it to be
			Button(p_child).label = p_item.toString();
		}
		else if(p_child instanceof SimpleButton)
		{
			//trace("simple button");
		}
		else if(p_child instanceof UIComponent)
		{
			//trace("UIComponent");
			p_child.data = p_item.toString();
		}
	}
	
	// Called on each child before its setValue function
	// allows a subclass of list to set up a child without using the setValue function.
	
	public function setupChild(p_child:UIComponent)
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.SETUP_CHILD, this);
		event.child = p_child;
		event.list = this;
		__setupChildCallback.dispatch(event);
	}
	
	public function getPreferredHeight(p_visibleRowCount:Number):Number
	{
		var preferredHeight:Number = (p_visibleRowCount * (__rowHeight  + __childVerticalMargin)) - __childVerticalMargin;
		return preferredHeight;
	}
	
	public function getPreferredWidth(p_visibleColCount:Number):Number
	{
		var preferredWidth:Number = (p_visibleColCount * (__columnWidth * __childHorizontalMargin)) - __childHorizontalMargin;
		return preferredWidth;
	}
	
	private var __currentDrawIndex:Number = -1;
	
	private function draw():Void
	{
		//trace("-------------------");
		//trace("List::draw");
		
		removeAllChildren();
		var len:Number = __dataProvider.getLength();
		
		//DebugWindow.debug("__dataProvider: " + __dataProvider);
		//DebugWindow.debug("__dataProvider.getLength: " + __dataProvider.getLength);
		//trace("len: " + len);
		
		if (len < 1 || len == undefined) return;

		// we do the first one out of the loop.  That way, if the developer
		// hasn't set a column width (columnWidth), we'll just grab the first child
		// and assume the rest are the same width.
		var i:Number = 0;
		var item:Object = __dataProvider.getItemAt(i);
		var child:UIComponent = createChildAt(i, __childClass);
		
		//DebugWindow.debug("__childClass: " + __childClass);
		//DebugWindow.debug("child: " + child);
		
		//trace("__childSetValueFunction: " + __childSetValueFunction);
		//trace("__childSetValueScope: " + __childSetValueScope);
		//trace("child: " + child);
		//trace("i: " + i);
		//trace("item: " + item);
		__childSetValueFunction.call(__childSetValueScope, child, i, item);
		
		//trace("child: " + child);
		//trace("child.width: " + child.width + ", child.height:  "+ child.height);
		
		//trace("__autoSizeToChildren: " + __autoSizeToChildren);
		if(__autoSizeToChildren == true)
		{
			__columnWidth = child.width;
			calculateHorizontalPageSize();
			__colWChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
		
			__rowHeight = child.height;
			calculateVerticalPageSize();
			__rowHChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));
		}
		
		//trace("__columnWidth: " + __columnWidth + ", __rowHeight: " + __rowHeight);
		
		setupChild(child);
		
		/*
		// now do the rest
		for(i = 1; i<len; i++)
		{
			item = __dataProvider.getItemAt(i);
			child = createChildAt(i, __childClass);
			//trace("child2: " + child);
			//gives one the opportunity to set up a child,
			//before the childSetValueFunction is called
			setupChild(child);
			
			__childSetValueFunction.call(__childSetValueScope, child, i, item);
		}
		
		size();
		*/
		
		if(len > 0)
		{
			__currentDrawIndex = 0;
			callLater(this, drawNext);
		}
		else
		{
			invalidate();
		}
	}
	
	private function drawNext():Void
	{
		//trace("-----------------");
		//trace("List::drawNext");
		//trace("__currentDrawIndex: " + __currentDrawIndex);
		if(__currentDrawIndex + 1 < __dataProvider.getLength())
		{
			__currentDrawIndex++;
			var item:Object = __dataProvider.getItemAt(__currentDrawIndex);
			var child:UIComponent = createChildAt(__currentDrawIndex, __childClass);
			setupChild(child);
			__childSetValueFunction.call(__childSetValueScope, child, __currentDrawIndex, item);
			callLater(this, drawNext);
		}
		else
		{
			//trace("Done drawing all");
			__currentDrawIndex = null;
			invalidate();
		}
	}
	
	private function redraw():Void
	{
		
		super.redraw();
		
		var howManyChildren:Number = numChildren;
		//trace("----------------");
		//trace("List::size, __width: " + __width + ", __columnWidth: " + __columnWidth);
		//trace("howManyChildren: " + howManyChildren);
		//trace("__direction: " + __direction);
		//trace("__align: " + __align);
		
		if(__direction == DIRECTION_HORIZONTAL)
		{
			if(__align == ALIGN_LEFT)
            {
				var origX:Number = 0;
				for(var i:Number = 0; i<howManyChildren; i++)
				{
					var child:UIComponent = getChildAt(i);
					child.move(origX, 0);
					child.setSize(__columnWidth, __rowHeight);
					origX += __columnWidth + __childHorizontalMargin;
				}
			}
			else if(__align == ALIGN_CENTER)
			{
				var totalMenuItemsWidth:Number = (howManyChildren * __columnWidth) + ( (howManyChildren - 1) * __childHorizontalMargin);
				var startX:Number = (width / 2) - (totalMenuItemsWidth / 2);
				for(var i:Number = 0; i<howManyChildren; i++)
				{
					var child:UIComponent = getChildAt(i);
					child.move(startX, 0);
					child.setSize(__columnWidth, __rowHeight);
					startX += __columnWidth + __childHorizontalMargin;
				}
			}
		}
		else
		{
			//trace("howManyChildren: " + howManyChildren);
			var origY:Number = 0;
			for(var i:Number = 0; i<howManyChildren; i++)
			{			
				var child:UIComponent = getChildAt(i);
				child.move(0, origY);
				//trace("origY: " + origY);
				//trace("w: " + __columnWidth + ", h: " + __rowHeight);
				child.setSize(__columnWidth, __rowHeight);
				origY += __rowHeight + __childVerticalMargin;				
			}
		}
		
		//trace("-----------------");
		//trace("List::redraw, __currentDrawIndex: " + __currentDrawIndex);
		if(__currentDrawIndex == null)
		{
			//trace("__currentDrawIndex is null");
			if(__isBuilding == true)
			{
				//trace("__isBuilding is now false");
				__isBuilding = false;
				callLater(this, onDoneBuilding);
			}
		}
	}
	
	public var onDoneBuilding:Function;
	
	public function setColumnWidthNoRedraw(p_val:Number):Void
	{
		__columnWidth = p_val;
		calculateHorizontalPageSize();
		__colWChangeCallback.dispatch(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
	}
	
	// # items that fit in 1 page 
	private function calculateHorizontalPageSize():Void
	{
		var iWidth:Number = __columnWidth + __childHorizontalMargin;
		if (iWidth == undefined || iWidth ==0) iWidth = 1;
		
		__horizontalPageSize = Math.max(Math.floor(__width /iWidth), 1);

		// special case to handle the situation where the final margin pushed us into a new page
		if ( (__horizontalPageSize > 1) && (__width % iWidth == __columnWidth) )
			__horizontalPageSize++;
	}
	
	// # items that fit in 1 page 
	private function calculateVerticalPageSize():Void
	{
		var iHeight:Number = iHeight = __rowHeight + __childVerticalMargin;
		if (iHeight == undefined || iHeight ==0) iHeight = 1;
		
		__verticalPageSize = Math.max(Math.floor(__height / iHeight), 1);

		// special case to handle the situation where the final margin pushed us into a new page
		if ( (__verticalPageSize > 1) && (__height % iHeight == __rowHeight) )
			__verticalPageSize++;
	}
	
	private function onCollectionChanged(p_event:ShurikenEvent):Void
	{
		//trace("-----------------");
		//trace("List::onCollectionChanged");
		//trace("p_event.operation: " + p_event.operation);
		// TODO: add invalidation later, for now, draws are immediate
		
		switch(p_event.operation)
		{
			case ShurikenEvent.REMOVE:
				removeChildAt(p_event.index);
				redraw();
				break;
			
			case ShurikenEvent.ADD:
				//trace("p_event.index: " + p_event.index);
				var newItem:Object = __dataProvider.getItemAt(p_event.index);
				var addedChild:UIComponent = createChildAt(p_event.index, 
														   __childClass);
				setupChild(addedChild);
				__childSetValueFunction.call(__childSetValueScope, 
											 addedChild, 
											 p_event.index, 
											 newItem);
				redraw();
				//trace("newItem: " + newItem);
				//trace("addedChild: " + addedChild);
				break;
				
			case ShurikenEvent.REPLACE:
			case ShurikenEvent.UPDATE:
				var updatedChild:UIComponent = getChildAt(p_event.index);
				var updatedItem:Object = __dataProvider.getItemAt(p_event.index);
				__childSetValueFunction.call(__childSetValueScope, 
											 updatedChild, 
											 p_event.index, 
											 updatedItem);
				break;
			
			case ShurikenEvent.REMOVE_ALL:
			case ShurikenEvent.UPDATE_ALL:
				draw();
				break;
			
		}
	}
	
	public function setColumnWidthChangedCallback(scope:Object, func:Function):Void
	{
		__colWChangeCallback = new Callback(scope, func);
	}
	
	public function setRowHeightChangedCallback(scope:Object, func:Function):Void
	{
		__rowHChangeCallback = new Callback(scope, func);
	}
	
	public function setSetupChildCallback(scope:Object, func:Function):Void
	{
		__setupChildCallback = new Callback(scope, func);
	}
	
}