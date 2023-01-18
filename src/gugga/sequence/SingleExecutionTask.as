import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.ITask;
import gugga.utils.Listener;
import gugga.common.EventDescriptor;

[Event("start")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author Todor Kolev
 */
class gugga.sequence.SingleExecutionTask extends EventDispatcher implements ITask 
{
	private var mIsRunning:Boolean;
	
	private var mActualTask : ITask;
	private var mExecuted : Boolean = false;
	
	public function SingleExecutionTask(aActualTask : ITask) 
	{
		super();
		
		mIsRunning = false;
		
		mActualTask = aActualTask;
		mActualTask.addEventListener("completed", Delegate.create(this, onCompleted));
		mActualTask.addEventListener("start", Delegate.create(this, onStarted));	
	}
	
	public function start() : Void 
	{
		if(!mExecuted)
		{
			mIsRunning = true;
			mActualTask.start();
			mExecuted = true;
		}
		else
		{
			dispatchEventLater({type:"completed", target:this});
		}
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return mActualTask.isImmediatelyInterruptable();
	}
	
	public function interrupt() : Void
	{
		if(!isImmediatelyInterruptable())
		{
			Listener.createSingleTimeListener(new EventDescriptor(mActualTask, "interrupted"), 
				Delegate.create(this, onActualTaskInterrupted));
		}
		
		mActualTask.interrupt();	
	}
	
	private function onStarted(ev)
	{
		mExecuted = true;
		
		ev.target = this;
		dispatchEvent(ev);
	}
	
	private function onActualTaskInterrupted(ev)
	{
		mIsRunning = false;
		dispatchEvent({type:"interrupted", target:this});
	}
	
	private function onCompleted(ev)
	{
		mIsRunning = false;
		
		ev.target = this;
		dispatchEvent(ev);
	}
	
}