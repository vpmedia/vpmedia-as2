import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.common.ITask;
import gugga.sequence.PreconditionsManager;
import gugga.sequence.PreconditionsTask;
import gugga.sequence.TaskManagerItemStates;
import gugga.utils.Listener;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
/**
 * This is an internal class used only by the <code>TaskManager</code> class. 
 * <code>TaskManagerItem</code> is a task, composed by two tasks:
 * <ul>
 * 	<li><code>PreconditionsTask</code> encapsulating all preconditions needed for starting the scheduled task</li>
 * 	<li><code>ScheduledTask</code> an arbitrary task that will start, only if all preconditions are met, and the <code>PreconditionsTask</code> is completed</li>
 * </ul>
 * @author Barni
 */
class gugga.sequence.TaskManagerItem 
		extends EventDispatcher 
		implements ITask
{
	private var mScheduledTask : ITask;
	private var mPreconditions : PreconditionsTask;
	private var mState : TaskManagerItemStates;
	private var mScheduledTaskCompletedListener : Listener;
	
	public function get ScheduledTask() : ITask
	{
		return mScheduledTask;
	}
	
	public function set ScheduledTask(aValue : ITask) : Void
	{
		mScheduledTaskCompletedListener.stop();
		mScheduledTask = aValue;
		mScheduledTaskCompletedListener = new Listener(
				new EventDescriptor(mScheduledTask, "completed"),
				Delegate.create(this, onScheduledTaskCompleted), 
				null, 
				true);
		
		if(mState == TaskManagerItemStates.Running)
		{
			mScheduledTask.start();		
		}
	}
	
	public function get ImmediatelyInterruptable() : Boolean
	{
		return isImmediatelyInterruptable();
	}
	
	public function TaskManagerItem(
			aScheduledTask : ITask, 
			aAccepting : Boolean)
	{
		mScheduledTask = aScheduledTask;
		mScheduledTaskCompletedListener = new Listener(
				new EventDescriptor(mScheduledTask, "completed"),
				Delegate.create(this, onScheduledTaskCompleted), 
				null, 
				true);
		
		mPreconditions = new PreconditionsTask(new PreconditionsManager(aAccepting));
		mPreconditions.addEventListener(
				"completed", 
				Delegate.create(this, onPreconditionsMet));
		
		mState = TaskManagerItemStates.Pending;
	}
	
	public function addPrecondition(aPrecondition : EventDescriptor) : Void
	{
		mPreconditions.add(aPrecondition);
	}
	
	public function removePrecondition(aPrecondition : EventDescriptor) : Void
	{
		mPreconditions.remove(aPrecondition);
	}
	
	public function removePreconditionsByEventSource(aEventSource : IEventDispatcher) : Void
	{
		mPreconditions.removeByEventSource(aEventSource);
	}
	
	public function replacePreconditionsEventSource(
			aEventSource : IEventDispatcher, 
			aNewEventSource : IEventDispatcher) : Void
	{
		mPreconditions.replaceEventSource(aEventSource, aNewEventSource);
	}
	
	public function acceptPrecondition(aPrecondition : EventDescriptor) : Void
	{
		mPreconditions.accept(aPrecondition);
	}
	
	public function acceptPreconditionsByEventSource(aEventSource : IEventDispatcher) : Void
	{
		mPreconditions.acceptEventSource(aEventSource);
	}
	
	public function acceptAllPreconditions() : Void
	{
		mPreconditions.acceptAll();
	}
	
	public function ignorePrecondition(aPrecondition : EventDescriptor) : Void
	{
		mPreconditions.ignore(aPrecondition);
	}
	
	public function ignorePreconditionsByEventSource(aEventSource : IEventDispatcher) : Void
	{
		mPreconditions.ignoreEventSource(aEventSource);
	}
	
	public function ignoreAllPreconditions() : Void
	{
		mPreconditions.ignoreAll();
	}
	
	/**
	 * @see gugga.sequence.PreconditionsManager.reset()
	 */
	public function reset() : Void
	{
		mState = TaskManagerItemStates.Pending;
		mScheduledTaskCompletedListener.stop();
		mPreconditions.reset();
	}	
	
	public function start() : Void 
	{
		if(mState != TaskManagerItemStates.Pending)
		{
			reset();
		}
		
		mPreconditions.start();
	}

	/**
	 * TODO: Should be implemented.
	 */
	public function isRunning() : Boolean 
	{
		return null;
	}
	
	/**
	 * <code>isImmediatelyInterruptable()</code> always returns <code>true</code> 
	 * when <code>TaskManagerItem</code> is not in <code>TaskManagerItemStates.Running</code> 
	 * state. When <code>TaskManagerItem</code> is in <code>TaskManagerItemStates.Running</code> 
	 * state, <code>isImmediatelyInterruptable()</code> returns <code>true</code> 
	 * only if the scheduled task is immediately interruptable.
	 */
	public function isImmediatelyInterruptable() : Boolean 
	{
		var result : Boolean = true;
		if(mState == TaskManagerItemStates.Running)
		{
			result = mScheduledTask.isImmediatelyInterruptable();
		}
		return result;	
	}

	/**
	 * TODO: Should examine case when changing ScheduledTask while interrupting
	 * <p>
	 * <code>interrupt()</code> will check whether the 
	 * <code>TaskManagerItem</code> state is <code>TaskManagerItemStates.Running</code>.
	 * <p> 
	 * If in running state, it will check whether the scheduled task is 
	 * <code>isImmediatelyInterruptable</code> and if it isn't, it will create 
	 * a listener which is subscribed to the <b><i>interrupted</i></b> event of 
	 * the scheduled task - the <code>TaskManagerItem</code> will be 
	 * <b><i>interrupted</i></b> right after this event is caught and consumed. 
	 * If the scheduled task is <code>isImmediatelyInterruptable</code> it will 
	 * be directly interrupted, and right after it, the <code>TaskManagerItem</code> 
	 * will be also interrupted. 
	 * <p>
	 * If not in running state, it will interrupt the preconditions task, 
	 * before putting <code>TaskManagerItem</code> in interrupted state. 
	 */
	public function interrupt() : Void 
	{
		if(mState == TaskManagerItemStates.Running)
		{
			mScheduledTaskCompletedListener.stop();
			if(!mScheduledTask.isImmediatelyInterruptable())
			{
				Listener.createSingleTimeListener(
						new EventDescriptor(mScheduledTask, "interrupted"),
						Delegate.create(this, onScheduledTaskInterrupted));
				mScheduledTask.interrupt();
			}
			else
			{
				mScheduledTask.interrupt();
				changeToInterruptedState();
			}
		}
		else
		{
			mPreconditions.interrupt();
			changeToInterruptedState();
		}
	}
	
	public function dispose() : Void
	{
		mScheduledTaskCompletedListener.stop();
		mPreconditions.ignoreAll();
	}
	
	private function changeToInterruptedState() : Void
	{
		mState = TaskManagerItemStates.Interrupted;
		dispatchEvent({type : "interrupted", target : this});
	}

    private function onPreconditionsMet(ev) : Void 
	{
		mState = TaskManagerItemStates.Running;
		
		dispatchEvent({type : "start", target : this});
		
		mScheduledTaskCompletedListener.start();
		mScheduledTask.start();
	}
	
	private function onScheduledTaskCompleted(ev) : Void 
	{
		mState = TaskManagerItemStates.Completed;
		dispatchEvent({type : "completed", target : this});
	}
	
	private function onScheduledTaskInterrupted(ev) : Void 
	{
		changeToInterruptedState();
	}
}