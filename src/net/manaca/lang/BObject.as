import net.manaca.lang.IObject;
import net.manaca.lang.event.EventDispatcher;
//import net.manaca.lang.HashCenter;
import net.manaca.data.ObjectComparator;
import net.manaca.data.Cloneable;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\lang\\BObject.java

//package was.lang;


/**
 * 基本的对象
 * @author Wersling
 * @version 1.0
 */
class net.manaca.lang.BObject extends Object implements IObject,Cloneable
{
	private var className : String = "net.manaca.lang.BObject";
	//static var symbolName : String = "__Packages.net.manaca.lang.BObject";
	static public var symbolOwner : Function = net.manaca.lang.BObject;
	//static var symbolLinked = Object.registerClass(symbolName, symbolOwner);
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
	
	//public var pathpreix : String;
	//MTASC not support for initialization of member variables directly inside the class body
	//应该放到构造函数中去初始化
	static private var __initAsDispatcher = EventDispatcher.initialize (symbolOwner.prototype);
	private static var _hashCode:String;
	/**
	 * @roseuid 43845C4C0203
	 */
	public function BObject() 
	{
		super();
		//_hashCode = className + "_" + HashCenter.SN;
		//HashCenter.put(_hashCode,this);
	}
	/**
	 * 添加一个基于 更新的事件对象
	 * @param event 事件名称
	 * @param fun 触发方法，这里不再需要使用委托，方法将自动为其委托方法
	 */
//	public function addEventListenerForEven(event:String,fun:Function):Void{
//		var s = fun.prototype.__proto__;
//		_global.ASSetPropFlags(s, null, 6, 1); 
//		trace(s.isPropertyEnumerable(className));
//		for(var i in s) trace('key: ' + i + ', value: ' + s[i]);
//		//for(var i in fun.constructor) trace('key: ' + i + ', value: ' + fun.constructor[i]);
//		this.addEventListener(event,Delegate.create(this,fun));
//	}
	/**
	 * 抛出事件，这里为抛出一个更新的针对事件对象的事件，当然，原来的方式一样可以用
	 * @param event 一个 Event 对象
	 */
//	public function dispatchEventForEven(event:Event):Void{
//		this.dispatchEvent(event);
//	}
	/**
	 * 创建并返回此对象的一个副本。
	 * @return was.lang.IObject
	 * @roseuid 43845C4C0213
	 */
	public function clone() : IObject
	{
		return new BObject();
	}
	
	/**
	 * 指示某个其他对象是否与此对象“相等”。
	 * @param obj
	 * @return Boolean
	 * @roseuid 43845C4C0242
	 */
	public function equals(obj:IObject) : Boolean
	{
		var oc:ObjectComparator = new ObjectComparator();
		return oc.equals(this,obj);
	}
	
	/**
	 * 返回一个对象的运行时类。
	 * @return String 类的完整名称,包括package
	 * @roseuid 43845C4C029F
	 */
	public function getClass() : String
	{
		return className; 
	}
	
	/**
	 * @return String
	 * @roseuid 43845C4C02CE
	 */
	public function hashCode() : String
	{
		return _hashCode;
	}
}
