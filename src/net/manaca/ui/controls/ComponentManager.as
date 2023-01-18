import net.manaca.lang.BObject;
import net.manaca.ui.controls.UIComponent;

/**
 * 组件管理，主要用于批处理主题和皮肤
 * @author Wersling
 * @version 1.0, 2006-5-12
 */
class net.manaca.ui.controls.ComponentManager extends BObject {
	private var className : String = "net.manaca.ui.controls.ComponentManager";
	static private var _component_list:Object;
	static private var _tab_index:Number = 0;
	
	public function ComponentManager() {
		super();
	}
	
	/**
	 * 注册元素
	 * @param c:Component
	 */
	static public function register(c:UIComponent):Void{
		if(_component_list == undefined) _component_list = new Object();
		var _arr:Array = _component_list[c.getName()];
		if(_arr == undefined) _arr = new Array();
		_arr.push(c);
		c.getDisplayObject().tabIndex = ++_tab_index;
		_component_list[c.getName()] = _arr;
	}
	
	/**
	 * 获取组件列表
	 * @param name:String
	 * @return Array 为空则返回所有注册
	 */
	static public function getComponentList(name:String):Array{
		if(name){
			var a:Array = _component_list[name];
			if(a.length > 0) return  _component_list[name];
		}
		var _arr:Array = new Array();
		for(var i in _component_list){
			_arr = _arr.concat(_component_list[i]);
		}
		if(_arr.length > 0) return _arr;
		return null;
	}
}