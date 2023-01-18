import net.manaca.globalization.festival.IFestival;
import net.manaca.lang.BObject;
import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.iterator.IteratorImpl;
import net.manaca.data.map.KeyMap;
import net.manaca.globalization.festival.FestivalItem;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.data.list.ArrayList;
import net.manaca.data.collection.AbstractCollection;
import net.manaca.lang.exception.UnsupportedOperationException;

/**
 * Festival 对象表示一个节日列表，可以添加、删除、查询节日
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.globalization.festival.FestivalMap extends AbstractCollection implements Collection{
	private var className : String = "net.manaca.globalization.festival.Festival";
	private var _typemap:KeyMap;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function FestivalMap() {
		super();
		_typemap = new KeyMap();
	}
	/**
	 * 添加一个节日
	 * @param o 一个节日
	 */
	public function Add(o : Object) : Boolean {
		var _f:FestivalItem = FestivalItem(o);
		
		if(_f.code == undefined) throw new IllegalArgumentException("在添加节日元素时出现参数错误",this,arguments);
		
		if(_typemap.containsKey(_f.type)){
			_typemap.get(_f.type).put(_f.code,_f);
		}else{
			var _new_map:KeyMap = new KeyMap();
			_new_map.put(_f.code,_f);
			_typemap.put(_f.type,_new_map);
			
		}
		return null;
	}
	
	/** 
	 * 将指定 collection 中的所有元素都添加到此 collection 中（可选操作）。 
	 * @param c - 要插入到此 collection 的元素。
	 * @return Boolean 在传入的 Collection 为空时返回 False
	 */
	public function addAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		var _arr:Array = c.toArray();
		for (var i : Number = 0; i < _arr.length; i++) {
			Add(_arr[i]);
		}
		return true;
	}
	
	/**
	 * 删除一个节日
	 * @param o 一个节日
	 * @return 如果存在则true
	 */
	public function remove(o : Object) : Boolean {
		var _f:FestivalItem = FestivalItem(o);
		if(_f.code == undefined) throw new IllegalArgumentException("在添加节日元素时出现参数错误",this,arguments);
		if(_typemap.containsKey(_f.type)){
			var s = _typemap.get(_f.type).remove(_f.code);
			if(s != null) return true;
		}
		return false;
	}
	
	/**
	 * 如果此 collection 包含指定 collection 中的所有元素，则返回 true 
	 * @param c - 将检查是否包含在此 collection 中的 collection。
	 * @return Boolean
	 */
	public function containsAll(c : Collection) : Boolean {
		//如果大小都不对，肯定是 False
		if(this.size() < c.size()) return false;
		var result:Boolean = true;
		var i:Number = c.size();
		var _iterator:Iterator = c.iterator();
		while(--i-(-1)){
			if(!contains(_iterator.next())){
				result = false;
				break;
			}
		}
		return result;
	}
	

	
	/** 
	 * 移除此 collection 中那些也包含在指定 collection 中的所有元素
	 * @param c - 要从此 collection 移除的元素。
	 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
	 */ 
	public function removeAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		var _arr:Array = c.toArray();
		for (var i : Number = 0; i < _arr.length; i++) {
			this.remove(_arr[i]);
		}
		return true;
	}
	
	/** 仅保留此 collection 中那些也包含在指定 collection 的元素 */
	public function retainAll(c : Collection) : Boolean {
		throw new UnsupportedOperationException("retainAll方法无法执行，目前不支持",this);
		return null;
	}
	
	/** 
	 * 移除此 collection 中的所有元素 
	 * @param c - 保留在此 collection 中的元素。
	 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
	 */
	public function clear() : Void {
		_typemap = new KeyMap();
	}

	public function isEmpty() : Boolean {
		return (_typemap.size() == 1);
	}
	
	/** 
	 * 如果此 collection 包含指定的元素，则返回 true。
	 * @param o - 测试在此 collection 中是否存在的元素。
	 * @return Boolean
	 */
	public function contains(o : Object) : Boolean {
		return (_typemap.containsKey(o.type));
	}

	public function getItemAt(i : Number) : Object {
		throw new UnsupportedOperationException("getItemAt方法无法执行，目前不支持",this);
		return null;
	}
	
	/**
	 * 返回指定类型的KeyMap数据
	 * @param type 节日类型
	 * @return KeyMap 如果没有此类型数据则返回 null
	 */
	public function getFestivalsOfType(type:String):KeyMap{
		return KeyMap(_typemap.get(type));
	}
	
	/**
	 * 获取指定类型的指定编号节日
	 * @param type 节日类型
	 * @param code 节日编号
	 * @return FestivalItem 如果不存在则返回 null
	 */
	public function getFestival(type:String,code:String):FestivalItem{
		return _typemap.get(type).get(code);
	}
	/** 返回此 collection 中的元素数。 */
	public function size() : Number {
		return toArray().length;
	}


	public function toArray() : Array {
		var arr:Array = new Array();
		var _kmap:Array = _typemap.values().toArray();
		for (var i : Number = 0; i < _kmap.length; i++) {
			arr = arr.concat(_kmap[i].values().toArray());
		}
		return arr;
		
	}

	public function iterator() : Iterator {
		return(new IteratorImpl(this));
	}
}