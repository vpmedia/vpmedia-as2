import net.manaca.data.List;
import net.manaca.data.list.AbstractList;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\list\\Vector.java

//package net.manaca.data.list;


/**
 * Vector 类可以实现可增长的对象数组。与数组一样，它包含可以使用整数索引进行访问的组件。但是，
 * Vector 的大小可以根据需要增大或缩小，以适应创建 Vector 后进行添加或移除项的操作。
 * 
 * 每个向量会试图通过维护 capacity 和 capacityIncrement 来优化存储管理。capacity 始终至少应与向量的大小相等；
 * 这个值通常比后者大些，因为随着将组件添加到向量中，其存储将按 capacityIncrement 的大小增加存储块。应用程序可
 * 以在插入大量组件前增加向量的容量；这样就减少了增加的重分配的量。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.list.Vector extends AbstractList  implements List
{
	
	/**
	 * @roseuid 4382EC5B0119
	 */
	public function Vector(arr:Array) 
	{
		super();
		if(arr.length>0){
			_items = arr.slice();
		}
	}
//	
//	/**
//	 * @param o
//	 * @param index
//	 * @return Boolean
//	 * @roseuid 43847B9703D8
//	 */
//	public function addIn(o:Object,index:Number) : Boolean
//	{
//		return null;
//	}
//	
//	/**
//	 * @return Number
//	 * @roseuid 4382EDBC0128
//	 */
//	public function size() : Number
//	{
//		return super.size();
//	}
//	
//	/**
//	 * @return Array
//	 * @roseuid 4382EDBC0148
//	 */
//	public function toArray() : Array
//	{
//		return null;
//	}
//	
//	/**
//	 * @param index
//	 * @return Object
//	 * @roseuid 43846225005D
//	 */
//	public function Get(index:Number) : Object
//	{
//		return null;
//	}
//	
//	/**
//	 * @param index
//	 * @param element
//	 * @return Object
//	 * @roseuid 4384622500AB
//	 */
//	public function Set(index:Number,element:Object) : Object
//	{
//		return null;
//	}
//	
//	/**
//	 * @param o
//	 * @return Number
//	 * @roseuid 438462250119
//	 */
//	public function indexOf(o:Object) : Number
//	{
//		return null;
//	}
//	
//	/**
//	 * @param o
//	 * @return Number
//	 * @roseuid 438462250167
//	 */
//	public function lastIndexOf(o:Object) : Number
//	{
//		return null;
//	}

}
