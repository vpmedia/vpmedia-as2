import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.IProgressiveTask;
import gugga.common.ITask;
import gugga.common.ProgressEventInfo;
import gugga.utils.EventRethrower;
import gugga.utils.Listener;

[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author Todor Kolev
 */
class gugga.sequence.ProgressiveTaskDecorator extends EventDispatcher implements IProgressiveTask 
{
	private var mProgress : Number = 0;
	private var mDispatchFakeProgressInteralID : Number;
	
	private var mFakeProgressDispatchInterval : Number = 300;
	public function get FakeProgressDispatchInterval() : Number { return mFakeProgressDispatchInterval; }
	public function set FakeProgressDispatchInterval(aValue:Number) : Void { mFakeProgressDispatchInterval = aValue; }

	private var mFakeProgressDispatchPercents : Number = 10;
	public function get FakeProgressDispatchPercents() : Number { return mFakeProgressDispatchPercents; }
	public function set FakeProgressDispatchPercents(aValue:Number) : Void { mFakeProgressDispatchPercents = aValue; }
	
	private var mWrappedTask : ITask;
	public function get WrappedTask() : ITask { return mWrappedTask; }
	
	public function ProgressiveTaskDecorator(aTask:ITask)
	{
		mWrappedTask = aTask;
		mWrappedTask.addEventListener("completed", Delegate.create(this, onWrappedTaskCompleted));
		EventRethrower.create(this, mWrappedTask, "start");
	}

	public function start() : Void 
	{
		startProgressing();
		mWrappedTask.start();
	}
	
	public function startProgressing()
	{
		mProgress = 0;
		
		mDispatchFakeProgressInteralID = setInterval(Delegate.create(this, dispatchProgress), 
			mFakeProgressDispatchInterval);
	} 

	private function onWrappedTaskCompleted(ev) : Void 
	{
		clearInterval(mDispatchFakeProgressInteralID);
		
		ev.target = this;
		dispatchEvent(ev);
	}

	private function dispatchProgress() : Void 
	{
		mProgress += mFakeProgressDispatchPercents;
		
		if(mProgress < 100)
		{
			dispatchEvent(new ProgressEventInfo(this, 100, mProgress, mProgress));
		}
		else
		{
			clearInterval(mDispatchFakeProgressInteralID);
		}
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		return mWrappedTask.isImmediatelyInterruptable();
	}

	public function interrupt() : Void
	{
		if (!isImmediatelyInterruptable())
		{
			Listener.createSingleTimeListener(
					new EventDescriptor(mWrappedTask, "interrupted"),
					Delegate.create(this, onWrappedTaskInterrupted) 
			);
		}
		
		mWrappedTask.interrupt();
	}
	
	private function onWrappedTaskInterrupted(ev) : Void 
	{
		dispatchEvent({type:"interrupted", target:this});
	}
	
	public function getProgress() : Number 
	{
		return mProgress;
	}

	public function isRunning() : Boolean 
	{
		return mWrappedTask.isRunning();
	}

}