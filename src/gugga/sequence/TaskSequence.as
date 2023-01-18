import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.collections.LinkedList;
import gugga.collections.LinkedListItem;
import gugga.collections.LinkedListIterator;
import gugga.common.EventDescriptor;
import gugga.common.ITask;
import gugga.debug.Assertion;
import gugga.sequence.ITasksContainer;
import gugga.utils.Listener;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
[Event("taskAdded")]
[Event("taskRemoved")]
/**
 * <code>TaskSequence</code> is a container for sequentially executing tasks, 
 * and it is a task by itself. It will raise <b><i>completed</i></b> event, 
 * only if it is started through its <code>start()</code> method, and all of 
 * the tasks in the list are also <b><i>completed</i></b>.
 * <p>
 * The tasks container is arranged as a <code>LinkedList</code>. We iterate to 
 * the next task, only when the previous task is <b><i>completed</i></b>. 
 * <p>
 * <code>TaskSequence</code> provides functionallity to edit the 
 * <code>TasksList</code> when the <code>TaskSequence</code> is already 
 * started. The only limitation is that the currently executing task can't be 
 * deleted - an attempt to do this will raise an exception. 
 * 
 * @author Todor Kolev
 * @see gugga.collections.LinkedList
 */
class gugga.sequence.TaskSequence 
		extends EventDispatcher 
		implements ITask, ITasksContainer
{
	private var mIsRunning : Boolean;
	private var mCurrentItemCompletionListener : Listener;
	
	private var mCurrentTask : ITask;
	public function get CurrentTask() : ITask { return mCurrentTask; }

	private var mTasksList : LinkedList;
	private var mMarkedTasks : HashTable;
	 
	function TaskSequence()
	{	
		mIsRunning = false;
		mTasksList = new LinkedList();
		mMarkedTasks = new HashTable();
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function start() : Void
	{
		mIsRunning = true;
		dispatchEvent({type:"start", target:this});
		
		var task : ITask = ITask(mTasksList.getHead());
		if(task)
		{
			startTask(task);
		}
		else if(mTasksList.Count == 0)
		{
			dispatchEventLater({type:"completed", target:this});
		}
		else
		{
			Assertion.fail("Linked list failture - there are items, but no head", this, arguments);
		}
	}
	
	private function startTask(aTask : ITask) : Void
	{	
		mCurrentTask = aTask;
		mCurrentItemCompletionListener 
			= Listener.createSingleTimeListener(
					new EventDescriptor(mCurrentTask, "completed"), 
					Delegate.create(this, onTaskCompleted));
		
		mCurrentTask.start();		
	}
		
	private function onTaskCompleted(ev) : Void
	{
		if(!mTasksList.isTail(mCurrentTask))
		{
			var nextTask : ITask = getTaskAfter(mCurrentTask);
			startTask(nextTask);
		}
		else
		{
			mIsRunning = false;
			dispatchEventLater({type:"completed", target:this});
		}
	}
	
	public function addTask(aTask:ITask):Void
	{
		Assertion.failIfReturnsTrue(
				mTasksList, mTasksList.contains, [aTask],
				"This task already exists in the sequence", this, arguments);
				
		mTasksList.insertTail(aTask);
		dispatchEvent({type: "taskAdded", target: this, task: aTask});
	}
	
	public function addTaskAfter(aTargetTask:ITask, aTask:ITask):Void
	{
		Assertion.failIfReturnsTrue(
				mTasksList, mTasksList.contains, [aTask],
				"This task already exists in the sequence", this, arguments);
		
		var targetTaskListItem : LinkedListItem 
			= mTasksList.getFirstItemContaining(aTargetTask);
		
		mTasksList.insertAfter(targetTaskListItem, aTask);
		dispatchEvent({type: "taskAdded", target: this, task: aTask});
	}
	
	public function addTaskBefore(aTargetTask:ITask, aTask:ITask):Void
	{
		Assertion.failIfReturnsTrue(
				mTasksList, mTasksList.contains, [aTask],
				"This task already exists in the sequence", this, arguments);
		
		var targetTaskListItem : LinkedListItem 
			= mTasksList.getFirstItemContaining(aTargetTask);
		
		mTasksList.insertBefore(targetTaskListItem, aTask);
		dispatchEvent({type: "taskAdded", target: this, task: aTask});
	}
	
	public function removeLastTask() : Void
	{
		var task : ITask = ITask(mTasksList.getTail());
		removeTask(task);
	}

	public function removeFirstTask() : Void
	{
		var task : ITask = ITask(mTasksList.getHead());
		removeTask(task);
	}
	
	public function removeTask(aTask:ITask):Void
	{
		Assertion.failIfReturnsTrue(
				this, isCurrentlyRunning, [aTask],
				"Can not delete currently running task", this, arguments);
				
		var taskListItem : LinkedListItem 
			= mTasksList.getFirstItemContaining(aTask);
			
		mTasksList.deleteItem(taskListItem);
		dispatchEvent({type: "taskRemoved", target: this, task: aTask});
	}
	
	public function removeTaskAfter(aTargetTask:ITask):Void
	{
		var targetTaskListItem : LinkedListItem 
			= mTasksList.getFirstItemContaining(aTargetTask);
		
		Assertion.failIfReturnsTrue(
				this, isCurrentlyRunning, [targetTaskListItem.Data],
				"Can not delete currently running task", this, arguments);
		
		mTasksList.deleteAfter(targetTaskListItem);
		dispatchEvent({type: "taskRemoved", target: this, task: targetTaskListItem.Data});
	}
	
	public function removeTaskBefore(aTargetTask:ITask):Void
	{
		var precedingListItem : LinkedListItem = mTasksList.getItemPredecessor();
		var precedingTask : ITask = ITask(precedingListItem.Data);
		
		Assertion.failIfReturnsTrue(
				this, isCurrentlyRunning, [precedingTask],
				"Can not delete currently running task", this, arguments);
		
		mTasksList.deleteItem(precedingListItem);
		dispatchEvent({type: "taskRemoved", target: this, task: precedingTask});
	}
	
	public function getAllTasks() : Array 
	{		
		var iterator : LinkedListIterator 
			= LinkedListIterator(mTasksList.getIterator());
		var tasks : Array = new Array();
		
		while(iterator.iterate())
		{
			tasks.push(iterator.Current);
		}
		
		return tasks;
	}

	public function isCurrentlyRunning(aTask:ITask) : Boolean
	{
		return (aTask == mCurrentTask);
	}
	
	public function getCurrentlyRunningTask() : ITask
	{
		return mCurrentTask;
	}	

	public function getTaskAfter(aTask:ITask) : ITask
	{
		var iterator : LinkedListIterator 
			= LinkedListIterator(mTasksList.getIterator());
		var nextTask : ITask;
		
		while(iterator.iterate())
		{
			if(iterator.Current == aTask)
			{
				if(iterator.iterate())
				{
					nextTask = ITask(iterator.Current);
				}
				
				break;
			}
		}
		
		return nextTask;
	}

	public function getTaskBefore(aTask:ITask) : ITask
	{
		var iterator : LinkedListIterator 
			= LinkedListIterator(mTasksList.getIterator());
		var specifiedTaskExists : Boolean = false;
		var precedingTask : ITask;
		
		while(iterator.iterate())
		{
			if(iterator.Current == aTask)
			{
				specifiedTaskExists = true;
				break;
			}
			
			precedingTask = ITask(iterator.Current);
		}
		
		if(specifiedTaskExists)
		{
			return precedingTask;
		}
		else
		{
			return undefined;
		}
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		if(!isRunning())
		{
			return true;
		}
		else
		{
			return mCurrentTask.isImmediatelyInterruptable();
		}
	}
	
	public function interrupt() : Void
	{
		if(isRunning())
		{
			if (!isImmediatelyInterruptable())
			{
				Listener.createSingleTimeListener(
						new EventDescriptor(mCurrentTask, "interrupted"),
						Delegate.create(this, onCurrentTaskInterrupted));
			}
		
			mCurrentTask.interrupt();
			mCurrentItemCompletionListener.stop();
		}
		else
		{
			dispatchEvent({type:"interrupted", target:this});
		}
		
		mIsRunning = false;
	}	
	
	private function onCurrentTaskInterrupted(ev) : Void 
	{
		dispatchEvent({type:"interrupted", target:this});
	}

	public function getFirstTask() : ITask
	{
		return ITask(mTasksList.getHead());
	}

	public function getLastTask() : ITask
	{
		return ITask(mTasksList.getTail());
	}
	
	public function markTask(aTask:ITask, aMarker:String) : Void
	{
		mMarkedTasks[aMarker] = aTask;
	}
	
	public function getMarkedTask(aMarker:String) : ITask
	{
		return mMarkedTasks[aMarker];
	}
}