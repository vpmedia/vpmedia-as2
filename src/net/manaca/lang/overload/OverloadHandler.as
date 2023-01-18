import net.manaca.util.ObjectUtil;
import net.manaca.lang.exception.IllegalArgumentException;
/**
 * 功能：重载句柄类 OverloadHandler，记录重载的参数类型和方法
 * 使用：
 * <code>
 *   // MyClass.as
 *   class MyClass {
 *       public function myMethod() {
 *       	 var handler:OverloadHandler = new OverloadHandler([Number, String], myMethodByNumberAndString);
 *       }
 *       public function myMethodByNumberAndString(number:Number, string:String):Void {
 *           trace("myMethod(Number, String):Void");
 *       }
 *   }
 * </code>
 * 
 * @author Wersling
 * @version 1.0, 2005-8-30
 */
class net.manaca.lang.overload.OverloadHandler
{
	/** 
	 * 某方法所对应的参数类型
	 */
	private var argumentsTypes:Array;
	
	/**
	 * 对应target对象可以执行的方法
	 */
	private var method:Function;
	
	/**
	 * 构造函数
	 * @param argumentsTypes 参数类型数组
	 * @param method 对应的方法
	 */
	public function OverloadHandler(argumentsTypes:Array, method:Function)
	{
		if (!method) throw new IllegalArgumentException("method不能为null或者undefined",this,arguments);
		if (!argumentsTypes) argumentsTypes = [];
		this.argumentsTypes = argumentsTypes;
		this.method = method;
	}
	
	/**
	 * 检查传递的参数 {@code realArguments} 是否与该句柄的参数类型一致
	 * @param realArguments 参数类型所对应的参数
	 * @return {@code true} 如果该参数与argumentsTypes类型一致的话，否则
	 * {@code false}
	 */
	public function matches(realArguments:Array):Boolean
	{
		if (!realArguments) realArguments = [];
		var i:Number = realArguments.length;
		if (i != argumentsTypes.length) return false;
		while (--i-(-1)) {
			// null == undefined
			if (realArguments[i] != null) {
				// An expected type of value null or undefined gets interpreted as: whatever.
				if (argumentsTypes[i] != null) {
					if (!ObjectUtil.typesMatch(realArguments[i], argumentsTypes[i])) {
						return false;
					}
				}
			}
		}
		return true;
	}
	
	/**
	 * 获得该句柄对应的方法
	 * @return 与真实参数所对应的方法
	 */
	public function getMethod(Void):Function
	{
		return method;
	}
	
	/**
	 * 获得该句柄对应的参数类型
	 * @return 参数类型数组
	 */
	public function getArgumentsTypes(Void):Array
	{
		return argumentsTypes;
	}
}
