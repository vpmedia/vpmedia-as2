/**
 * @author ors
 */

/**
 * 
 * based on mx.utils.Delegate class delivered with Macromedia/Adobe Flash 8
 * 
 * enhanced to pass any number and types of arguments
 * 
 */
 
class ch.sfug.utils.Delegate {

	public static function create():Function
	{
		var f:Function;
		
		f = function()
		{	
			var target:Object = arguments.callee.target;
			var func:Function = arguments.callee.func;
			var args:Array   = arguments.callee.args;

			return func.apply(target, args.concat(arguments));
		};

		f.target = arguments.shift();
		f.func   = arguments.shift();
		f.args   = arguments;

		return f;
	}
}