//Source file: D:\\Wersling WAS Framework\\javacode\\was\\ui\\UIObject.java

//package was.ui;

import net.manaca.lang.IObject;
import net.manaca.lang.event.EventDispatcher;
import net.manaca.util.MovieClipUtil;
import net.manaca.lang.HashCenter;
import net.manaca.data.ObjectComparator;
import net.manaca.data.Cloneable;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.manager.ToolTipManager;

/**
 * 用户界面的基类
 * @author Wersling
 * @version 1.0
 */
class net.manaca.ui.UIObject extends MovieClip implements IObject,Cloneable
{
	private var className : String = "net.manaca.ui.UIObject";
	static var symbolName:String = "__Packages.net.manaca.ui.UIObject";
	static var symbolOwner:Function = net.manaca.ui.UIObject;
	/**
	 * 添加一个事件监听，此方法需要添加一个String 类型的事件类型和一个具有委托的方法
	 * @param event String 事件类型
	 * @param fun Function 事件接收函数，具有委托的
	 */
	public var addEventListener : Function;
	
	/**
	 * 删除一个监听，注意这里删除时采用了一个对方法的委托
	 * 删除时要使用同一个委托方法
	 * @param event String 事件类型
	 * @param fun Function 事件接收的函数，具有于添加时同一个委托的
	 */
	public var removeEventListener : Function;
	
	/**
	 * 抛出事件
	 * @param Object 一个Objcet，需要定义为{type:"evenType",value:a}
	 */
	public var dispatchEvent : Function;
	public var pathpreix:String;
	static private var __initAsDispatcher = EventDispatcher.initialize (symbolOwner.prototype);
	//启用状态
	private var _enabled:Boolean;
	//宽度
	private var __width:Number;
	//高度
	private var __height:Number;
	private static var _hashCode:String;

	private var _toolTip : String;
	private var _toolTipShow : Boolean;
	/**
	 * 构造函数
	 * @param 无
 	 * @roseuid 4382F4410176
	 */
	public function UIObject() 
	{
		
		super();
		_toolTipShow = true;
		//this.addEventListener("onRollOver",Delegate.create(this,OnonRollOver));
		//_hashCode = className + "_" + HashCenter.SN;
		//HashCenter.put(_hashCode,this);
	}
	
	/**
	 * 添加一个基于 更新的事件对象
	 * @param event 事件名称
	 * @param fun 触发方法，这里不再需要使用委托，方法将自动为其委托方法
	 */
	public function addEventListenerForEven(event:String,fun:Function):Void{
		this.addEventListener(event,Delegate.create(this,fun));
	}
	/**
	 * 抛出事件，这里为抛出一个更新的针对事件对象的事件，当然，原来的方式一样可以用
	 * @param event 一个 Event 对象
	 */
	public function dispatchEventForEven(event:Event):Void{
		this.dispatchEvent(event);
	}
	/** 删除本身 */
	public function remove():Void
	{
		MovieClipUtil.remove(this);
	}

	/** 初始 */
	function init(Void):Void
	{
		__width = int(_width);
		__height = int(_height);
	}
	/** 设置大小 */
	function size(Void):Void
	{
		_width = __width;
		_height = __height;
	}
	/** 返回下一个可以使用的深度 */
	public function getNextDepth():Number
	{
		var depth:Number = 0;
		for (var prop:String in this) {
			if (typeof this[prop] == "movieclip")
			{
				var newDepth:Number = MovieClip(this[prop]).getDepth();
				if (newDepth > depth) depth = newDepth;
			}
		}
		return depth+1;
	}
//	/** 启用状态 */
//	public function set enabled(v:Boolean):Void
//	{
//		_enabled = v ? OnEnabled() : OffEnabled();
//	}
//	public function get enabled():Boolean
//	{
//		return _enabled;
//	}
//	private function OnEnabled():Boolean
//	{
//		useHandCursor = true;
//		delete onRelease;
//		return true;
//	}
//	private function OffEnabled():Boolean
//	{
//		useHandCursor = false;
//		onRelease = function() {};
//		return false;
//	}
	/** 卸载时执行 */
	public function onUnload():Void
	{
		super.onUnload();
		delete symbolName;
		delete symbolOwner;
		delete addEventListener;
		delete removeEventListener;
		delete dispatchEvent;
		delete pathpreix;
		delete __initAsDispatcher;
		delete _enabled;
		delete __width;
		delete __height;
		HashCenter.remove(_hashCode);
		ToolTipManager.getInstance().remove(this);
	}

	/**
	 * @return was.lang.IObject
	 * @roseuid 43845C32029F
	 */
	public function clone() : IObject
	{
		//TODO 没有实现
		return null;
	}
	
	/**
	 * @param obj
	 * @return Boolean
	 * @roseuid 43845C3202BF
	 */
	public function equals(obj:IObject) : Boolean
	{
		var oc:ObjectComparator = new ObjectComparator();
		return oc.equals(this,obj);
	}
	
	/**
	 * @return String
	 * @roseuid 43845C32031C
	 */
	public function getClass() : String
	{
		return className;
	}
	
	/**
	 * @return String
	 * @roseuid 43845C32033C
	 */
	public function hashCode() : String
	{
		return _hashCode;
	}
	/**
	 * 设置提示文字
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set toolTip(value:String) :Void
	{
		if(_toolTip.length == undefined) {
			ToolTipManager.getInstance().push(this);
		}
		_toolTip = value;
		if(_toolTip.length < 1){
			ToolTipManager.getInstance().remove(this);
		}
	}
	public function get toolTip() :String
	{
		return _toolTip;
	}
	/**
	 * 是否显示提示
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set toolTipShow(value:Boolean) :Void
	{
		_toolTipShow = value;
	}
	public function get toolTipShow() :Boolean
	{
		return _toolTipShow;
	}
}
