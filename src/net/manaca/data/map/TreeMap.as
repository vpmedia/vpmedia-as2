//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\map\\TreeMap.java

//package net.manaca.data.map;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.Map;
import net.manaca.data.map.AbstractMap;
import net.manaca.data.Set;

/**
 * SortedMap 接口的基于红黑树的实现。此类保证了映射按照升序顺序排列关键字，根据使用的构造方法不同，可能会按照键的类的自然顺序 进行排序（参见 Comparable），或者按照创建时所提供的比较器进行排序。
 * 
 * 此实现为 containsKey、get、put 和 remove 操作提供了保证的 log(n) 时间开销。这些算法是 Cormen、Leiserson 和 Rivest 的《Introduction to Algorithms》中的算法的改编。
 * 
 * 注意，如果有序映射要正确实现 Map 接口，则有序映射所保持的顺序（无论是否明确提供比较器）都必须保持与 equals 方法一致。（请参见与 equals 方法一致 的精确定义的 Comparable 或 Comparator。）这也是因为 Map 接口是按照 equals 操作定义的，但映射使用它的 compareTo（或 compare）方法对所有键进行比较，因此从有序映射的观点来看，此方法认为相等的两个键就是相等的。即使顺序与 equals 方法不一致，有序映射的行为仍然是 定义良好的；只不过没有遵守 Map 接口的常规约定。
 * 
 * 注意，此实现不是同步的。如果多个线程同时访问一个映射，并且其中至少一个线程从结构上修改了该映射，则其必须 保持外部同步。（结构上修改是指添加或删除一个或多个映射关系的操作；仅改变与现有键关联的值不是结构上的修改。）这一般通过对自然封装该映射的某个对象进行同步操作来完成。如果不存在这样的对象，则应该使用 Collections.synchronizedMap 方法来“包装”该映射。最好在创建时完成这一操作，以防止对映射进行意外的不同步访问，如下所示： 
 * 
 *      Map m = Collections.synchronizedMap(new TreeMap(...));
 *  由所有此类的“collection 视图方法”所返回的迭代器都是快速失败 的：在迭代器创建之后，如果从结构上对映射进行修改，除非通过迭代器自身的 remove 或 add 方法，其他任何时间任何方式的修改，迭代器都将抛出 ConcurrentModificationException。因此，面对并发的修改，迭代器很快就完全失败，而不是冒着在将来不确定的时间任意发生不确定行为的风险。 
 * 
 * 注意，迭代器的快速失败行为无法得到保证，因为一般来说，不可能对是否出现不同步并发修改做出任何硬性保证。快速失败迭代器会尽最大努力抛出 ConcurrentModificationException。因此，为提高这类迭代器的正确性而编写一个依赖于此异常的程序是错误的做法：迭代器的快速失败行为应该仅用于检测 bug。
 */
class net.manaca.data.map.TreeMap extends AbstractMap implements Map 
{
	
	/**
	 * @roseuid 4386AD0500A8
	 */
	public function TreeMap() 
	{
		
	}
	
	/**
	 * @return Void
	 * @roseuid 4386AD0500C8
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param key
	 * @return Boolean
	 * @roseuid 4386AD0500F7
	 */
	public function containsKey(key:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param value
	 * @return Boolean
	 * @roseuid 4386AD050174
	 */
	public function containsValue(value:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD050200
	 */
	public function entrySet() : Set
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4386AD05022F
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param key
	 * @return Object
	 * @roseuid 4386AD0502BC
	 */
	public function get(key:Object) : Object
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4386AD050348
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @return net.manaca.data.Set
	 * @roseuid 4386AD050377
	 */
	public function keySet() : Set
	{
		return null;
	}
	
	/**
	 * @param key
	 * @param value
	 * @return Boolean
	 * @roseuid 4386AD0503B6
	 */
	public function put(key:Object,value:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param t
	 * @return Void
	 * @roseuid 4386AD0600C8
	 */
	public function putAll(t:Map) : Void
	{
		//return null;
	}
	
	/**
	 * @param key
	 * @return Object
	 * @roseuid 4386AD060174
	 */
	public function remove(key:Object) : Object
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4386AD060210
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Collection
	 * @roseuid 4386AD06024E
	 */
	public function values() : Collection
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4386AD06028D
	 */
	public function iterator() : Iterator
	{
		return null;
	}
}
