import net.manaca.lang.BObject;
import net.manaca.ui.controls.listClasses.IListDataProvider;
import net.manaca.lang.event.Event;
import net.manaca.data.list.ArrayList;
import net.manaca.util.Delegate;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
class net.manaca.ui.controls.listClasses.ListDataProvider extends BObject implements IListDataProvider {
	private var className : String = "net.manaca.ui.controls.listClasses.ListDataProvider";
	/** 数据发生改变是抛出此事件名事件 */
	static public var EVENT_DATA_CHANGED:String = "dataChanged";
	private var _items:ArrayList;
	private var _update_out_time:Number;
	public function ListDataProvider(arg:Array) {
		super();
		_items = new ArrayList(arg);
//		_items.toArray().watch("length",Delegate.create(this,updateViews));
	}

	public function addItem(item : Object) : Void {
		if(item != undefined) {
			_items.Add(item);
			updateViews();
		}
		//trace(_items);
	}

	public function addItemAt(index : Number,item : Object) : Void {
		if(item != undefined) {
			if(index < 0 )index  = this.size() - index;
			var _v = _items.addIn(item,index);
			if(_v) updateViews();
		}
	}

	public function getItemAt(index : Number) : Object {
		return _items.getItemAt(index);
	}

	public function getItemIndex(item : Object) : Number {
		return _items.indexOf(item);
	}

	public function removeAll() : Void {
		var _l:Number = _items.size();
		_items.clear();
		if(_l > 0) updateViews();
	}

	public function removeAt(index : Number) : Boolean {
		return this.removeItem(_items.Get(index));
	}

	public function removeItem(item : Object) : Boolean {
		var result : Boolean = false;
		result = _items.remove(item);
		if(result) updateViews();
		return result;
	}

	public function setItemAt(item : Object, index : Number) : Object {
		return null;
	}

	public function toArray() : Array {
		return _items.toArray();
	}

	public function updateViews() : Void {
		clearInterval(_update_out_time);
		//设置延时，主要用于在数据平凡更新时减少UI操作。
		_update_out_time = setInterval(this,"__dispatchEvt",10);
		//__dispatchEvt();
	}
	private function __dispatchEvt():Void{
		clearInterval(_update_out_time);
		this.dispatchEvent(new Event(EVENT_DATA_CHANGED,this,this));
	}
	public function addListener(type:String, listener:Function) : Void {
		this.addEventListener(type,listener);
	}
	
	public function removeListener(type:String, listener:Function) : Void {
		this.removeEventListener(type,listener);
	}

	public function size() : Number {
		return _items.size();
	}

}