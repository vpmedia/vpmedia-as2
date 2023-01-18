import net.manaca.data.collection.AbstractCollection;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\AbstractQueue.java

//package net.manaca.data;


/**
 * 此类提供某些 Queue 操作的骨干实现。此类中的实现适用于基本实现不 允许包含 null 元素时。add、remove 和 element 方法分别基于 offer、poll 和 peek 方法，但是它们通过抛出异常而不是返回 false 或 null 来指示失败。 
 * 扩展此类的 Queue 实现至少必须定义一个不允许插入 null 元素的 Queue.offer(E) 方法，该方法以及 Queue.peek()、Queue.poll()、Collection.size() 和 Collection.iterator() 都支持 Iterator.remove() 方法。通常还要重写其他方法。如果无法满足这些要求，那么可以转而考虑为 AbstractCollection 创建子类。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.queue.AbstractQueue extends AbstractCollection
{
	
	/**
	 * @roseuid 4382EC49035B
	 */
	public function AbstractQueue() 
	{
		
	}
}
