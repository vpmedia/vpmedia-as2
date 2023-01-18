/*
 Copyright aswing.org, see the LICENCE.txt.
*/

/**
 * Mtasc compileable Delegate class.
 */
class net.manaca.util.Delegate{


	
	private var func:Function;
	/**
	 *Creates a functions wrapper for the original function so that it runs 
	 *in the provided context.
	 *@param obj Context in which to run the function.
	 *@param func Function to run. you can add custom parameters after this to be the 
	 *additional parameters when called the created function.
	 */
	static function create(obj:Object, func:Function):Function
	{
		
		  var params:Array = new Array();
		  var count:Number=2;
		  while(count<arguments.length){
		  	params[ count-2] = arguments[count];
		  	count++;
		  }
		  
		
		var f:Function = function()
		{
			var target:Object = arguments.callee.target;
			var func0:Function = arguments.callee.func;
            var parameters:Array = arguments.concat(params);
			return func0.apply(target, parameters);
			
		};

		f.target = obj;
		f.func = func;

		return f;
	}

	function Delegate(f:Function)
	{
		func = f;
	}

	

	public function createDelegate(obj:Object):Function
	{
		return create(obj, func);
	}	
}
