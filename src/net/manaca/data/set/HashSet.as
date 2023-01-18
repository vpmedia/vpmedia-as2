//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\set\\HashSet.java

//package net.manaca.data.set;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.set.AbstractSet;
import net.manaca.data.Set;

/**
 * 此类实现 Set 接口，由哈希表（实际上是一个 HashMap 实例）支持。它不保证集合的迭代顺序；特别是它不保证
 * 该顺序恒久不变。此类允许使用 null 元素。
 * 
 * 此类为基本操作提供了稳定性能，这些基本操作包括 add、remove、contains 和 size，假定哈希函数将这些元素
 * 正确地分布在桶中。对此集合进行迭代所需的时间与 HashSet 实例的大小（元素的数量）和底层 HashMap 实例（
 * 桶的数量）的“容量”的和成比例。因此，如果迭代性能很重要，则不要将初始容量设置得太高（或将加载因子设
 * 置得太低）。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.set.HashSet extends AbstractSet implements Set
{
	private var className : String = "net.manaca.data.set.HashSet";
	/**
	 * @roseuid 4382EC51032C
	 */
	public function HashSet() 
	{
		super();
	}
	
	/** 
	 * 添加一个元素，不允许数据重复，允许一个null
	 * @param o - 要添加的元素
	 * @return Boolean 添加是否成功
	 */
	public function Add(o:Object) : Boolean
	{
		return super.Add(o);
	}
	
	/** 
	 * 从此 collection 中移除指定元素的单个实例 
	 * @param o - 要从此 collection 中移除的元素（如果存在）。
	 * @return Boolean
	 */
	public function remove(o:Object) : Boolean
	{
		return super.remove(o);
	}
	/**
	 * 移除此 collection 中的所有元素
	 * @return Void
	 * @roseuid 4382EC520251
	 */
	public function clear() : Void
	{
		super.clear();
	}
	
	/**
	 * 比较此 collection 与指定对象是否相等。 
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC520270
	 */
	public function equals(o:Object) : Boolean
	{
		return super.equals(o);
	}
	
	/**
	 * 如果此 collection 不包含元素，则返回 true。
	 * @return Boolean
	 * @roseuid 4382EC5202FD
	 */
	public function isEmpty() : Boolean
	{
		return super.isEmpty();
	}
	
	/** 
	 * 如果此 collection 包含指定的元素，则返回 true。
	 * @param o - 测试在此 collection 中是否存在的元素。
	 * @return Boolean
	 */
	public function contains(o:Object) : Boolean
	{
		return super.contains(o);
	}
	
	/**
	 * 返回一个在一组元素上进行迭代的迭代器。
	 * 注意：不要在for语句中重复使用此方法，否则将导致重复实例。
	 * @return Iterator
	 * @roseuid 4382EC5203C8
	 */
	public function iterator() : Iterator
	{
		return super.iterator();
	}
	
	/**
	 * 返回此 collection 中的元素数。
	 * @return Number
	 * @roseuid 4382EDBB001F
	 */
	public function size() : Number
	{
		return super.size();
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBB003E
	 */
	public function toArray() : Array
	{
		return super.toArray();
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 43847B990290
	 */
	public function offer(o:Object) : Boolean
	{
		cannotEmployMethod("offer");
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B9902CE
	 */
	public function poll() : Object
	{
		cannotEmployMethod("poll");
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B9902ED
	 */
	public function peek() : Object
	{
		cannotEmployMethod("peek");
		return null;
	}
	/**
	 * 抛出一个错误，在方法不可调用的时候
	 * @param funName 方法名
	 */
	private function cannotEmployMethod(funName:String):Void{
		throw new net.manaca.lang.error.CannotEmployMethodError("不可调用此方法",this,[funName]);
	}
}
