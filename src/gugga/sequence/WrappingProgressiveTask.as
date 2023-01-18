import gugga.common.IProgressiveTask;
import gugga.common.ITask;
import gugga.sequence.WrappingTask;
import gugga.utils.EventRethrower;

/**
 * @author ivo
 */
class gugga.sequence.WrappingProgressiveTask extends WrappingTask implements IProgressiveTask 
{
	
	public function set WrappedTask(aValue:ITask) : Void 
	{ 
		super.WrappedTask = aValue;
		
		mProgressRethrower.stopListening(); 		 
		mProgressRethrower = EventRethrower.create(this, mWrappedTask, "progress");
	}	
	
	private var mProgressRethrower : EventRethrower;	
	
	public function WrappingProgressiveTask(aWrappedTask : IProgressiveTask) 
	{
		super(aWrappedTask);
	}


	public function getProgress() : Number 
	{
		return IProgressiveTask(mWrappedTask).getProgress();
	}
}