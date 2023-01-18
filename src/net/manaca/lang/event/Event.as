/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-26
 */
class net.manaca.lang.event.Event {
	private var className : String = "net.manaca.lang.event.Event";
	/** 在Flash Player成为系统焦点时抛出 */
	static public var ACTIVATE:String =	"activate";
	/** 在对象添加时抛出 */
	static public var ADDED:String = 	"added";
	/** 在对象执行取消时抛出 */
	static public var CANCEL:String = 	"cancel";
	/** 在对象被取消时抛出 */
	static public var CHANGE:String = 	"change";
	/** 在对象关闭时抛出 */
	static public var CLOSE:String = 	"close";
	/** 在对象完成某操作时抛出 */
	static public var COMPLETE:String = "complete";
	/** 在对象完成连接时抛出 */
	static public var CONNECT:String = 	"connect";
	/** 在对象无法使用或被禁止时抛出 */
	static public var DEACTIVATE:String = "deactivate";
	/** 在元件执行Enter时抛出 */
	static public var ENTER:String = "enter";
	/** 在元件执行EnterFrame时抛出 */
	static public var ENTER_FRAME:String = "enterFrame";
	/** 在Sound对象获取新的ID3时抛出 */
	static public var ID3:String = 		"id3";
	/** 在对象初始完成，可以使用时抛出 */
	static public var INIT:String = 	"init";
	/** 在鼠标离开对象时抛出 */
	static public var MOUSE_LEAVE:String = "mouseLeave";
	/** 在对象执行打开动作时抛出 */
	static public var OPEN:String = "open";
	/** 在对象执行离开动作时抛出 */
	static public var REMOVED:String = "removed";
	/** 在对象放弃操作时抛出 */
	static public var RENDER:String = "render";
	/** 在对象改变大小时抛出 */
	static public var RESIZE:String = "resize";
	/** 在对象滚动条发生改变时抛出 */
	static public var SCROLL:String = "scroll";
	/** 在对象被选择时抛出 */
	static public var SELECT:String = "select";
	/** 在Sound对象完成加载时抛出 */
	static public var SOUND_COMPLETE:String = "soundComplete";
	/** 在对象子标记发生改变时抛出 */
	static public var TAB_CHILDREN_CHANGE:String = "tabChildrenChange";
	/** 在对象是否可用发生改变时抛出 */
	static public var TAB_ENABLED_CHANGE:String = "tabEnabledChange";
	/** 在对象索引发生改变时抛出 */
	static public var TAB_INDEX_CHANGE:String = "tabIndexChange";
	/** 在对象反加载时抛出 */
	static public var UNLOAD:String = "unload";
	/** 在对象更新时抛出 */
	static public var UPDATA:String = "upData";

	private var _type : String;
	private var _value : Object;
	private var _target : Object;
	
	/**
	 * 构造函数
	 * @param type 事件类型
	 * @param value 抛出的值
	 * @param target 事件抛出目标
	 */
	public function Event(type:String,value,target:Object) {
		_type = type;
		_value = value;
		_target = target;
	}
	/**
	 * 获取和设置事件类型
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set type(value:String) :Void
	{
		_type = value;
	}
	public function get type() :String
	{
		return _type;
	}
	
	/**
	 * 获取和设置事件抛出的值
	 * @param  value  参数类型：Object 
	 * @return 返回值类型：Object 
	 */
	public function set value(value:Object) :Void
	{
		_value = value;
	}
	public function get value() :Object
	{
		return _value;
	}
	
	/**
	 * 获取和设置事件抛出的目标
	 * @param  value  参数类型：Object 
	 * @return 返回值类型：Object 
	 */
	public function set target(value:Object) :Void
	{
		_target = value;
	}
	public function get target() :Object
	{
		return _target;
	}
}