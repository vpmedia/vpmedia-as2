//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\DelayQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * Delayed 元素的一个无界阻塞队列，只有在延迟期满时才能从中提取元素。该队列的头部 是延迟期满后保存时间最长的 Delayed 元素。如果延迟都还没有期满，则队列没有头部，并且 poll 将返回 null。当一个元素的 getDelay(TimeUnit.NANOSECONDS) 方法返回一个小于或等于零的值时，则出现期满。此队列不允许使用 null 元素。 
 * 
 * 此类及其迭代器实现了 Collection 和 Iterator 接口的所有可选 方法。 
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.DelayQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC4F004E
	 */
	public function DelayQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4F007C
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}
	

	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4F0167
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4F01D4
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4F0261
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4F02DE
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC4F036A
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4F0399
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC50003E
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC50006D
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC500109
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBA02BF
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBA02DE
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD230193
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD2301C2
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD23021F
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD23024E
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD23026E
	 */
	public function remove() : Object
	{
		return null;
	}
}
