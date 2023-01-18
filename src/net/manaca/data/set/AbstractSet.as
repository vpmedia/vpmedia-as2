import net.manaca.data.collection.AbstractCollection;
import net.manaca.data.Collection;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\AbstractSet.java

//package net.manaca.data;


/**
 * 此类提供 Set 接口的骨干实现，从而最大限度地减少了实现此接口所需的工作。
 * 
 * 通过扩展此类来实现一个 set 的过程与通过扩展 AbstractCollection 来实现 Collection 的过程是相同的，
 * 除了此类的子类中的所有方法和构造方法都必须服从 Set 接口所强加的额外限制（例如，add 方法必须不允许将一
 * 个对象的多个实例添加到一个 set 中）。
 * 
 * 注意，此类并没有重写 AbstractCollection 类中的任何实现。它仅仅添加了 equals 和 hashCode 的实现。
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.set.AbstractSet extends AbstractCollection
{
	
	/**
	 * @roseuid 4382EC4A00F9
	 */
	public function AbstractSet() 
	{
		super();
	}
	/**
	 * 如果可能，将指定的元素插入此队列。使用可能有插入限制（例如容量限定）的队列时，
	 * offer 方法通常要优于 Collection.add(E) 方法，因为后者只能通过抛出异常使插入元素失败。
	 * @param o - 要插入的元素。 
	 * @return Boolean
	 * @roseuid 43846141008C
	 */
	public function offer(o : Object) : Boolean {
		return Add(o);
	}

	public function poll() : Object {
		return null;
	}

	public function peek() : Object {
		return null;
	}
	/** 
	 * 添加一个元素，不允许数据重复，允许一个null
	 * @param o - 要添加的元素
	 * @return Boolean 添加是否成功
	 */
	public function Add(o : Object) : Boolean {
		var result:Boolean = false;
		if (!contains(o)) {
			_items.push(o);
			result = true;
		}
		return(result);
	}
	/** 
	 * 将指定 collection 中的所有元素都添加到此 collection 中（可选操作）。 
	 * @param c - 要插入到此 collection 的元素。
	 * @return Boolean 在传入的 Collection 为空时返回 False
	 */
	public function addAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		for (var i : Number = 0; i < c.size(); i++) {
			Add(c.getItemAt(i));
		}
		return true;
	}
}
