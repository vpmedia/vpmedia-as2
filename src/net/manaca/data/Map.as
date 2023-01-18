import net.manaca.data.Set;
import net.manaca.data.Collection;
import net.manaca.lang.IObject;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\Map.java

//package net.manaca.data;


/**
 * 出一个异常，也可能操作成功，这取决于实现本身。这样的异常在此接口的规范中标记为“
 * 可选”。
 */
interface net.manaca.data.Map
{
	//Iterator net.manaca.data.theIterator;
	//IComparator net.manaca.data.theIComparator;
	
	/**
	 * 从此映射中移除所有映射关系（可选操作）。
	 * @return Void
	 * @roseuid 4386A2ED025E
	 */
	public function clear() : Void;
	
	/**
	 * 如果此映射包含指定键的映射关系，则返回 true。
	 * @param key - 测试在此映射中是否存在的键。
	 * @return Boolean
	 * @roseuid 4386A2FB0125
	 */
	public function containsKey(key:Object) : Boolean;
	
	/**
	 * 如果此映射为指定值映射一个或多个键，则返回 true。
	 * @param value - 测试在该映射中是否存在的值。
	 * @return Boolean
	 * @roseuid 4386A3220193
	 */
	public function containsValue(value:Object) : Boolean;
	
	/**
	 * 返回此映射中包含的映射关系的 set 视图。
	 * 返回的 set 中的每个元素都是一个 Map.Entry。该 set 受映射支持，所以对映射的改变可在此 set 中反映出来，
	 * 反之亦然。如果修改映射的同时正在对该 set 进行迭代（除了通过迭代器自己的 remove 操作，或者通过在迭代器返
	 * 回的映射项上执行 setValue 操作外），则迭代结果是不明确的。set 支持通过 Iterator.remove、Set.remove、
	 * removeAll、retainAll 和 clear 操作实现元素移除，即从映射中移除相应的映射关系。它不支持 add 或 addAll
	 *  操作。
	 * @return net.manaca.data.Set
	 * @roseuid 4386A35A0099
	 */
	public function entrySet() : Set;
	
	/**
	 * 比较指定的对象与此映射是否相等。
	 * @param o
	 * @return Boolean
	 * @roseuid 4386A382001C
	 */
	public function equals(o:IObject) : Boolean;
	
	/**
	 * 返回此映射中映射到指定键的值。
	 * @param key - 要返回其相关值的键。
	 * @return Object
	 * @roseuid 4386A3A00368
	 */
	public function get(key:Object) : Object;
	
	/**
	 * 返回此映射的哈希代码值。
	 * @return String
	 * @roseuid 4386A3D501F1
	 */
	public function hashCode() : String;
	
	/**
	 * 如果此映射未包含键-值映射关系，则返回 true。
	 * @return Boolean
	 * @roseuid 4386A3E50387
	 */
	public function isEmpty() : Boolean;
	
	/**
	 * 返回此映射中包含的键的 set 视图。
	 * @return net.manaca.data.Set
	 * @roseuid 4386A3F5028D
	 */
	public function keySet() : Set;
	
	/**
	 * 将指定的值与此映射中的指定键相关联（可选操作）。
	 * @param key - 与指定值相关联的键。
	 * @param value - 与指定键相关联的值。 
	 * @return Object 与指定键相关联的旧值，如果键没有任何映射关系，则返回 null。
	 * @roseuid 4386A405021F
	 */
	public function put(key:Object,value:Object) : Object;
	
	/**
	 * 从指定映射中将所有映射关系复制到此映射中（可选操作）。对于指定映射中的每个键 k 到值 v 的映射关系，
	 * 该调用的作用等效于在此映射上调用 put(k, v)。如果正在进行此操作的同时修改了指定的映射，则此操作的行为
	 * 是未指定的。
	 * @param t - 要存储在此映射中的映射关系
	 * @return Void
	 * @roseuid 4386A45B01E1
	 */
	public function putAll(t:Map) : Void;
	
	/**
	 * 如果存在此键的映射关系，则将其从映射中移除（可选操作）。
	 * @param key - 从映射中移除其映射关系的键。
	 * @return Object
	 * @roseuid 4386A5290164
	 */
	public function remove(key:Object) : Object;
	
	/**
	 * 返回此映射中的键-值映射关系数。
	 * @return Number
	 * @roseuid 4386A54F01C2
	 */
	public function size() : Number;
	
	/**
	 * 返回此映射中包含的值的 collection 视图。
	 * @return Collection
	 * @roseuid 4386A561029C
	 */
	public function values() : Collection;
}
