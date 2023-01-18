import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.List;
import net.manaca.data.list.AbstractList;
import net.manaca.lang.exception.NoSuchElementException;
import net.manaca.data.list.EmptyStackException;
import net.manaca.lang.exception.UnsupportedOperationException;
import net.manaca.data.Search;

/**
 * SearchList提供一个支持普遍查询的类，你可以进行第一个，最后一个，上一个下一个的查询。
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.data.list.SearchList extends AbstractList implements List,Search {
	private var className : String = "net.manaca.data.list.SearchList";
	private var finger:Number;
	/**
	 * 构造函数
	 * @param arr 将一个数组传入（可选）
	 */
	public function SearchList(arr:Array) {
		super();
		if (arr) {
		   _items = arr.concat();
		}
		finger = -1;
	}

	/**
	 * 查看栈顶对象而不移除它。
	 * @return  Object 栈顶对象
	 * @throws {@link EmptyStackException} - 如果堆栈是空的。
	 */
	public function peek():Object{
        var i:Number = size();
        if(i == 0){
            throw new EmptyStackException("堆栈为空",this,arguments);
        }else{
            return _items[i - 1];
        }
    }
  
    /**
     * 把项压入栈顶
     * @param o 压入栈的项
     * @return Number 返回总长度
     */
	public function push(o:Object):Number{
		return _items.push(o); 
    }
    
    /**
     * 返回上一个可选择的元素
     * @return Object 上一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
    public function getBack():Object{
    	if (!hasBack()) {
			throw new NoSuchElementException("不存在的数据", this, arguments);
		}else{
			return this.Get(--finger);
		}
    }
    
    /**
     * 返回下一个可选择的元素
     * @return Object 下一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
    public function getNext():Object{
    	if (!hasNext()) {
			throw new NoSuchElementException("不存在的数据", this, arguments);
		}else{
			return this.Get(++finger);
		}
    }
	/**
	 * 返回当前位置
	 * @return Number 当前位置
	 */
	public function getFinger():Number{
		return finger;
	}
	
    /**
     * 如果存在上一个元素，则返回 true。
     */
    public function hasBack():Boolean{
    	return finger > 0 && this.size() > 1;
    }
    /**
     * 如果存在下一个元素，则返回 true。
     */
    public function hasNext():Boolean{
    	return this.size() > 1 && finger < this.size()-1;
    }
    
    /**
     * 移动指针
     * @param 要移动的位置
     * @return 移动成功则返回 对象
     * @throws NoSuchElementException 无法移动到该位置时抛出
     */
    public function move(n:Number):Object{
		if(n>=0 && n<this.size()){
			finger = n;
			return this.Get(finger);
		}else{
			throw new NoSuchElementException("无法移动到该位置", this, arguments);
		}
    }
    
    /**
	 * 查询元素位置
	 * @param 需要查询的元素
	 * @return Number 元素位置，如果没有此元素则返回－1
	 */
	public function search(o:Object):Number{
		return super.indexOf(o);
	}
	
    /**
     * 此方法被重写，删除所以元素
     */
	public function clear() : Void {
		super.clear();
		finger = -1;
	}
	
	/** 
	 * 此方法被重写，从此 collection 中移除指定元素的单个实例 
	 * @param o - 要从此 collection 中移除的元素（如果存在）。
	 * @return Boolean
	 */
	public function remove(o : Object) : Boolean {
		var result : Boolean = false;
		var itemIndex : Number = internalGetItem(o);
		if (itemIndex > -1) {
			_items.splice(itemIndex,1);
			result = true;
			//指针后退
			if(finger<=itemIndex) finger--;
		}
		return(result);
	}
	
	/** SearchList 不支持此方法 */
	public function addIn(o : Object, index : Number) : Boolean {
		throw new UnsupportedOperationException("使用不支持的方法",this,arguments);
		return null;
	}
	
	/** SearchList 不支持此方法 */
	public function addAll(c : Collection) : Boolean {
		throw new UnsupportedOperationException("使用不支持的方法",this,arguments);
		return null;
	}
	/** SearchList 不支持此方法 */
	public function removeAll(c : Collection) : Boolean {
		throw new UnsupportedOperationException("使用不支持的方法",this,arguments);
		return null;
	}
	/** SearchList 不支持此方法 */
	public function retainAll(c : Collection) : Boolean {
		throw new UnsupportedOperationException("使用不支持的方法",this,arguments);
		return null;
	}
	/** SearchList 不支持此方法 */
	public function iterator() : Iterator {
		throw new UnsupportedOperationException("使用不支持的方法",this,arguments);
		return null;
	}

	public function getAvailableCell() : Array {
		return this.toArray();
	}

}