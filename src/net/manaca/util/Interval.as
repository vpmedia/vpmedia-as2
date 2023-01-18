/**
 * 功能：封装setInterval，实现每隔一定的时间，调用函数、方法或对象。
 * 使用：
 * import ezingy.core.utils.Interval
 *  new Interval(50,this,ondd,)
 * @author Jiagao
 * @version 1.0, 2005-8-30
 * @updatelist 2005-8-30, Jiagao, 
 */
class net.manaca.util.Interval
{
	private static var className : String = "net.manaca.util.Interval";
	/*
	 * 间隔标识符，可以将该标识符传递给 clearInterval() 以取消该间隔。
	 */
	private var _intervalID:Number;
	/**
	 * @param time 毫秒
	 * @param this 对象
	 * @param fun 方法
	 */
	public function Interval() {
		var interval:Number = Number(arguments.shift());
		_intervalID = setInterval(this, "onTimeout", interval, arguments);
	}
	
	/*
	 * 取消
	 */
	public function cancel():Void {
		clear();
	}
	
	/*
	 * 
	 */
	private function onTimeout(args:FunctionArguments):Void {
		clear();
		var scope:Object = args.shift();
		//trace(scope);
		var func:Function = Function(args.shift());
		//trace(func);
		func.apply(scope, args);
	}
	
	/*
	 * 清除对setInterval()的调用。
	 */
	private function clear():Void {
		clearInterval(_intervalID);
		delete _intervalID;
	}
}
