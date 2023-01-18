import net.manaca.data.collection.AbstractCollection;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\AbstractList.java

//package was.util;


/**
 * 此类中每个非抽象方法的文档详细描述了其实现。如果要实现的 collection 
 * 允许更有效的实现，则可以重写这些方法中的每个方法。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.list.AbstractList extends AbstractCollection
{
	private var className : String = "net.manaca.data.list.AbstractList";
	/**
	 * 构造函数
	 * @roseuid 4382E7610109
	 */
	public function AbstractList() {
		super();
	}
	/**
     * 在列表的指定位置插入指定元素（可选操作）。将当前处于该位置的元素（如果有的话）和
     * 所有后续元素向右移动（在其索引中加 1）。
     * @param o - 要插入的元素。
     * @param index - 要在其位置插入指定元素的索引。
     * @return Boolean 如果原数据改变,则返回true
	 */
	public function addIn(o : Object, index : Number) : Boolean {
		if(!o || index < 0) return false;
		if(index >= this.size()){
			_items.push(o);
			return true;
		}
		_items.splice(index,0,o);
		return true;
	}
	
	/** 
	 * 返回列表中指定位置的元素。
	 * @param index - 要返回的元素的索引。
	 * @return Object
	 */
	public function Get(index : Number) : Object {
		return _items[index];
	}

	/** 
	 * 用指定元素替换列表中指定位置的元素
	 * @param index - 要替换的元素的索引。
	 * @param element - 要在指定位置存储的元素。
	 * @return Object 以前在指定位置的元素。
	 */ 
	public function Set(index : Number, element : Object) : Object {
		 return _items.splice(index,1,element);
	}
	
	/** 
	 * 返回列表中首次出现指定元素的索引，或者如果列表不包含此元素，则返回 -1 
	 * @param o - 要搜索的元素。
	 * @return Number
	 */
	public function indexOf(o : Object) : Number {
//		for (var i : Number = 0; i < _items.length; i++) {
//			if(_items[i] === o) {
//				return i;
//			}
//		}
//		return -1;
		var l:Number = this.size();
		while (--l > -1 && this.Get(l) !== o);
		return l;
	}
	
	/** 
	 * 返回列表中最后出现指定元素的索引，或者如果列表不包含此元素，则返回 -1 
	 * @param o - 要搜索的元素。
	 * @return Number
	 */
	public function lastIndexOf(o : Object) : Number {
		var i:Number = _items.length;
		while(--i-(-1))
		{
			if(_items[i] === o) {
				return i;
			}
		}
		return -1;
	}



}
