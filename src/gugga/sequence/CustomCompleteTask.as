import mx.events.EventDispatcher;

import gugga.common.ITask;

/**
 * @author Todor Kolev
 */
class gugga.sequence.CustomCompleteTask extends EventDispatcher implements ITask 
{
	private var mIsRunning : Boolean;
	
	public function start() : Void 
	{
		mIsRunning = true;
		dispatchEvent({type: "start", target: this});
	}
	
	public function complete() : Void 
	{
		mIsRunning = true;
		dispatchEvent({type: "completed", target: this});
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		return true;
	}

	public function interrupt() : Void 
	{
		mIsRunning = false;
		dispatchEvent({type: "interrupted", target: this});
	}
}