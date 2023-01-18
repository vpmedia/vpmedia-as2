import net.manaca.data.Collection;
import net.manaca.data.Map;
import net.manaca.data.map.AbstractMap;
import net.manaca.data.Set;
import net.manaca.lang.IObject;
import net.manaca.data.set.HashSet;
import net.manaca.data.list.ArrayList;

/**
 * KeyMap 是一个针对于简单类型的键而设立的对象，KeyMap将键记录在一个Object中，从而
 * 提交对键的减缩速度
 * @author Wersling
 * @version 1.0, 2006-4-29
 */
class net.manaca.data.map.KeyMap extends AbstractMap implements Map {
	private var className : String = "net.manaca.data.map.KeyMap";
	
	private var _keys:Object;
	/**
	 * 构造一个KeyMap
	 */
	public function KeyMap() {
		super();
		_keys = new Object();
	}
	
	/**
	 * 从此映射中移除所有映射关系（可选操作）。
	 * @return Void
	 * @roseuid 4386A2ED025E
	 */
	public function clear() : Void {
		_keys = new Object();
	}
	
	/**
	 * 如果此映射包含指定键的映射关系，则返回 true。
	 * @param key - 测试在此映射中是否存在的键。
	 * @return Boolean
	 * @roseuid 4386A2FB0125
	 */
	public function containsKey(key : Object) : Boolean {
		if(isAccurateType(key)){
			if(_keys[key] != undefined) return true;
		}
		return false;
	}
	
	/**
	 * 如果此映射为指定值映射一个或多个键，则返回 true。
	 * @param value - 测试在该映射中是否存在的值。
	 * @return Boolean
	 * @roseuid 4386A3220193
	 */
	public function containsValue(value : Object) : Boolean {
		for(var i in _keys){
			if(_keys[i] == value) return true;
		}
		return false;
	}

	public function entrySet() : Set {
		return null;
	}
	
	
	public function equals(o : IObject) : Boolean {
		return super.equals(o);
	}
	
	/**
	 * 返回此映射中映射到指定键的值。
	 * @param key - 要返回其相关值的键。不存在则返回 null
	 * @return Object
	 * @roseuid 4386A3A00368
	 */
	public function get(key : Object) : Object {
		if(isAccurateType(key)){
			if(_keys[key] != undefined) return _keys[key];
		}
		return null;
	}

	public function hashCode() : String {
		return null;
	}
	
	/**
	 * 如果此映射未包含键-值映射关系，则返回 true。
	 * @return Boolean
	 * @roseuid 4386A3E50387
	 */
	public function isEmpty() : Boolean {
		for(var i in _keys){
			return true;
		}
		return false;
	}
	
	/**
	 * 返回此映射中包含的键的 set 视图。
	 * @return net.manaca.data.Set
	 * @roseuid 4386A3F5028D
	 */
	public function keySet() : Set {
		var _set:HashSet = new HashSet();
		for(var i in _keys){
			_set.Add(i);
		}
		return _set;
	}
	
	/**
	 * 将指定的值与此映射中的指定键相关联（可选操作）。
	 * @param key - 与指定值相关联的键。
	 * @param value - 与指定键相关联的值。 
	 * @return Object 与指定键相关联的旧值，如果键没有任何映射关系，则返回 null。
	 * @roseuid 4386AD040106
	 */
	public function put(key : Object, value : Object) : Object {
		var result = null;
		if(isAccurateType(key)){
			if(_keys[key] != undefined) result = _keys[key];
			_keys[key] = value;
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
	public function putAll(t : Map) : Void {
		var values:Array = t.values().toArray();
		var keys:Array = t.keySet().toArray();
		var l:Number = keys.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			put(keys[i], values[i]);
		}
	}
	
	/**
	 * 如果存在此键的映射关系，则将其从映射中移除（可选操作）。
	 * @param key - 从映射中移除其映射关系的键。
	 * @return Object
	 * @roseuid 4386A5290164
	 */
	public function remove(key : Object) : Object {
		
		var result = null;
		if(containsKey(key)){
			result = _keys[key];
			 _keys[key] = undefined;
			delete _keys[key];
			return result;
		}
		return null;
	}
	
	/**
	 * 返回此映射中的键-值映射关系数。
	 * @return Number
	 * @roseuid 4386A54F01C2
	 */
	public function size() : Number {
		var n = 0;
		for(var i in _keys){
			n++;
		}
		return n;
	}
	
	/**
	 * 返回此映射中包含的值的 collection 视图。
	 * @return Collection
	 * @roseuid 4386A561029C
	 */
	public function values() : Collection {
		var c:Collection = new ArrayList();
		for(var i in _keys){
			c.Add(_keys[i]);
		}
		return c;
	}
	
	/**
	 * 查询键值是否符合要求
	 */
	private function isAccurateType(o:Object):Boolean{
		if(typeof(o) == "number" || typeof(o) == "string") return true;
		return false;
	}
}