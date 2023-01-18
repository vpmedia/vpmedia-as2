import gugga.common.IEventDispatcher;

[Event("start")]
[Event("interrupted")]
[Event("completed")]

/**
 * TODO: Shoudn't we always dispatch "interrupted" event.
 */

/**
 * @author Barni
 */
interface gugga.common.ITask extends IEventDispatcher
{
	public function start() : Void;
	
	public function isRunning() : Boolean;
	
	/**
	 * @return true if interuption comlete synchronizly 
	 * and the task will not dispatch "interuptionCompleted" event
	 * otherwise false
	 */
	public function isImmediatelyInterruptable() : Boolean;
	public function interrupt() : Void;
}