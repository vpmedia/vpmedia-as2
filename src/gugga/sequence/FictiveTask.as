import mx.events.EventDispatcher;

import gugga.common.IProgressiveTask;

[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]
/**
 * <code>FictiveTask</code> is a task that immediately after its 
 * <code>start()</code> fires the <b><i>start</i></b>, <b><i>progress</i></b> 
 * and <b><i>completed</i></b> events. 
 * <p>
 * You can find <code>FictiveTask</code> useful especially for test purposes.
 * 
 * @author Barni
 */
class gugga.sequence.FictiveTask 
		extends EventDispatcher 
		implements IProgressiveTask 
{
	private var mIsRunning:Boolean = false;
	private var mProgress:Number = 0;
	
	public function start() : Void
	{
		mIsRunning = true;
		mProgress = 0;
		dispatchEvent({type:"start", target:this});
		dispatchEvent({type:"progress", target:this, percents:100, total:100, current:100});
		mProgress = 100;
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
	
	public function getProgress() : Number 
	{
		return mProgress;
	}

	public function isRunning() : Boolean {
		return mIsRunning;
	}
}