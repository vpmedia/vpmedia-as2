/**
 * @author Todor Kolev
 */
class gugga.debug.MethodCallInfo 
{
	public var ScopeObject : Object;
	public var MethodName : String;
	public var Arguments : Array;
	
	public function MethodCallInfo(aScopeObject:Object, aMethodName:String, aArguments:Array)
	{
		ScopeObject = aScopeObject;
		MethodName = aMethodName;
		Arguments = aArguments;
	}
}