import mx.events.EventDispatcher;

import gugga.common.ITask;
import gugga.utils.EventRethrower;
import gugga.utils.Listener;
import mx.utils.Delegate;

/**
 * @author Todor Kolev
 */
class gugga.sequence.MonitoringTask extends EventDispatcher implements ITask 
{
	private var mMonitoredTask : ITask;
	
	public function MonitoringTask(aMonitoredTask:ITask)
	{
		super();
		
		mMonitoredTask = aMonitoredTask;
		
		EventRethrower.create(this, mMonitoredTask, "start");		
		EventRethrower.create(this, mMonitoredTask, "completed");
		EventRethrower.create(this, mMonitoredTask, "interrupted");
	}
	
	public function start() : Void 
	{
		//TODO: If mMonitoredTask is Runnins then dispatch start
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		return mMonitoredTask.isImmediatelyInterruptable();
	}

	public function interrupt() : Void 
	{
		mMonitoredTask.interrupt();
	}
	
	public function isRunning() : Boolean 
	{
		return mMonitoredTask.isRunning();
	}

}