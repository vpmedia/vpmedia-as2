import mx.events.EventDispatcher;

import gugga.common.ITask;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
class gugga.sequence.WaitingTask extends EventDispatcher implements ITask 
{
	private var mWaitInterval:Number; //in seconds
	private var mIntervalID:Number;
	
	private var mIsRunning:Boolean;
	
	/**
	 * @param aWaitInterval in seconds. Default value is 0.01 seconds
	*/ 
	public function WaitingTask(aWaitInterval:Number)
	{
		if(aWaitInterval != null && aWaitInterval != undefined)
		{
			mWaitInterval = aWaitInterval;
		}
		else
		{
			mWaitInterval = 0.01;
		}
		
		mIsRunning = false;
	}
	
	public function start() : Void 
	{
		mIsRunning = true;
		dispatchEvent({type:"start", target:this});
		mIntervalID = setInterval(this, "onTimerElapsed", mWaitInterval*1000);
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
		clearInterval(mIntervalID);
		mIsRunning = false;
		dispatchEvent({type:"interrupted", target:this});
	}
	
	private function onTimerElapsed()
	{
		clearInterval(mIntervalID);
		mIsRunning = false;
		dispatchEvent({type:"completed", target:this});
	}
	
}