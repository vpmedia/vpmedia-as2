import net.manaca.data.Iterator;
import net.manaca.data.List;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.lang.exception.NoSuchElementException;
import net.manaca.lang.exception.IllegalStateException;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\iterator\\ArrayIterator.java

//package net.manaca.data.iterator;
/**
 * 基本的列表迭代
 * 
 * <p>Example:
 * <code>
 *   var list:List = new MyList();
 *   list.insert("value1");
 *   list.insert("value2");
 *   list.insert("value3");
 *   var iterator:Iterator = new ListIterator(list);
 *   while (iterator.hasNext()) {
 *       trace(iterator.next());
 *   }
 * </code>
 * 
 * @author Wersling
 * @version 1.0
 */

class net.manaca.data.iterator.ListIterator implements Iterator 
{
	private var className : String = "net.manaca.data.iterator.ListIterator";
	//需要迭代的目标
	private var target:List;
	//迭代指针
	private var i:Number;
	/**
	 * 构造函数
	 * @param target 需要迭代的目标
	 * @throws 传入的参数为空则抛出 {@link IllegalArgumentException}
	 * @roseuid 4386ACEC0377
	 */
	public function ListIterator(target:List)
	{
		if (!target) throw new IllegalArgumentException("在构造："+className+"时传入的参数为空", this, [target]);
		this.target = target;
		this.i = -1;
	}
	
	/**
	 * 如果仍有元素可以迭代，则返回 true。
	 * @return Boolean
	 * @roseuid 4386ACEC03A6
	 */
	public function hasNext() : Boolean
	{
		return (this.i < this.target.size() - 1);
	}
	
	/**
	 * @return Object
	 * @roseuid 4386ACEC03D5
	 */
	public function next() : Object
	{
		if (!hasNext()) {
			throw new NoSuchElementException("不存在的数据", this, arguments);
		}else{
			return this.target.Get(++this.i);
		}
	}
	
	/**
	 * @return Void
	 * @roseuid 4386ACED001C
	 */
	public function remove() : Void
	{
		if (this.i < 0) {
			throw new IllegalStateException("找不到可以移除的对象", this, arguments);
		}
		this.target.remove(this.target.Get(this.i));
	}
}
