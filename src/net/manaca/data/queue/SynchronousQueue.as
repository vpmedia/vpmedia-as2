//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\queue\\SynchronousQueue.java

//package net.manaca.data.queue;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Queue;
import net.manaca.data.queue.AbstractQueue;

/**
 * 一种阻塞队列，其中每个 put 必须等待一个 take，反之亦然。同步队列没有任何内部容量，甚至连一个队列的容量都没有。不能在同步队列上进行 peek，因为仅在试图要取得元素时，该元素才存在；除非另一个线程试图移除某个元素，否则也不能（使用任何方法）添加元素；也不能迭代队列，因为其中没有元素可用于迭代。队列的头 是尝试添加到队列中的首个已排队线程元素；如果没有已排队线程，则不添加元素并且头为 null。对于其他 Collection 方法（例如 contains），SynchronousQueue 作为一个空集合。此队列不允许 null 元素。 
 * 
 * 同步队列类似于 CSP 和 Ada 中使用的 rendezvous 信道。它非常适合于传递性设计，在这种设计中，在一个线程中运行的对象要将某些信息、事件或任务传递给在另一个线程中运行的对象，它就必须与该对象同步。 
 * 
 * 对于正在等待的生产者和使用者线程而言，此类支持可选的公平排序策略。默认情况下不保证这种排序。但是，使用公平设置为 true 所构造的队列可保证线程以 FIFO 的顺序进行访问。公平通常会降低吞吐量，但是可以减小可变性并避免得不到服务。 
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.SynchronousQueue extends AbstractQueue implements Queue 
{
	
	/**
	 * @roseuid 4382EC580176
	 */
	public function SynchronousQueue() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC580196
	 */
	public function add(o:Object) : Boolean
	{
		return null;
	}
	

	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC580290
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC58030D
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC580399
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC59003E
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC5900CB
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5900F9
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC590196
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC5901C5
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC590261
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBB03D8
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBC000F
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2502DB
	 */
	public function element() : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD25030A
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD250377
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2503A6
	 */
	public function peek() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 4386AD2503D5
	 */
	public function remove() : Object
	{
		return null;
	}
}
