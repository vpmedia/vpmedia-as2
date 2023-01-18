//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\ConcurrentLinkedQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * 一个基于链接节点的、无界的、线程安全的队列。此队列按照 FIFO（先进先出）原则对元素进行排序。队列的头部 是队列中时间最长的元素。队列的尾部 是队列中时间最短的元素。新的元素插入到队列的尾部，队列检索操作从队列头部获得元素。当许多线程共享访问一个公共 collection 时，ConcurrentLinkedQueue 是一个恰当的选择。此队列不允许 null 元素。 
 * 
 * 此实现采用了有效的“无等待 (wait-free)”算法，该算法基于 Maged M. Michael 和 Michael L. Scott 撰写的《 Simple, Fast, and Practical Non-Blocking and Blocking Concurrent Queue Algorithms》中描述的算法。 
 * 
 * 需要小心的是，与大多数 collection 不同，size 方法不是 一个固定时间的操作。由于这些队列的异步特性，确定当前元素的数量需要遍历这些元素。 
 * 
 * 此类及其迭代器实现了 Collection 和 Iterator 接口的所有可选 方法。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.ConcurrentLinkedQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC4C0109
	 */
	public function ConcurrentLinkedQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4C0128
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4C0213
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4C0290
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4C031C
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4C03A9
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC4D004E
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4D007C
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC4D0109
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4D0138
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC4D01D4
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBA0167
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBA0186
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2203B6
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD2203E5
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD23007A
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2300A8
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2300C8
	 */
	public function remove() : Object
	{
		return null;
	}
}
