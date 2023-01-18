/**
 * 异常信息仓库 
 * @author Wersling
 * @version 1.0, 2005-8-31
 */
class net.manaca.lang.StackTraceElement
{
	
	/* 错误信息的主体 */
	private var thrower:Object;
	
	/* 抛出方式 */
	private var method:Function;
	
	/* 引起错误的参数 */
	private var args:Array;
	
	/**
	 * 构造一个新的错误信息包
	 *
	 * @param thrower	错误信息的主体
	 * @param method	抛出方式
	 * @param args		引起错误的参数
	 */
	public function StackTraceElement(thrower:Object, method:Function, args:Array) {
		this.thrower = thrower ? thrower : null;
		this.method = method ? method : null;
		this.args = args ? args.concat() : null;
	}
	
	/*
	 * 返回错误信息的存在体
	 *
	 * @return 错误信息的存在体
	 */
	public function getThrower(Void):Object {
		return thrower;
	}
	
	/*
	 * 返回抛出错误的方法，TODO 目前无法获取方法名
	 *
	 * @return 抛出错误的方法
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/*
	 * 返回引起错误的参数
	 *
	 * @return 引起错误的参数
	 */
	public function getArguments(Void):Array {
		return args.concat();
	}	
}
