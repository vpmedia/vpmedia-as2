import net.manaca.data.List;
import net.manaca.data.list.AbstractSequentialList;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\list\\LinkedList.java

//package net.manaca.data.list;


/**
 * List 接口的链接列表实现。实现所有可选的列表操作，并且允许所有元素（包括 null）。除了实现 List 接口外，
 * LinkedList 类还为在列表的开头及结尾 get、remove 和 insert 元素提供了统一的命名方法。这些操作允许将链接
 * 列表用作堆栈、队列或双端队列 (deque)。
 * 
 * 此类实现 Queue 接口，为 add、poll 等提供先进先出队列操作。其他堆栈和双端队列操作可以根据标准列表操作方便
 * 地进行再次强制转换。虽然它们可能比等效列表操作运行稍快，但是将其包括在这里主要是出于方便考虑。
 * 
 * 所有操作都是按照双重链接列表的需要执行的。在列表中编索引的操作将从开头或结尾遍历列表（从靠近指定索引的一
 * 端）。
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.list.LinkedList extends AbstractSequentialList  implements List
{
	
	/**
	 * @roseuid 4382EC55002E
	 */
	public function LinkedList() 
	{
		
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBB0167
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBB0196
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @param index
	 * @return Object
	 * @roseuid 438462250213
	 */
	public function Get(index:Number) : Object
	{
		return null;
	}
	
	/**
	 * @param index
	 * @param element
	 * @return Object
	 * @roseuid 438462250261
	 */
	public function Set(index:Number,element:Object) : Object
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Number
	 * @roseuid 4384622502ED
	 */
	public function indexOf(o:Object) : Number
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Number
	 * @roseuid 43846225033C
	 */
	public function lastIndexOf(o:Object) : Number
	{
		return null;
	}
	
	/**
	 * @param o
	 * @param index
	 * @return Boolean
	 * @roseuid 43847B99035B
	 */
	public function addIn(o:Object,index:Number) : Boolean
	{
		return null;
	}
}
