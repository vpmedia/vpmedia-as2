//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\map\\HashMap.java

//package net.manaca.data.map;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Map;
import net.manaca.data.map.AbstractMap;
import net.manaca.data.Set;
import net.manaca.data.set.HashSet;
import net.manaca.data.list.ArrayList;
import net.manaca.lang.IObject;

/**
 * 基于哈希表的 Map 接口的实现。此实现提供所有可选的映射操作，并允许使用 null 值和 null 键。
 * （除了不同步和允许使用 null 之外，HashMap 类与 Hashtable 大致相同。）此类不保证映射的顺序，
 * 特别是它不保证该顺序恒久不变。 
 * 
 * 此实现假定哈希函数将元素正确分布在各桶之间，可为基本操作（get 和 put）提供稳定的性能。
 * 迭代集合视图所需的时间与 HashMap 实例的“容量”（桶的数量）及其大小（键-值映射关系数）的和成比例。
 * 所以，如果迭代性能很重要，则不要将初始容量设置得太高（或将加载因子设置得太低）。 
 * 
 * HashMap 的实例有两个参数影响其性能：初始容量 和加载因子。容量 是哈希表中桶的数量，初始容量只是哈
 * 希表在创建时的容量。加载因子 是哈希表在其容量自动增加之前可以达到多满的一种尺度。当哈希表中的条目
 * 数超出了加载因子与当前容量的乘积时，通过调用 rehash 方法将容量翻倍。 
 * 
 * 通常，默认加载因子 (.75) 在时间和空间成本上寻求一种折衷。加载因子过高虽然减少了空间开销，但同时也增
 * 加了查询成本（在大多数 HashMap 类的操作中，包括 get 和 put 操作，都反映了这一点）。在设置初始容量时
 * 应该考虑到映射中所需的条目数及其加载因子，以便最大限度地降低 rehash 操作次数。如果初始容量大于最大条
 * 目数除以加载因子，则不会发生 rehash 操作。 
 * 
 * 如果很多映射关系要存储在 HashMap 实例中，则相对于按需执行自动的 rehash 操作以增大表的容量来说，使用
 * 足够大的初始容量创建它将使得映射关系能更有效地存储。
 * 
 * 例子
 * 		var hm:HashMap = new HashMap();
 * 		hm.put("key2",2);
 * 		hm.put("key3",3);
 * 		hm.put("key3",5);
 * 		
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.map.HashMap extends AbstractMap implements Map 
{
	/** 所有键的集合 */
	private var _keys:HashSet;
	
	/** 所有值的集合 */
	private var _values:ArrayList;
	/**
	 * @roseuid 4386AD0301E1
	 */
	public function HashMap(source)
	{
		super();
		_keys = new HashSet();
		_values = new ArrayList();
		populate(source);
	}
	
	/**
	 * 从此映射中移除所有映射关系（可选操作）。
	 * @return Void
	 * @roseuid 4386AD030200
	 */
	public function clear() : Void
	{
		_keys = new HashSet();
		_values = new ArrayList();
	}
	
	/**
	 * 如果此映射包含指定键的映射关系，则返回 true。
	 * @param key - 测试在此映射中是否存在的键。
	 * @return Boolean
	 * @roseuid 4386AD03022F
	 */
	public function containsKey(key:Object) : Boolean
	{
		return (findKey(key) > -1);
	}
	
	/**
	 * 如果此映射为指定值映射一个或多个键，则返回 true。
	 * @param value
	 * @return Boolean
	 * @roseuid 4386AD0302BC
	 */
	public function containsValue(value:Object) : Boolean
	{
		return (findValue(value) > -1);
	}
	
	/**
	 * 返回此映射中包含的映射关系的 set 视图。
	 * 返回的 set 中的每个元素都是一个 Map.Entry。该 set 受映射支持，所以对映射的改变可在此 set 中反映出来，
	 * 反之亦然。如果修改映射的同时正在对该 set 进行迭代（除了通过迭代器自己的 remove 操作，或者通过在迭代器返
	 * 回的映射项上执行 setValue 操作外），则迭代结果是不明确的。set 支持通过 Iterator.remove、Set.remove、
	 * removeAll、retainAll 和 clear 操作实现元素移除，即从映射中移除相应的映射关系。它不支持 add 或 addAll
	 *  操作。
	 *  TODO 目前没有办法实现此方法
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD030339
	 */
	public function entrySet() : Set
	{
		return null;
	}
	
	/**
	 * 返回此映射中映射到指定键的值。
	 * @param key
	 * @return Object
	 * @roseuid 4386AD04000C
	 */
	public function get(key:Object) : Object
	{
		return _values.getItemAt(findKey(key));
	}
	
	/**
	 * 如果此映射未包含键-值映射关系，则返回 true。
	 * @return Boolean
	 * @roseuid 4386AD0400A8
	 */
	public function isEmpty() : Boolean
	{
		return (size() < 1);
	}
	
	/**
	 * 返回此映射中包含的键的 set 视图。
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD0400D7
	 */
	public function keySet() : Set
	{
		return _keys;
	}
	
	/**
	 * 将指定的值与此映射中的指定键相关联（可选操作）。
	 * @param key - 与指定值相关联的键。
	 * @param value - 与指定键相关联的值。 
	 * @return Object 与指定键相关联的旧值，如果键没有任何映射关系，则返回 null。
	 * @roseuid 4386AD040106
	 */
	public function put(key:Object,value:Object) : Object
	{
		var result = null;
		var i:Number = findKey(key); 
		if(i < 0) {
			_keys.Add(key);
			_values.push(value);
		} else {
			result = _values.getItemAt(i);
			_values.Set(i,value);
		}
		return result;
	}
	
	/**
	 * 从指定映射中将所有映射关系复制到此映射中（可选操作）。对于指定映射中的每个键 k 到值 v 的映射关系，
	 * 该调用的作用等效于在此映射上调用 put(k, v)。如果正在进行此操作的同时修改了指定的映射，则此操作的行为
	 * 是未指定的。
	 * @param t
	 * @return Void
	 * @roseuid 4386AD040210
	 */
	public function putAll(t:Map) : Void
	{
		var values:Array = t.values().toArray();
		var keys:Array = t.keySet().toArray();
		var l:Number = keys.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			put(keys[i], values[i]);
		}
	}
	
	/**
	 * 如果存在此键的映射关系，则将其从映射中移除（可选操作）。
	 * @param key
	 * @return Object
	 * @roseuid 4386AD0402AC
	 */
	public function remove(key:Object) : Object
	{
		var i:Number = findKey(key);
		if(i > -1) {
			var result = _values.getItemAt(i);
			_values.toArray().splice(i, 1);
			_keys.toArray().splice(i, 1);
			return result;
		}
		return;
	}
	
	/**
	 * 返回此映射中的键-值映射关系数。
	 * @return Number
	 * @roseuid 4386AD040358
	 */
	public function size() : Number
	{
		return _keys.size();
	}
	
	/**
	 * 返回此映射中包含的值的 collection 视图。
	 * @return Collection
	 * @roseuid 4386AD040387
	 */
	public function values() : Collection
	{
		return _values;
	}

	/**
	 * 查询一个键存在的位置
	 * @param key 要查询的键
	 * @return 如果存在则返回位置，否则返回-1；
	 */
	private function findKey(key):Number {
		var l:Number = _keys.size();
		while (_keys.getItemAt(--l) !== key && l>-1);
		return l;
	}
	
	/**
	 * 查询一个值存在的位置
	 * @param value 要查询的值
	 * @return 如果存在则返回位置，否则返回-1；
	 */
	private function findValue(value):Number {
		var l:Number = _values.size();
		while (_values.getItemAt(--l) !== value && l>-1);
		return l;
	}
}
