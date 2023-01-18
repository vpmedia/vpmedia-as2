import mx.events.EventDispatcher;

import gugga.common.ITask;
import gugga.utils.EventRethrower;
import gugga.debug.Assertion;

/**
 * @author Todor Kolev
 */
class gugga.sequence.WrappingTask extends EventDispatcher implements ITask 
{
	private var mWrappedTask : ITask;
	public function get WrappedTask() : ITask { return mWrappedTask; }
	public function set WrappedTask(aValue:ITask) : Void 
	{ 
		mWrappedTask = aValue;

		mCompletedRethrower.stopListening();
		mInterruptedRethrower.stopListening();
		mStartRethrower.stopListening();	 
		 
		mCompletedRethrower = EventRethrower.create(this, mWrappedTask, "completed");
		mInterruptedRethrower = EventRethrower.create(this, mWrappedTask, "interrupted");
		mStartRethrower = EventRethrower.create(this, mWrappedTask, "start");	 
	}	
	
	private var mCompletedRethrower : EventRethrower;
	private var mInterruptedRethrower : EventRethrower;
	private var mStartRethrower : EventRethrower;	
	
	public function WrappingTask(aWrappedTask:ITask) 
	{
		super();
		WrappedTask = aWrappedTask;
	}
		
	public function start() : Void 
	{
		Assertion.warningIfNull(mWrappedTask, "WrappedTask not set", this, arguments);
		
		mWrappedTask.start();
	}

	public function isRunning() : Boolean 
	{
		return mWrappedTask.isRunning();
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		return mWrappedTask.isImmediatelyInterruptable();
	}

	public function interrupt() : Void 
	{
		mWrappedTask.interrupt();	
	}
}