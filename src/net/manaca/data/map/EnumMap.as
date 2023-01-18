//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\map\\EnumMap.java

//package net.manaca.data.map;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Map;
import net.manaca.data.map.AbstractMap;
import net.manaca.data.Set;

/**
 * 与枚举类型键一起使用的专用 Map 实现。枚举映射中所有键都必须来自单个枚举类型，该枚举类型在创建映射
 * 时显式或隐式地指定。枚举映射在内部表示为数组。此表示形式非常紧凑且高效。 
 * 
 * 枚举映射根据其键的自然顺序 来维护（该顺序是声明枚举常量的顺序）。在集合视图（keySet()、entrySet() 
 * 和 values()）所返回的迭代器中反映了这一点。 
 * 
 * 由集合视图返回的迭代器是弱一致 的：它们不会抛出 ConcurrentModificationException，也不一定显示在迭代
 * 进行时发生的任何映射修改的效果。 
 * 
 * 不允许使用 null 键。试图插入 null 键将抛出 NullPointerException。但是，试图测试是否出现 null 键或移
 * 除 null 键将不会抛出异常。允许使用 null 值。
 */
class net.manaca.data.map.EnumMap extends AbstractMap implements Map 
{
	private var className : String = "net.manaca.data.map.EnumMap";
	/**
	 * @roseuid 4386AD01024E
	 */
	public function EnumMap() 
	{
		super();
	}
	
	/**
	 * @return Void
	 * @roseuid 4386AD01027D
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param key
	 * @return Boolean
	 * @roseuid 4386AD0102AC
	 */
	public function containsKey(key:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param value
	 * @return Boolean
	 * @roseuid 4386AD010348
	 */
	public function containsValue(value:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD0103D5
	 */
	public function entrySet() : Set
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD02001C
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param key
	 * @return Object
	 * @roseuid 4386AD0200C8
	 */
	public function get(key:Object) : Object
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4386AD020164
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD020193
	 */
	public function keySet() : Set
	{
		return null;
	}
	
	/**
	 * @param key
	 * @param value
	 * @return Boolean
	 * @roseuid 4386AD0201D1
	 */
	public function put(key:Object,value:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param t
	 * @return Void
	 * @roseuid 4386AD0202DB
	 */
	public function putAll(t:Map) : Void
	{
		//return null;
	}
	
	/**
	 * @param key
	 * @return Object
	 * @roseuid 4386AD020387
	 */
	public function remove(key:Object) : Object
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4386AD03004B
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Collection
	 * @roseuid 4386AD030089
	 */
	public function values() : Collection
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4386AD0300C8
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
}
