//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\concurrent\\ClassUtil.java

//package was.util.concurrent;


/**
 * 类功能增强类，静态类
 * @author Wersling
 * @version 1.0
 */
class net.manaca.util.ClassUtil 
{
	private var className : String = "net.manaca.util.ClassUtil";
	/* 私有构造函数，不可实例化 */
	private function ClassUtil(Void) {}
	/**
	 * 判断子类 {@code subClass} 是否是父类 {@code superClass} 的扩展
	 * 
	 * @param subClass 子类
	 * @param superClass 父类
	 * @return {@code true} 如果 {@code subClass} 是 {@code superClass} 的子类
	 */
	public static function isSubClassOf(subClass:Function, superClass:Function):Boolean
	{
		var base:Object = subClass.prototype;
		// A superclass has to be in the prototype chain
		while(base !== undefined) {
			base = base.__proto__;			
			if(base === superClass.prototype) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 判断 {@code clazz} 是否实现了 {@code interfaze} 的接口
	 * 
	 * @param clazz 用于检测的类
	 * @param interfaze 用于实现的接口
	 * @return {@code true} 如果 {@code clazz} 实现了 {@code interfaze} 的接口，否则
	 * {@code false}
	 */
	public static function isImplementationOf(clazz:Function, interfaze:Function):Boolean
	{
		// A interface must not be in the prototype chain.
		if (isSubClassOf(clazz, interfaze)) {
			return false;
		}
		// If it's an interface then it must not be extended but the class has
		// to be an instance of it
		return (createCleanInstance(clazz) instanceof interfaze);
	}
	
	/**
	 * 创建一个基于 {@code clazz} 无构造的新实例
	 * 
	 * @param clazz 创建新实例的基类
	 * @return 基于class的新实例
	 */
	public static function createCleanInstance(clazz:Function):Object
	{
		var result:Object = new Object();
		result.__proto__ = clazz.prototype;
		result.__constructor__ = clazz;
		return result;
	}
	
	/**
	 * 创建一个基于 {@code clazz} 的新实例，同时传递 {@code args} 作为新实例的构造参数
	 * 
	 * <p>This util is mostly made for MTASC compatibility because it doesn't
	 * allow {@code new clazz()} for usual variables.
	 * 
	 * @param clazz 建立实例的类
	 * @param args 传递给构着函数的参数
	 * @return 该类的新实例
	 */
	public static function createInstance(clazz:Function, args:Array):Object
	{
		if (!clazz) return null;
		var result:Object = new Object();
		result.__proto__ = clazz.prototype;
		result.__constructor__ = clazz;
		clazz.apply(result, args);
		return result;
	}
}
