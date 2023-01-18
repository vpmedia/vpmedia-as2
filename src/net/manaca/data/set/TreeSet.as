//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\set\\TreeSet.java

//package net.manaca.data.set;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.set.AbstractSet;

/**
 * 此类实现 Set 接口，该接口由 TreeMap 实例支持。此类保证排序后的 set 按照升序排列元素，根据使用的构造方法不同，可能会按照元素的自然顺序 进行排序（参见 Comparable），或按照在创建 set 时所提供的比较器进行排序。
 * 
 * 此实现为基本操作（add、remove 和 contains）提供了可保证的 log(n) 时间开销。
 * 
 * 注意，如果要正确实现 Set 接口，则 set 所维护的顺序（是否提供了显式比较器）必须为与 equals 方法一致（请参阅与 equals 方法一致 精确定义的 Comparable 或 Comparator）。这是因为 Set 接口根据 equals 操作进行定义，但 TreeSet 实例将使用其 compareTo（或 compare）方法执行所有的键比较，因此，从 set 的角度出发，该方法认为相等的两个键就是相等的。即使 set 的顺序与 equals 方法不一致，其行为也是 定义良好的；它只是违背了 Set 接口的常规协定。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.set.TreeSet extends AbstractSet 
{
	
	/**
	 * @roseuid 4382EC5903B9
	 */
	public function TreeSet() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5903D8
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5A005D
	 */
	public function remove(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5A00DA
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5A0148
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5A01C5
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5A0242
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC5A02BF
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5A02ED
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC5A036A
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5A03A9
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC5B005D
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBC00AB
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBC00CB
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 43847B9803D8
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B99002E
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B99004E
	 */
	public function peek() : Object
	{
		return null;
	}
}
