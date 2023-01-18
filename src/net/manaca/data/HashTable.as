import net.manaca.data.Map;
import net.manaca.data.Set;
import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.set.HashSet;
import net.manaca.data.list.ArrayList;
import net.manaca.lang.IObject;
import net.manaca.data.map.AbstractMap;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\Hashtable.java

//package net.manaca.data;


/**
 * 此类实现一个哈希表，该哈希表将键映射到相应的值。任何非 null 对象都可以用作键或值。
 * 
 * 为了成功地在哈希表中存储和检索对象，用作键的对象必须实现 hashCode 方法和 equals 方法。
 * 
 * Hashtable 的实例有两个参数影响其性能：初始容量 和加载因子。容量 是哈希表中桶 的数量，初始容量 就是哈希表创建时的容量。注意，哈希表的状态为 open：在发生“哈希冲突”的情况下，单个桶会存储多个条目，这些条目必须按顺序搜索。加载因子 是对哈希表在其容量自动增加之前可以达到多满的一个尺度。初始容量和加载因子这两个参数只是对该实现的提示。关于何时以及是否调用 rehash 方法的具体细节则依赖于该实现。
 * 
 * 通常，默认加载因子(.75)在时间和空间成本上寻求一种折衷。加载因子过高虽然减少了空间开销，但同时也增加了查找某个条目的时间（在大多数 Hashtable 操作中，包括 get 和 put 操作，都反映了这一点）。
 * 
 * 初始容量主要控制空间消耗与执行 rehash 操作所需要的时间损耗之间的平衡。如果初始容量大于 Hashtable 所包含的最大条目数除以加载因子，则永远 不会发生 rehash 操作。但是，将初始容量设置太高可能会浪费空间。
 * 
 * 如果很多条目要存储在一个 Hashtable 中，那么与根据需要执行自动 rehashing 操作来增大表的容量的做法相比，使用足够大的初始容量创建哈希表或许可以更有效地插入条目。
 * 
 * 下面这个示例创建了一个数字的哈希表。它将数字的名称用作键： 
 * 
 * 
 *      numbers:HashTable = new HashTable();
 *      numbers.put("one", new Integer(1));
 *      numbers.put("two", new Integer(2));
 *      numbers.put("three", new Integer(3));
 *  要检索一个数字，可以使用以下代码： 
 * 
 * 
 *      Integer n = (Integer)numbers.get("two");
 *      if (n != null) {
 *          System.out.println("two = " + n);
 *      }
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.HashTable extends AbstractMap implements Map 
{
	/** 所有键的集合 */
	private var _keys:HashSet;
	
	/** 所有值的集合 */
	private var _values:ArrayList;
	/**
	 * @roseuid 4386ABD902AC
	 */
	/**
	 * @roseuid 4386AD0301E1
	 */
	public function HashTable(source)
	{
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
		if(i < 0 && key != null) {
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
