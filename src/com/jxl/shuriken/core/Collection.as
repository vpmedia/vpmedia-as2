import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.core.Collection
{
	public function get source():Array { return __source; }
	
	public function set source(p_val:Array):Void
	{
		__source = p_val;
		onCollectionChanged(ShurikenEvent.UPDATE_ALL);
	}
	
	private var __source:Array;
	private var __callback:Callback;
	
	public function Collection(p_source:Array)
	{
		if(p_source != null)
		{
			__source = p_source;
		}
		else
		{
			__source = [];	
		}
	}
	
	public function addItem(p_item:Object):Void
	{
		var index:Number = __source.push(p_item);
		onCollectionChanged(ShurikenEvent.ADD, --index);
	}
	
	public function addItemAt(p_item:Object, p_index:Number):Void
	{
		__source.splice(p_index, 0, p_item);
		onCollectionChanged(ShurikenEvent.ADD, p_index);
	}
	
	public function getItemAt(p_index:Number):Object
	{
		return __source[p_index];
	}
	
	public function getItemIndex(p_item:Object):Number
	{
		var i:Number = __source.length;
		while(i--)
		{
			if(__source[i] == p_item)
			{
				return i;
			}
		}
		return -1;
	}
	
	public function itemUpdated(p_item:Object, p_propName:String, p_oldVal:Object, p_newVal:Object ):Void 
	{
		// update
		var index:Number = getItemIndex(p_item);
		onCollectionChanged(ShurikenEvent.UPDATE, index);
	}
	
	public function removeAll():Void
	{
		__source.splice(0);
		onCollectionChanged(ShurikenEvent.REMOVE_ALL);
	}
	
	public function removeItemAt(p_index:Number):Object
	{
		var removedArray:Array = __source.splice(p_index, 1);
		onCollectionChanged(ShurikenEvent.REMOVE, p_index);
		return removedArray[0];
	}
	
	public function setItemAt(p_item:Object, p_index:Number):Object
	{
		__source.splice(p_index, 0, p_item);
		onCollectionChanged(ShurikenEvent.REPLACE, p_index);
		return p_item;
	}
	
	public function getLength():Number
	{
		return __source.length;
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		if(scope == null)
		{
			__callback = null;
			delete __callback;
			return;
		}
		//if(__callback != null) trace("WARNING: Someone is adding another callback to Collection; it only supports 1.");
		__callback = new Callback(scope, func);
	}
	
	private function onCollectionChanged(p_type:String, p_index:Number):Void
	{
		__callback.dispatch(new ShurikenEvent(ShurikenEvent.COLLECTION_CHANGED, this, p_index, p_type));
	}
	
	public function toString():String
	{
		return __source.toString();	
	}
}