import net.manaca.data.Collection;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\Set.java

//package net.manaca.data;


/**
 * 一个不包含重复元素的 collection。更正式地说，set 不包含满足 e1.equals(e2) 的元素对 e1 和 e2，
 * 并且最多包含一个 null 元素。正如其名称所暗示的，此接口模仿了数学上的 set 抽象。
 * 
 * 在所有构造方法以及 add、equals 和 hashCode 方法的协定上，Set 接口还加入了其他规定，这些规定超出了
 * 从 Collection 接口所继承的内容。出于方便考虑，它还包括了其他继承方法的声明（这些声明的规范已经专门
 * 针对 Set 接口进行了修改，但是没有包含任何其他的规定）。
 * 
 * 对这些构造方法的其他规定是（不要奇怪），所有构造方法必须创建一个不包含重复元素的 set（正如上面所定义的）。
 * 注：如果将可变对象用作 set 元素，那么必须极其小心。如果对象是 set 中某个元素，以一种影响 equals 比较的
 * 方式改变对象的值，那么 set 的行为就是不确定的。此项禁止的一个特殊情况是不允许某个 set 包含其自身作为元素。 
 * 某些 set 实现对其所包含的元素有所限制。例如，某些实现禁止 null 元素，而某些则对其元素的类型所有限制。试
 * 图添加不合格的元素会抛出未经检查的异常，通常是 NullPointerException 或 ClassCastException。试图查询不合
 * 格的元素是否存在可能会抛出异常，也可能只是返回 false；某些实现会表现为前一种行为，某些则表现为后者。
 * 
 * 概括地说，试图对不合格元素执行操作时，如果完成该操作后不会导致在 set 中插入不合格的元素，则该操作可能
 * 抛出一个异常，也可能成功，这取决于实现的选择。此接口的规范中将这样的异常标记为“可选”。
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.data.Set extends Collection 
{
	
	/**
	 * 如果可能，将指定的元素插入此队列。使用可能有插入限制（例如容量限定）的队列时，
	 * offer 方法通常要优于 Collection.add(E) 方法，因为后者只能通过抛出异常使插入元素失败。
	 * @param o - 要插入的元素。 
	 * @return Boolean
	 * @roseuid 43846141008C
	 */
	public function offer(o:Object) : Boolean;
	
	/**
	 * 检索并移除此队列的头，如果此队列为空，则返回 null。
	 * @return Object
	 * @roseuid 4384617F00BB
	 */
	public function poll() : Object;
	
	/**
	 * 检索，但是不移除此队列的头，如果此队列为空，则返回 null。
	 * @return Object
	 * @roseuid 438461F40176
	 */
	public function peek() : Object;
}
