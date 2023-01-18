import com.flade.app.ICommand;

/**
 * 
 * @author  Younes
 * @version 1.0
 * @see     ICommand	
 */
class com.flade.app.Call implements ICommand
{
	private var object: Object;
	private var method: Function;
		
	function Call( objectCall: Object, methodCall:Function )
	{
		object = objectCall;
		method = methodCall;
	}

	public static function create (scope:Object, method:Function):Function 
	{	
		var params:Array = arguments.splice (2, (arguments.length-2));
		var instance:Call = new Call(scope,method);
		return instance.execute(arguments);
	}

	function execute()
	{
    	return method.apply(object, arguments);
	}
	
}