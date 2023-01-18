import net.manaca.lang.BObject;
import net.manaca.data.map.HashMap;
import net.manaca.util.StringUtil;

/**
 * Hash表控制中心，主要负责将对象和Hash值记录到HashMap中。
 * @author Wersling
 * @version 1.0, 2005-12-28
 */
class net.manaca.lang.HashCenter extends BObject {
	//一个HashMap，用于保存所以Hash值
	static private var _hashMap:HashMap =  new HashMap();
	//一个自动增加的编号
	static private var _SNN:Number = 0;
	static private var _enabled:Boolean = true;
	
	private function HashCenter() {
		super();
	}
	
	/**
	 * 将指定的值与此映射中的指定键相关联。
	 * @param key 对象唯一标识字符,格式：对象类名+_+Date.UTC+_+至少8位唯一编号
	 * @param hoder 对象
	 */
	static public function put(key:String,hoder:Object):Void{
		if(enabled) _hashMap.put(key,hoder);
	}
	
	/**
	 * 如果存在此键的映射关系，则将其从映射中移除
	 * @param key 对象唯一标识字符
	 */
	static public function remove(key:String):Void{
		_hashMap.remove(key);
	}
	
	/**
	 * 获取一个唯一的编号
	 * @param String 返回一个唯一的编号
	 */
	static public function get SN():String{
		_SNN ++;
		var sn:String;
		if(String(_SNN).length < 8){
			sn = StringUtil.multiply("0", 8-String(_SNN).length)+String(_SNN);
		}else{
			sn = String(_SNN);
		}
		return new Date().valueOf() + "_" + sn;
	}
	
	/**
	 * 返回HashMap
	 * @param HashMap 返回HashMap
	 */
	static public function get hashMap():HashMap{
		return _hashMap;
	}
	/**
	 * 是否记录
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	static public function set enabled(value:Boolean) :Void
	{
		_enabled = value;
	}
	static public function get enabled() :Boolean
	{
		return _enabled;
	}
}