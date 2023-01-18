import net.manaca.lang.overload.OverloadHandler;
import net.manaca.lang.exception.IllegalStateException;
/**
 * 功能：重载
 * 使用：
 * <code>
 *   // MyClass.as
 *   class MyClass {
 *       public function myMethod() {
 *           var _overload:Overload = new Overload(this);
 *           _overload.addHandler([Number, String], myMethodByNumberAndString);
 *           _overload.addHandler([Number], myMethodByNumber);
 *           _overload.addHandler([String], myMethodByString);
 *           _overload.forward(arguments);
 *       }
 *       public function myMethodByNumberAndString(number:Number, string:String):Void {
 *           trace("myMethod(Number, String):Void");
 *       }
 *       public function myMethodByNumber(number:Number):Void {
 *           trace("myMethod(Number):Void");
 *       }
 *       public function myMethodByString(string:String):Number {
 *           trace("myMethod(String):Number");
 *           return 1;
 *       }
 *   }
 * </code>
 * 
 * @author Wersling
 * @version 1.0, 2005-8-30
 */
class net.manaca.lang.overload.Overload
{
	/**
	 * 存储所有已注册的OverloadHandler句柄
	 */
	private var handlers:Array;
	
	/**
	 * 调用该实例方法的目标对象.
	 */
	private var target:Object;
	
	/**
	 * 构造一个 {@code Overload} 新实例
	 * @param target 调用重载方法的对象
	 */
	public function Overload(target:Object)
	{
		this.handlers = new Array();
		this.target = target ? target : this;
	}

	/**
	 * 添加一个 {@link OverloadHandler} 
	 * 由{@code argumentsTypes} 和 {@code method}创建的新实例
	 * @param argumentsTypes 重载句柄OverloadHandler的参数类型
	 * @param method 执行参数为 {@code argumentsTypes} 的方法
	 */
	public function addHandler(argumentsTypes:Array, method:Function):Void
	{
		var handler:OverloadHandler = new OverloadHandler(argumentsTypes, method);
		handlers.push(handler);
	}
	
	/**
	 * 添加一个OverloadHandler
	 * @param handler 要添加的OverloadHandler
	 * @return Boolean 如果添加成功则返回 True
	 */
	public function addHandlerByHandler(handler:OverloadHandler):Boolean {
		if (handler) {
			handlers.push(handler);
			return true;
		}
		return false;
	}
	
	/**
	 * 移除已创建的 {@code handler} OverloadHandler
	 * 由{@code argumentsTypes} 和 {@code method}创建的句柄 OverloadHandler
	 * @param handler 需要移除的OverloadHandler
	 */
	public function removeHandler(handler:OverloadHandler):Void
	{		
		if (handler) {
			var i:Number = handlers.length;
			while (--i-(-1)) {
				if (OverloadHandler(handlers[i]) == handler) {
					handlers.splice(i, 1);
				}
			}
		}
	}
	
	/**
	 * 根据传给的参数 {@code args} 调用重载句柄 overload handler
	 *
	 * @param args 类重载所传递的参数
	 * @return OverloadHandler 所调用方法返回值
	 */
	public function forward(args:Array):OverloadHandler
	{
		return doGetMatchingHandler(args).getMethod().apply(target, args);
	}
	
	/**
	 * 根据参数类型获取相应的重载句柄
	 * @param overloadArguments 类重载所传递的参数
	 * @return OverloadHandler 类重载参数对应的
	 */
	private function doGetMatchingHandler(overloadArguments:Array):OverloadHandler
	{
		var i:Number = handlers.length;
		while (--i-(-1)) {
			var handler:OverloadHandler = handlers[i];
			if (handler.matches(overloadArguments)) return handler;
		}
		throw new IllegalStateException("没有相应的OverloadHandler",this,arguments);
	}
}
