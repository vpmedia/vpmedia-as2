import net.manaca.lang.StackTraceElement;
import net.manaca.lang.BObject;
/**
 * 所有错误或异常的超类 
 * @author Wersling
 * @version 1.0, 2005-8-31
 */

class net.manaca.lang.Throwable extends BObject
{
	private var className : String = "net.manaca.lang.Throwable";
	/** 错误信息 */
	private var message:String;
	/** 错误信息包 */
	private var _StackTraceElementnew : StackTraceElement;
	/** 错误存在原因 */
	private var _cause : Object;
	
	/** 
	 * 构造函数：获取异常信息并处理 
	 * @param message  信息
	 * @param thrower  抛出信息的主体
	 * @param args 	所带参数
	 */
	public function Throwable(message:String, thrower:Object, args:Array)
	{
		super(message);
		this.message = message;
		
		addStackTraceElement(thrower, args.callee, args);
		this["cast"]();
		//trace('错误: '+message);
		//trace('错误存在于: ' + thrower.className);
		//trace('引起错误的信息: ' + args.join(" , "));
		//Tracer.error(this);
	}
	
	/** 用法：将错误保存在信息堆中 */
	public function addStackTraceElement(thrower:Object, method:Function, args:Array):Void
	{
		_StackTraceElementnew = new StackTraceElement(thrower, method, args);
	}
	
	/** 返回信息 */
	public function getStackTrace(Void):StackTraceElement
	{
		return _StackTraceElementnew;
	}
	
	/** 获取原因 */
	public function getCause(Void):Object
	{
		return _cause;
	}
	
	/** 设置原因 */
	public function setCause(c:Object):Void{
		_cause = c;
	}
	
	/** 获取信息 */
	public function getMessage(Void):String
	{
		return message;
	}
}
