//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\PriorityBlockingQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * 一个无界的阻塞队列，它使用与类 PriorityQueue 相同的顺序规则，并且提供了阻塞检索的操作。虽然此队列逻辑上是无界的，但是由于资源被耗尽，所以试图执行添加操作可能会失败（导致 OutOfMemoryError）。此类不允许使用 null 元素。依赖自然顺序的优先级队列也不允许插入不可比较的对象（因为这样做会抛出 ClassCastException）。 
 * 
 * 此类及其迭代器可以实现 Collection 和 Iterator 接口的所有可选 方法。iterator() 方法中所提供的迭代器并不 保证以特定的顺序遍历 PriorityBlockingQueue 的元素。如果需要有序地遍历，则应考虑使用 Arrays.sort(pq.toArray())。 
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.PriorityBlockingQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC5501A5
	 */
	public function PriorityBlockingQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5501C5
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}

	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5502AF
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC55032C
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC5503A9
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC56004E
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC5600DA
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC560109
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC560196
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5601C5
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC560261
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBB0242
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBB0261
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD240154
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD2401A2
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD24026E
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2402AC
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2402FA
	 */
	public function remove() : Object
	{
		return null;
	}
}
