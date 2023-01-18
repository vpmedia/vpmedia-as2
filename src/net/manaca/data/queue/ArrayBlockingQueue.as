//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\ArrayBlockingQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * 一个由数组支持的有界阻塞队列。此队列按 FIFO（先进先出）原则对元素进行排序。队列的头部 是在队列中存在时间最长的元素。队列的尾部 是在队列中存在时间最短的元素。新元素插入到队列的尾部，队列检索操作则是从队列头部开始获得元素。 
 * 
 * 这是一个典型的“有界缓存区”，固定大小的数组在其中保持生产者插入的元素和使用者提取的元素。一旦创建了这样的缓存区，就不能再增加其容量。试图向已满队列中放入元素会导致放入操作受阻塞；试图从空队列中检索元素将导致类似阻塞。 
 * 
 * 此类支持对等待的生产者线程和使用者线程进行排序的可选公平策略。默认情况下，不保证是这种排序。然而，通过将公平性 (fairness) 设置为 true 而构造的队列允许按照 FIFO 顺序访问线程。公平性通常会降低吞吐量，但也减少了可变性和避免了“不平衡性”。 
 * 
 * 此类及其迭代器实现了 Collection 和 Iterator 接口的所有可选 方法。 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.ArrayBlockingQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC4A0196
	 */
	public function ArrayBlockingQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4A01C5
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}

	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4A02AF
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4A032C
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4A03A9
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4B004E
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC4B00DA
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4B0109
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC4B0196
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4B01C5
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC4B0261
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDB90399
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDB903B9
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2201C2
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD2201F1
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD22026E
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD22029C
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2202CB
	 */
	public function remove() : Object
	{
		return null;
	}
}
