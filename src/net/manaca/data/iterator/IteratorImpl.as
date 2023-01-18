import net.manaca.data.Collection;
import net.manaca.data.Iterator;


/**
 * 实现对集合进行迭代的迭代器。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.iterator.IteratorImpl implements Iterator {
	private var className : String = "net.manaca.data.iterator.IteratorImpl";

	private var _collection : Collection;

	private var _cursor : Number;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function IteratorImpl(c :Collection) {
		_collection = c;
		_cursor = 0;
	}
	/** 如果仍有元素可以迭代，则返回 true。 */
	public function hasNext() : Boolean {
		return (_cursor < _collection.size());
	}
	/** 返回迭代的下一个元素。 */
	public function next() : Object {
		return(_collection.getItemAt(_cursor++));
	}
	/** 从迭代器指向的集合中移除迭代器返回的最后一个元素 */
	public function remove() : Void {
		_collection.toArray().pop();
	}
}