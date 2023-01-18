class com.flade.app.Proxy 
{
	
	private function Proxy () {}
	/**
	 *	Creates a functions wrapper that runs in the provided scope.
	 * 	@usage	
	 * 		<code>
	 * 		EventDelegate.create (myObject, myEventHandler, param0,param1, [..])
	 * 		</code>	
	 *	@param	scope	Scope object which to run the function 
	 *	@param	method	Function to run
	 *	@return	Function wrapper
	 */
	public static function create (scope:Object, method:Function):Function 
	{
		var params:Array = arguments.splice (2, (arguments.length-2));
		var proxyFunc:Function = function (Void):Void 
		{
			method.apply(scope, arguments.concat (params));
		}
		return proxyFunc;
	}
}