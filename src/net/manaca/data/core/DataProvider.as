import net.manaca.lang.BObject;
import net.manaca.data.list.AbstractList;
import net.manaca.lang.event.Event;

/**
 * 数据中心
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.data.core.DataProvider extends BObject {
	private var className : String = "net.manaca.data.core.DataProvider";
	private var _items:Array;

	public function DataProvider() {
		super();
		_items = new Array();
	}
	
	/**
	 * 向列表的结尾添加项目
	 */
	public function addItem(o:Object):Void{
		_items.push(o);
		modelChanged();
	}
	
	/**
	 * 将项目添加到指定索引处的列表
	 */
	public function addItemAt(index:Number,o:Object):Void{
		_items.splice(index,0,o);
		modelChanged();
	}

	
	/**
	 * 返回指定索引处的项目
	 */
	public function getItemAt(index:Number):Object{
		return (_items[index]);
	}
	
	/**
	 * 删除列表中的所有项目
	 */
	public function removeAll():Void{
		_items = new Array();
		modelChanged();
	}
	
	/**
	 * 删除指定索引处的项目。
	 */
	public function removeItemAt(index:Number):Void{
		
		var o  = getItemAt(index);
		if(o != undefined){
			_items.splice(index,1);
			modelChanged();
		}
			
	}
	
	public function getIndex(o:Object):Number{
		for (var i : Number = 0; i < _items.length; i++) {
			if(_items[i] == o) return  i;
		}
		return -1;
	}
	/**
	 * 按照指定的比较函数对列表中的项目进行排序
	 */
	public function sortItems(fun:Object,options:Number):Void{
		_items.sort(fun,options);
		modelChanged();
	}
	
	/**
	 * 按照指定的属性对列表中的项目进行排序
	 */
	public function sortItemsBy(fieldName:String, options:Object):Void{
		_items.sortOn(fieldName,options);
		modelChanged();
	}
	 /**
	  * 获取和设置
	  * @param  value:Number - 
	  * @return Number 
	  */
	 public function get length() :Number
	 {
	 	return _items.length;
	 }
	 
	 private function modelChanged():Void{
	 	this.dispatchEvent(new Event(Event.CHANGE,_items,this));
	 }
}