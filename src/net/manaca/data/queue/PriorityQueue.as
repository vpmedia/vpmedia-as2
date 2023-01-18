//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\PriorityQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * 一个基于优先级堆的极大优先级队列。此队列按照在构造时所指定的顺序对元素排序，既可以根据元素的自然顺序 来指定排序（参阅 Comparable），也可以根据 Comparator 来指定，这取决于使用哪种构造方法。优先级队列不允许 null 元素。依靠自然排序的优先级队列还不允许插入不可比较的对象（这样做可能导致 ClassCastException）。 
 * 
 * 此队列的头 是按指定排序方式的最小 元素。如果多个元素都是最小值，则头是其中一个元素——选择方法是任意的。队列检索操作 poll、remove、peek 和 element 访问处于队列头的元素。 
 * 
 * 优先级队列是无界的，但是有一个内部容量，控制着用于存储队列元素的数组的大小。它总是至少与队列的大小相同。随着不断向优先级队列添加元素，其容量会自动增加。无需指定容量增加策略的细节。 
 * 
 * 此类及其迭代器实现了 Collection 和 Iterator 接口的所有可选 方法。方法 iterator() 中提供的迭代器并不 保证以任意特定的顺序遍历优先级队列中的元素。如果需要按顺序遍历，请考虑使用 Arrays.sort(pq.toArray())。 
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.PriorityQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC56031C
	 */
	public function PriorityQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC56034B
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}
	

	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC57004E
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5700CB
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC570157
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5701E4
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC570261
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC57029F
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC57032C
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC57036A
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC58001F
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBB02ED
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBB030D
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD25005A
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD2500A8
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD250164
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2501A2
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2501E1
	 */
	public function remove() : Object
	{
		return null;
	}
}
