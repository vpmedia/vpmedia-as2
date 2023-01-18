import net.manaca.lang.BObject;
import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.iterator.IteratorImpl;
import net.manaca.lang.exception.UnsupportedOperationException;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\AbstractCollection.java

//package was.util;


/**
 * 此类提供了 Collection 接口的骨干实现，从而最大限度地减少了实现此接口所需的工作。 
 * 
 * 要实现一个不可修改的 collection，程序员只需扩展此类，并提供 iterator 和 size 方法的实现。
 * （iterator 方法返回的迭代器必须实现 hasNext 和 next。）
 * 
 * 要实现可修改的 collection，程序员还必须另外重写此类的 add 方法
 * （否则，会抛出 UnsupportedOperationException），并且 iterator 方法返回的迭代器必须另外实现其 remove 方法。
 * 
 * 按照 Collection 接口规范中的推荐，程序员通常应该提供一个 void （无参数）和 Collection 构造方法。
 * 
 * 此类中每个非抽象方法的文档详细描述了其实现。如果要实现的 collection 允许更有效的实现，则可以重写这些方法中
 * 的每个方法。
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.collection.AbstractCollection extends BObject implements Collection
{
	private var className : String = "net.manaca.data.collection.AbstractCollection";
	public var classOwner:Object = AbstractCollection;
	private var _items : Array;
	
	/**
	 * 实例化Collection
	 * @roseuid 4382E72903D8
	 */
	private function AbstractCollection()
	{
		super();
		_items = new Array();
	}
	
	/** 
	 * 添加一个元素，这里并不保证添加的元素是否非空
	 * @param o - 要添加的元素.
	 * @return Boolean 添加是否成功
	 */
	public function Add(o : Object) : Boolean {
		throw new UnsupportedOperationException("AbstractCollection.Add方法无法执行，需要在其子类实现",this);
		return null;
	}
	
	/** 
	 * 从此 collection 中移除指定元素的单个实例 
	 * @param o - 要从此 collection 中移除的元素（如果存在）。
	 * @return Boolean
	 */
	public function remove(o : Object) : Boolean {
		var result : Boolean = false;
		var itemIndex : Number = internalGetItem(o);
		if (itemIndex > -1) {
			_items.splice(itemIndex,1);
			result = true;
		}
		return(result);
	}
	
	/** 
	 * 如果此 collection 包含指定的元素，则返回 true。
	 * @param o - 测试在此 collection 中是否存在的元素。
	 * @return Boolean
	 */
	public function contains(o : Object) : Boolean {
		return(internalGetItem(o)>-1);
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
	 * 将指定 collection 中的所有元素都添加到此 collection 中（可选操作）。 
	 * @param c - 要插入到此 collection 的元素。
	 * @return Boolean 在传入的 Collection 为空时返回 False
	 */
	public function addAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		_items = _items.concat(c.toArray());
		return true;
	}

	/** 
	 * 移除此 collection 中那些也包含在指定 collection 中的所有元素
	 * @param c - 要从此 collection 移除的元素。
	 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
	 */ 
	public function removeAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		var result:Boolean = false;
		var i:Number = c.size();
		var _iterator:Iterator = c.iterator();
		while(--i-(-1)){
			if(remove(_iterator.next())){
				result = true;
			}
		}
		return result;
	}
	
	/** 仅保留此 collection 中那些也包含在指定 collection 的元素 */
	public function retainAll(c : Collection) : Boolean {
		if(c.isEmpty()){ 
			clear();
			return true;
		}
		var result:Boolean = false;
		var i:Number = this.size();
		while(--i-(-1)){
			if(!c.contains(_items[i])){
				_items.splice(i,1);
				result = true;
			}
		}
		return (result);
	}
	
	/** 
	 * 移除此 collection 中的所有元素 
	 * @param c - 保留在此 collection 中的元素。
	 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
	 */
	public function clear() : Void {
		_items.length = 0;
		_items = new Array();
	}

	/** 
	 * 比较此 collection 与指定对象是否相等。 
	 * @param obj
	 * @return Boolean
	 */
	public function equals(o : Object) : Boolean {
		var result:Boolean = true;
		var _o:Collection = Collection(o);
		var i:Number = this.size();
		while(--i-(-1)){
			if(!_o.contains(_items[i])){
				result = false;
				break;
			}
		}
		return result;
	}
	/** 如果此 collection 不包含元素，则返回 true。*/
	public function isEmpty() : Boolean {
		return ( _items.length == 0 );
	}
	
	/** 返回此 collection 中的元素数。 */
	public function size() : Number {
		return _items.length;
	}

	/** 返回包含此 collection 中所有元素的数组。 */
	public function toArray() : Array {
		return _items;
	}
	
	/** 
	 * 返回一个在一组元素上进行迭代的迭代器。
	 * 注意：不要在for语句中重复使用此方法，否则将导致重复实例。
	 */
	public function iterator() : Iterator {
		return(new IteratorImpl(this));
	}
	
	/** 返回指定的元素 */
	public function getItemAt(i : Number) : Object {
		return (_items[i]);
	}
	
	/** 
	 * 返回元素所在编号
	 * @param item 一个元素
	 * @return Number 元素所在编号
	 */
	private function internalGetItem(item:Object):Number {
		var result:Number = -1;
		var i:Number = _items.length;
		while(--i-(-1)){
			if (_items[i] == item) {
				result = i;
				break;
			}
		}
		return result; 
	}
}
