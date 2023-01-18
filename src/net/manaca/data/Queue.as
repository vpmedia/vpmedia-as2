﻿import net.manaca.data.Collection;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\Queue.java

//package net.manaca.data;


/**
 * 在处理元素前用于保存元素的集合。除了基本的 Collection 操作外，队列还提供其他的插入、提取和检查操作。 
 * 队列通常（但并非一定）以 FIFO（先进先出）的方式排序各个元素。不过优先级队列和 LIFO 队列（或堆栈）例外，前者根据提供的比较器或元素的自然顺序对元素进行排序，后者按 LIFO（后进先出）的方式对元素进行排序。无论使用哪种排序方式，队列的头 都是调用 remove() 或 poll() 所移除的元素。在 FIFO 队列中，所有的新元素都插入队列的末尾。其他种类的队列可能使用不同的元素放置规则。每个 Queue 实现必须指定其顺序属性。 
 * 如果可能，offer 方法可插入一个元素，否则返回 false。这与 Collection.add 方法不同，该方法只能通过抛出未经检查的异常使添加元素失败。offer 方法设计用于正常的失败情况，而不是出现异常的情况，例如在容量固定（有界）的队列中。 
 * remove() 和 poll() 方法可移除和返回队列的头。到底从队列中移除哪个元素是队列排序策略的功能，而该策略在各种实现中是不同的。remove() 和 poll() 方法仅在队列为空时其行为有所不同：remove() 方法抛出一个异常，而 poll() 方法则返回 null。 
 * element() 和 peek() 返回，但不移除，队列的头。 
 * Queue 接口并未定义阻塞队列的方法，而这在并发编程中是很常见的。BlockingQueue 接口定义了那些等待元素出现或等待队列中有可用空间的方法，这些方法扩展了此接口。 
 * Queue 实现通常不允许插入 null 元素，尽管某些实现（如 LinkedList）并不禁止插入 null。即使在允许 null 的实现中，也不应该将 null 插入到 Queue 中，因为 null 也用作 poll 方法的一个特殊返回值，表明队列不包含元素。 
 * Queue 实现通常未定义 equals 和 hashCode 方法的基于元素的版本，而是从 Object 类继承了基于身份的版本，因为对于具有相同元素但有不同排序属性的队列而言，基于元素的相等性并非总是定义良好的。
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.data.Queue extends Collection 
{
	
	/**
	 * 检索，但是不移除此队列的头。此方法与 peek 方法的惟一不同是，如果此队列为空，它会抛出一个异常。
	 * @return Object
	 * @roseuid 4386A1E202DB
	 */
	public function element() : Object;
	
	/**
	 * 如果可能，将指定的元素插入此队列。使用可能有插入限制（例如容量限定）的队列时，offer 方法通常要优于 Collection.add(E) 方法，因为后者只能通过抛出异常使插入元素失败。
	 * @param o - 要插入的元素。 
	 * 
	 * @return Boolean
	 * @roseuid 4386A1FF03D5
	 */
	public function offer(o:Object) : Boolean;
	
	/**
	 * 检索并移除此队列的头，如果此队列为空，则返回 null。
	 * @return Object
	 * @roseuid 4386A2450106
	 */
	public function poll() : Object;
	
	/**
	 * 检索，但是不移除此队列的头，如果此队列为空，则返回 null。
	 * @return Object
	 * @roseuid 4386A2560183
	 */
	public function peek() : Object;
	
	/**
	 * 检索并移除此队列的头。此方法与 poll 方法的不同在于，如果此队列为空，它会抛出一个异常。
	 * @return Object
	 * @roseuid 4386A26F02AC
	 */
	public function remove() : Object;
}
