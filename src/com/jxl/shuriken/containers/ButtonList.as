import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.containers.ButtonList extends List
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.ButtonList";
	
	public function get toggle():Boolean { return __toggle; }
	
	public function set toggle(pVal:Boolean):Void
	{
		__toggle = pVal;
		invalidate();
	}
	
	public function get selectedIndex():Number { return __selectedIndex; }
	
	public function set selectedIndex(val:Number):Void{
		
		__selectedIndex = val;
		if(__toggle == true)
		{
			__selectedIndexDirty = true;
			if(__isBuilding != true) callLater(this, commitProperties);
			
		}
	}
	
	public function get selectedItem():Object 
	{ 
		return __selectedItem; 
	}
	
	public function set selectedItem(val:Object):Void
	{
		__selectedItem = val;
		if(__selectedItem == null || __selectedItem == "") return;
		__selectedItemDirty = true;
		if(__isBuilding != true) callLater(this, commitProperties);
	}
	
	public function get selectedChild():Button { 
		return __selectedChild; 
	}

	public function set selectedChild(pVal:Button):Void
	{
		__selectedChild = pVal;
		
		var index:Number = getChildIndex(pVal);
		if(index != null && isNaN(index) == false)
		{
			selectedIndex = index;
		}
	}
	
	public function lastSelectedItem():Button
	{
		return __lastSelected;
	}
	
	
	private var __childClass:Function 				= Button;
	private var __toggle:Boolean					= true;
	private var __selectedIndex:Number;
	private var __selectedItem:Object;
	private var __selectedChild:Button;
	private var __lastSelected:Button;
	private var __itemSelectionChanged:Callback;
	private var __itemClickCallback:Callback;
	private var __itemRollOverCallback:Callback;
	
	private var __selectedIndexDirty:Boolean;
	private var __selectedItemDirty:Boolean;
	
	private function commitProperties():Void
	{
		//trace("---------------");
		//trace("ButtonList::commitProperties");
		//trace("__selectedIndexDirty: " + __selectedIndexDirty);
		//trace("__selectedItemDirty: " + __selectedItemDirty);
		if(__selectedIndexDirty == true)
		{
			delete __selectedIndexDirty;
			setSelectedIndex();
		}
		
		if(__selectedItemDirty == true)
		{
			delete __selectedItemDirty;
			setSelectedItem();
		}
	}
	
	public function onDoneBuilding():Void
	{
		//trace("---------------");
		//trace("ButtonList::onDoneBuilding");
		super.onDoneBuilding();
		
		commitProperties();
	}
	
	// Called by draw
	private function setupChild(p_child:UIComponent):Void
	{
		if(p_child instanceof SimpleButton)
		{
			var simpleButton:SimpleButton = SimpleButton(p_child);
			simpleButton.setReleaseCallback(this, onListItemClicked);
		}
		// KLUDGE: need better enforcement, but interfaces are too heavy
		// and we can't demand people extend SimpleButton
		//else if(p_child.hasOwnProperty("setReleaseCallback") == true)
		// BUG: above is giving whack results... it traces out function,
		// apparently according to enumeration and hasOwnProperty, it does not
		// wtf...>!?!?!?
		else
		{
			// HACK: compiler hack
			p_child["setReleaseCallback"](this, onListItemClicked);
		}
		
		//simpleButton.addEventListener(ShurikenEvent.ROLL_OVER, Delegate.create(this, onListItemRollOver));
		if(p_child instanceof Button == true)
		{
			
			var button:Button = Button(p_child);
			if(__toggle == true)
			{
				button.toggle = true;
				
				if(__selectedIndex > -1)
				{
					var index:Number = getChildIndex(button);
					if(__selectedIndex == index)
					{
						button.selected = true;
					}
				}
			}
		}
		
		super.setupChild(p_child);
		
	}
	
	private function setSelectedIndex(noEvent:Boolean):Void
	{
		//trace("--------------------");
		//trace("ButtonList::setSelectedIndex");
		
		var lastSelectedChild:Button = __lastSelected;
		
		if(__lastSelected != null) __lastSelected.selected = false;
		
		__lastSelected = Button(getChildAt(__selectedIndex));
		__lastSelected.selected = true;
		
		var item = __dataProvider.getItemAt(__selectedIndex);
		__selectedItem = item;
		
		//trace("__lastSelected: " + __lastSelected);
		if(__lastSelected != null)
		{
			// every other time
			__selectedChild = __lastSelected;
		}
		else
		{
			// first time through
			__selectedChild = Button(getChildAt(__selectedIndex));
			//trace("numChildren: " + numChildren);
			//trace("__selectedIndex: " + __selectedIndex);
			//trace("__selectedChild: " + __selectedChild);
		}
		
		//trace("noEvent: " + noEvent);
		//trace("isConstructing: " + isConstructing);
		
		if(noEvent != true && isConstructing == false)
		{
			//trace("dispatching item_selection_changed");
			var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_SELECTION_CHANGED, this);
			event.lastSelected = lastSelectedChild;
			event.selected = __selectedChild;
			event.item = item;
			event.index = __selectedIndex;
			__itemSelectionChanged.dispatch(event);
		}
		
	}
	
	private function setSelectedItem():Void
	{
		//trace("-------------------");
		//trace("ButtonList::setSelectedItem");
		//trace("__selectedItem: " + __selectedItem);
		var i:Number = __dataProvider.getLength();
		//trace("__dataProvider: " + __dataProvider);
		//trace("i: " + i);
		var c:Number = 0;
		while(i--)
		{
			var o:Object = __dataProvider.getItemAt(c);
			//trace(o + " vs. " + __selectedItem);
			if(o == __selectedItem)
			{	
				//trace("found a match");
				selectedIndex = c;
				return;
			}
			c++;
		}
	}
	
	// Event listeners
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemClicked");
		//DebugWindow.debug("p_event: " + p_event);
		//DebugWindow.debug("p_event.target: " + p_event.target);
		//DebugWindow.debug("__dataProvider: " + __dataProvider);
		//DebugWindow.debug("UIComponent(p_event.target): " + UIComponent(p_event.target));
		//DebugWindow.debug("index: " + index);
		var index:Number = getChildIndex(UIComponent(p_event.target));
		var item:Object = __dataProvider.getItemAt(index);
		selectedIndex = index;
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		//DebugWindow.debug("item: " + item);
		//DebugWindow.debug("index: " + index);
		__itemClickCallback.dispatch(event);
	}
	
	private function onListItemRollOver(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemRollOver");
		var index:Number = getChildIndex(UIComponent(p_event.target));
		var item:Object = __dataProvider.getItemAt(index);
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_ROLL_OVER, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		__itemRollOverCallback.dispatch(event);
	}
	
	public function setItemSelectionChangedCallback(scope:Object, func:Function):Void
	{
		__itemSelectionChanged = new Callback(scope, func);
	}
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setItemClickCallback, scope: " + scope + ", func: " + func);
		__itemClickCallback = new Callback(scope, func);
		//DebugWindow.debug("__itemClickCallback: " + __itemClickCallback);
	}
	
	public function setItemRollOverCallback(scope:Object, func:Function):Void
	{
		__itemRollOverCallback = new Callback(scope, func);
	}
	
}