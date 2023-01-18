import mx.events.EventDispatcher;

import gugga.common.ITask;

[Event("start")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author todor
 */
class gugga.sequence.ExecuteMethodTask extends EventDispatcher implements ITask 
{
	private var mIsRunning:Boolean;
	
	private var mMethodScope:Object;
	private var mMethodFunction:Function;
	
	private var mMethodArguments : Array;
	public function get MethodArguments() : Array { return mMethodArguments; }
	public function set MethodArguments(aValue : Array) : Void { mMethodArguments = aValue; }
	
	private function ExecuteMethodTask(aMethodScope:Object, aMethodFunction:Function, aMethodArguments:Array) 
	{
		mIsRunning = false;
		mMethodScope = aMethodScope;
		mMethodFunction = aMethodFunction;
		mMethodArguments = aMethodArguments;
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function start() : Void 
	{
		mIsRunning = true;
		dispatchEvent({type:"start", target:this});
		mMethodFunction.apply(mMethodScope, mMethodArguments);
		mIsRunning = false;
		dispatchEvent({type:"completed", target:this});
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return true;
	}
	
	public function interrupt() : Void 
	{
		mIsRunning = false;
		dispatchEvent({type:"interrupted", target:this});
	}
	
	public static function create(aMethodScope:Object, aMethodFunction:Function, aMethodArguments:Array) : ExecuteMethodTask
	{
		var executeMethodTask : ExecuteMethodTask = new ExecuteMethodTask(aMethodScope, aMethodFunction, aMethodArguments);
		return executeMethodTask;
	}
}