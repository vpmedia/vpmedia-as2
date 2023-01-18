import gugga.common.IProgressiveTask;
import gugga.sequence.MonitoringTask;
import gugga.utils.EventRethrower;

[Event("progress")]

/**
 * @author Todor Kolev
 */
class gugga.sequence.MonitoringProgressiveTask extends MonitoringTask implements IProgressiveTask 
{
	public function MonitoringProgressiveTask(aMonitoredTask:IProgressiveTask)
	{
		super(aMonitoredTask);
		EventRethrower.create(this, mMonitoredTask, "progress");		
	}
	
	public function getProgress() : Number 
	{
		return IProgressiveTask(mMonitoredTask).getProgress();
	}

}