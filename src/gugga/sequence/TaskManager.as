import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.common.ITask;
import gugga.crypt.GUID;
import gugga.debug.Assertion;
import gugga.sequence.PreconditionsManager;
import gugga.sequence.PreconditionsTask;
import gugga.sequence.TaskManagerItem;
import gugga.utils.Listener;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
/**	
	public function addTask(aTask : ITask, aPreconditions : Array) : Void
	{
	}
*/

/**
 * TODO: Synchronize marked tasks collection with operations which edits task manager.
 * TODO: Investigate is there way to use array for storring items, to skip key generation.
 * Also see PreconditionsManager class for same issue.
 */

/**
 * <code>TaskManager</code> is a facade encapsulating the complexity in a 
 * certain web of tasks. The relationships between tasks could be very comlpex, 
 * especially if there are subsets of asynchronous tasks, waiting for 
 * <b><i>completed</i></b> or other kinds of events fired from other 
 * tasks, that could be also asynchronous. 
 * <p>
 * Behind the scenes <code>TaskManager</code> is a container for 
 * <code>TaskManagerItem</code> items and a list of final preconditions that 
 * should be met in order to fire the <b><i>completed</i></b> event.
 * 
 * @author Barni
 * @see TaskManagerItem
 * @see PreconditionsTask
 */
class gugga.sequence.TaskManager 
		extends EventDispatcher 
		implements ITask 
{
	private var mItems : HashTable;
	private var mFinalPreconditions : PreconditionsTask;
	private var mAccepting : Boolean;
	private var mMarkedTasks : HashTable;
	
	private var mIsRunning : Boolean = false;
	
	public function get ImmediatelyInterruptable() : Boolean
	{
		return isImmediatelyInterruptable();
	}
	
	public function get Tasks() : Array
	{
		var result : Array = new Array();
		for (var key : String in mItems)
		{
			result.push(TaskManagerItem(mItems[key]).ScheduledTask);
		}
		return result;
	}
	
	public function get MarkedTasks() : HashTable
	{
		return HashTable(mMarkedTasks.clone());
	}
	
	/**
	 * We can set the <b><i>accepting</i></b> state of the 
	 * <code>TaskManager</code> through this constructor.
	 * <p>
	 * The constructor will create an <b><i>accepting</i></b> 
	 * <code>TaskManager</code> by default if no argument is specified.
	 * 
	 * @param Boolean accepting state(accepting or unaccepting) 
	 * @see acceptAll()
	 * @see ignoreAll()
	 */
	public function TaskManager(aAccepting : Boolean) 
	{
		super();
		mItems = new HashTable();
		mMarkedTasks = new HashTable();
		
		if(aAccepting != undefined && aAccepting != null)
		{
			mAccepting = aAccepting;
		}
		else
		{
			mAccepting = true;
		}
		
		mFinalPreconditions = new PreconditionsTask(new PreconditionsManager(mAccepting));
		mFinalPreconditions.addEventListener(
				"completed", 
				Delegate.create(this, onFinalPreconditionsMet));
	}

	/**
	 * The <code>start()</code> method is responsible for the following actions: 
	 * <ul>
	 * 	<li>dispaches <b><i>start</i></b> event for the <code>TaskManager</code> task</li>
	 * 	<li>it starts every <code>TaskManagerItem</code></li>
	 * 	<li>it starts the final preconditions <code>PreconditionsTask</code></li>
	 * </ul>
	 */
	public function start() : Void  
	{
		mIsRunning = true;
		
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).start();	
		}
		
		mFinalPreconditions.start();
		
		dispatchEvent({type : "start", target : this});
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	/**
	 * <code>isImmediatelyInterruptable()</code> cheches for each 
	 * <code>TaskManagerItem</code> behind the facade whether it is immediately 
	 * interruptable. <code>isImmediatelyInterruptable()</code> will return 
	 * <code>true</code> only if all of the items are immediately interuptable, 
	 * and will return <code>false</code> if any of these items are not 
	 * immediately interruptable.
	 * 
	 * @return whether the <code>TaskManager</code> task is immediately interruptable
	 */
	public function isImmediatelyInterruptable() : Boolean
	{
		var result : Boolean = true;		
		for (var key : String in mItems)
		{
			if(!TaskManagerItem(mItems[key]).ImmediatelyInterruptable)
			{
				result = false;
				break;
			}
		}
		
		return result;
	}
	
	/**
	 * <code>interrupt()</code> method will interrupt all of the 
	 * <code>TaskManagerItem</code> items.
	 * <p>
	 * It will check for each <code>TaskManagerItem</code> items whether they 
	 * are immediately interruptable and for those that are not it creates a 
	 * <code>PreconditionsTask</code> that will complete, only if all of those 
	 * items raise the <b><i>interrupted</i></b> event.
	 * <p>
	 * <code>TaskManager</code> will fire the <b><i>interrupted</i></b> event 
	 * when all of its items are interrupted, but it will wait the 
	 * forementioned <code>PreconditionsTask</code> to complete, if any of the 
	 * items are not immediately interruptable.
	 */
	public function interrupt() : Void 
	{
		var itemsInterrupted : PreconditionsTask = null;
		for (var key : String in mItems)
		{
			var item : TaskManagerItem = TaskManagerItem(mItems[key]);
			if(!item.ImmediatelyInterruptable)
			{
				if(itemsInterrupted == null)
				{
					itemsInterrupted = new PreconditionsTask();
					Listener.createSingleTimeListener(
						new EventDescriptor(itemsInterrupted, "completed"), 
						Delegate.create(this, onItemsInterrupted));	
				}
				itemsInterrupted.add(new EventDescriptor(item, "interrupted"));
			}
			item.interrupt();	
		}
		
		mFinalPreconditions.interrupt();
		
		if(itemsInterrupted != null)
		{
			itemsInterrupted.start();
		}
		else
		{
			mIsRunning = false;
			dispatchEvent({type : "interrupted", target : this});
		}
	}
	
	/**
	 * Resets every <code>TaskManagerItem</code>
	 */
	public function reset() : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).reset();	
		}
		mFinalPreconditions.reset();
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will accept for the specified 
	 * precondition.
	 * 
	 * @param EventDescriptor precondition that will be accepted
	 */
	public function acceptPrecondition(aPrecondition : EventDescriptor) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).acceptPrecondition(aPrecondition);	
		}
		mFinalPreconditions.accept(aPrecondition);
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will accept for all of the 
	 * preconditions comming from the specified event source.
	 * 
	 * @param IEventDispatcher event source for preconditions, that will be accepted
	 */
	public function acceptEventSource(aEventSource : IEventDispatcher) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).acceptPreconditionsByEventSource(aEventSource);	
		}
		mFinalPreconditions.acceptEventSource(aEventSource);
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will accept for all of the 
	 * preconditions that are associated with it.
	 */
	public function acceptAll() : Void
	{
		mAccepting = true;
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).acceptAllPreconditions();	
		}
		mFinalPreconditions.acceptAll();
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will ignore the specified 
	 * precondition.
	 * 
	 * @param EventDescriptor precondition that will be ignored
	 */
	public function ignorePrecondition(aPrecondition : EventDescriptor) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).ignorePrecondition(aPrecondition);	
		}
		mFinalPreconditions.ignore(aPrecondition);
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will ignore all of the 
	 * preconditions comming from the specified event source.
	 * 
	 * @param IEventDispatcher event source for preconditions, that will be ignored
	 */
	public function ignoreEventSource(aEventSource : IEventDispatcher) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).ignorePreconditionsByEventSource(aEventSource);	
		}
		mFinalPreconditions.ignoreEventSource(aEventSource);
	}
	
	/**
	 * Every <code>TaskManagerItem</code> will ignore all of the preconditions 
	 * that are associated with it.
	 */
	public function ignoreAll() : Void
	{
		mAccepting = false;
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).ignoreAllPreconditions();	
		}
		mFinalPreconditions.ignoreAll();	
	}

	/**
	 * <code>addStartingTasks(aTask : ITask)</code> will create and add new 
	 * <code>TaskManagerItem</code> item to the <code>TaskManager</code> and 
	 * exception will be raised if the specified task is already associated 
	 * with existing <code>TaskManagerItem</code>. It will also add a 
	 * precondition to wait for <b><i>start</i></b> event from the 
	 * <code>TaskManager</code> task, in order to start the 
	 * <code>TaskManagerItem</code> item's execution. The associated 
	 * <code>TaskManagerItem</code> items will start only if the 
	 * <code>TaskManager</code> task is started, and never before it.
	 * 
	 * @param ITask new starting task
	 */
	public function addStartingTask(aTask : ITask) : Void
	{
		addTaskWithPrecondition(aTask, new EventDescriptor(this, "start"));
	}

	/**
	 * <code>addStartingTasks(aTasks : Array)</code> will create and add new 
	 * <code>TaskManagerItem</code> items to the <code>TaskManager</code> and 
	 * exception will be raised if any of the specified tasks is already 
	 * associated with existing <code>TaskManagerItem</code>. It will also add 
	 * a precondition to wait for <b><i>start</i></b> event from the 
	 * <code>TaskManager</code> task, in order to start the 
	 * <code>TaskManagerItem</code> item's execution. The associated 
	 * <code>TaskManagerItem</code> items will start only if the 
	 * <code>TaskManager</code> task is started, and never before it.
	 * 
	 * @param Array array of <code>ITask</code> items, that we want to be starting tasks
	 */
	public function addStartingTasks(aTasks : Array) : Void
	{
		for (var i : Number = 0; i < aTasks.length; i++)
		{
			addStartingTask(ITask(aTasks[i]));
		}
	}
	
	/**
	 * Checks whether there is an associated <code>TaskManagerItem</code> with 
	 * the specified task. If true, it adds to the associated 
	 * <code>TaskManagerItem</code> a precondition to wait for 
	 * <b><i>start</i></b> event from the <code>TaskManager</code> task, in 
	 * order to start its execution too. But if the check fails it will raise 
	 * an exception - the specified task is not associated with any 
	 * <code>TaskManagerItem</code> items. 
	 * <p>
	 * The associated <code>TaskManagerItem</code> item will start only if the 
	 * <code>TaskManager</code> task is started, and never before it.
	 * 
	 * @param ITask existing task 
	 */
	public function setStartingTask(aTask : ITask) : Void
	{
		Assertion.warningIfReturnsNull(
				this, findItem, [ITask(aTask)],
				"Task doesn't exist", this, arguments);
		
		var item : TaskManagerItem = findItem(ITask(aTask));
		item.addPrecondition(new EventDescriptor(this, "start"));
	}
	
	/**
	 * Checks whether there is an associated <code>TaskManagerItem</code> with 
	 * the specified task. If true, it removes from the associated 
	 * <code>TaskManagerItem</code> the precondition to wait for 
	 * <b><i>start</i></b> event from the <code>TaskManager</code> task, in 
	 * order to start its execution too. But if the check fails it will raise 
	 * an exception - the specified task is not associated with any 
	 * <code>TaskManagerItem</code> items.
	 * <p>
	 * The associated <code>TaskManagerItem</code> item will no longer wait 
	 * <code>TaskManager</code> task's start, in order to start its execution.
	 * 
	 * @param ITask existing task 
	 */
	public function revokeStartingTask(aTask : ITask) : Void
	{
		Assertion.warningIfReturnsNull(
				this, findItem, [ITask(aTask)],
				"Task doesn't exist", this, arguments);
		
		var item : TaskManagerItem = findItem(ITask(aTask));
		item.removePrecondition(new EventDescriptor(this, "start"));
	}
	
	
	/**
	 * If no <code>TaskManagerItem</code> is associated with the specified 
	 * task, the method will add a new <code>TaskManagerItem</code> to the 
	 * <code>TaskManager</code>. It will add to the new 
	 * <code>TaskManagerItem</code> a precondition waiting for 
	 * <b><i>completed</i></b> event, comming from the specified predecessor 
	 * task.
	 * 
	 * @param ITask new task or a task already associated with a <code>TaskManagerItem</code>
	 * @param ITask predecessor, that should complete in order to start the specified task
	 */
	public function addTaskWithPredecessor(
			aTask : ITask, 
			aPredecessor : ITask) : Void
	{
		addTaskWithPrecondition(aTask, 
			new EventDescriptor(aPredecessor, "completed"));
	}
	
	/**
	 * If no <code>TaskManagerItem</code> is associated with the specified 
	 * task, the method will add a new <code>TaskManagerItem</code> to the 
	 * <code>TaskManager</code>. For each predecessor task in the specified 
	 * <code>Array</code> of predecessors creates a precondition waiting for 
	 * <b><i>completed</i></b> event, comming from this predecessor task. Then 
	 * these newly created preconditions are added to the associated 
	 * <code>TaskManagerItem</code>
	 * 
	 * @param ITask new task or a task already associated with a <code>TaskManagerItem</code>
	 * @param Array array of predecessor tasks, that should complete in order to start the specified task
	 */
	public function addTaskWithPredecessors(
			aTask : ITask, 
			aPredecessors : Array) : Void
	{
		var preconditions : Array = new Array();
		for (var i : Number = 0; i < aPredecessors.length; i++)
		{
			preconditions.push(
					new EventDescriptor(aPredecessors[i], 
					"completed"));
		}
		addTaskWithPreconditions(aTask, preconditions);
	}
	
	/**
	 * Analogous to the <code>addTaskWithPredecessor()</code> method. The only 
	 * difference is that <code>addTaskPredecessor()</code> will not add a new 
	 * <code>TaskManagerItem</code> if there is no associated 
	 * <code>TaskManagerItem</code> with the specified task. On the contrary, 
	 * it will raise an exception - the specified task does not exist.
	 * 
	 * @param ITask task already associated with a <code>TaskManagerItem</code>
	 * @param Array array of predecessor tasks, that should complete in order to start the specified task
	 * 
	 * @see addTaskWithPredecessors()
	 */
	public function addTaskPredecessor(
			aTask : ITask, 
			aPredecessor : ITask) : Void
	{
		addTaskPrecondition(aTask, 
			new EventDescriptor(aPredecessor, "completed"));
	}
	
	/**
	 * Analogous to the <code>addTaskWithPredecessors()</code> method. The only 
	 * difference is that <code>addTaskPredecessors()</code> will not add a new 
	 * <code>TaskManagerItem</code> if there is no associated 
	 * <code>TaskManagerItem</code> with the specified task. On the contrary, 
	 * it will raise an exception - the specified task does not exist.
	 * 
	 * @param ITask task already associated with a <code>TaskManagerItem</code>
	 * @param Array array of predecessor tasks, that should complete in order to start the specified task
	 * 
	 * @see addTaskWithPredecessors()
	 */
	public function addTaskPredecessors(
			aTask : ITask, 
			aPredecessors : Array) : Void
	{
		var preconditions : Array = new Array();
		for (var i : Number = 0; i < aPredecessors.length; i++)
		{
			preconditions.push(
					new EventDescriptor(aPredecessors[i], 
					"completed"));
		}
		addTaskPreconditions(aTask, preconditions);
	}
	
	/**
	 * Removes for the specified task the preconditon that will be met when the 
	 * specified predecessor task is completed. The specified task will no 
	 * longer wait the completion of the predecessor. 
	 * 
	 * @param ITask the task that will no longer wait for the predecessor's completion
	 * @param ITask the predecessor task 
	 */
	public function removeTaskPredecessor(
			aTask : ITask, 
			aPredecessor : ITask) : Void
	{
		removeTaskPrecondition(
				aTask, 
				new EventDescriptor(aPredecessor, "completed"));
	}
	
	/**
	 * If no <code>TaskManagerItem</code> is associated with the specified 
	 * task, the method will add new <code>TaskManagerItem</code> to the 
	 * <code>TaskManager</code>. Then the specified precondition is added to 
	 * the new <code>TaskManagerItem</code>. 
	 * <p>
	 * An exception will be raised if there is an existing 
	 * <code>TaskManagerItem</code> associated with the specified task.
	 * 
	 * @param ITask new task or a task already associated with a <code>TaskManagerItem</code>
	 * @param Array array of preconditions, that should be met
	 */
	public function addTaskWithPrecondition(
			aTask : ITask, 
			aPrecondition : EventDescriptor) : Void
	{
		Assertion.warningIfReturnsNotNull(
				this, findItem, [aTask],
				"Task have been already added.", this, arguments);
		
		var item : TaskManagerItem = createItem(aTask);
		item.addPrecondition(aPrecondition);
		applyNewItemState(item);
	}
	
	/**
	 * If no <code>TaskManagerItem</code> is associated with the specified 
	 * task, the method will add a new <code>TaskManagerItem</code> to the 
	 * <code>TaskManager</code>. Then the preconditions in the specified array 
	 * are added to the new  <code>TaskManagerItem</code>. 
	 * <p>
	 * An exception will be raised if there is an existing 
	 * <code>TaskManagerItem</code> associated with the specified task.
	 * 
	 * @param ITask new task or a task already associated with a <code>TaskManagerItem</code>
	 * @param Array array of preconditions, that should be met
	 */
	public function addTaskWithPreconditions(
			aTask : ITask, 
			aPreconditions : Array) : Void
	{
		Assertion.warningIfReturnsNotNull(
				this, findItem, [aTask],
				"Task have been already added.", this, arguments);
		
		var item : TaskManagerItem = createItem(aTask);
		for (var i : Number = 0; i < aPreconditions.length; i++)
		{
			item.addPrecondition(EventDescriptor(aPreconditions[i]));
		}
		applyNewItemState(item);
	}
	
	/**
	 * Adds the specified precondition to the associated with the specified 
	 * task <code>TaskManagerItem</code>. If no <code>TaskManagerItem</code> is 
	 * associated with the specified task, the method will raise an exception. 
	 * 
	 * @param ITask task already associated with a <code>TaskManagerItem</code>
	 * @param EventDescriptor precondition
	 */
	public function addTaskPrecondition(
			aTask : ITask, 
			aPrecondition : EventDescriptor) : Void
	{
		Assertion.warningIfReturnsNull(
				this, findItem, [aTask],
				"Task doesn't exist.", this, arguments);
		
		var item : TaskManagerItem = findItem(aTask);
		item.addPrecondition(aPrecondition);
	}
	
	/**
	 * Adds the specified preconditions to the associated with the specified 
	 * task <code>TaskManagerItem</code>. If no <code>TaskManagerItem</code> is 
	 * associated with the specified task, the method will raise an exception. 
	 * 
	 * @param ITask task already associated with a <code>TaskManagerItem</code>
	 * @param Array preconditions
	 */
	public function addTaskPreconditions(
			aTask : ITask, 
			aPreconditions : Array) : Void
	{
		Assertion.warningIfReturnsNull(
				this, findItem, [aTask],
				"Task doesn't exist.", this, arguments);
		
		var item : TaskManagerItem = findItem(aTask);
		for (var i : Number = 0; i < aPreconditions.length; i++)
		{
			item.addPrecondition(EventDescriptor(aPreconditions[i]));
		}
	}
	
	/**
	 * Removes the specified precondition if there is an associated 
	 * <code>TaskManagerItem</code> with the specified task.
	 *
	 * @param ITask task already associated with a <code>TaskManagerItem</code>
	 * @param EventDescriptor precondition
	 */
	public function removeTaskPrecondition(
			aTask : ITask, 
			aPrecondition : EventDescriptor) : Void
	{
		var item : TaskManagerItem = findItem(aTask);
		if(item != null)
		{
			item.removePrecondition(aPrecondition);			
		}
	}
	
	/**
	 * Adds preconditions to the final preconditions list.
	 * 
	 * @param Array array of preconditions
	 */
	public function addFinalPreconditions(aPreconditions : Array) : Void
	{
		for (var i : Number = 0; i < aPreconditions.length; i++)
		{
			mFinalPreconditions.add(EventDescriptor(aPreconditions[i]));
		}
	}
	
	/**
	 * Removes the specified precondition from the final preconditions list.
	 * 
	 * @param EventDescriptor precondition 
	 */
	public function removeFinalPrecondition(aPrecondition : EventDescriptor) : Void
	{
		mFinalPreconditions.remove(aPrecondition);
	}
	
	/**
	 * Adds a precondition to the final preconditions list. The new 
	 * precondition will be met, when the specified task is completed. 
	 * 
	 * @param ITask task, that should complete in order to meet one of the final preconditions for the <code>TaskManager</code> task
	 */
	public function setFinalTask(aTask : ITask) : Void
	{
		addFinalPreconditions([new EventDescriptor(aTask, "completed")]);
	}
	
	/**
	 * Removes the precondition that should be met, when the specified task is 
	 * completed. This precondition will be no longer in the final 
	 * preconditions list. 
	 * 
	 * @task ITask task, that no longer should be completed in order to meet the final preconditions for the <code>TaskManager</code> task
	 */
	public function revokeFinalTask(aTask : ITask) : Void
	{
		removeFinalPrecondition(new EventDescriptor(aTask, "completed"));
	}
	
	public function markTask(aTask:ITask, aMarker:String) : Void
	{
		mMarkedTasks[aMarker] = aTask;
	}
	
	public function getMarkedTask(aMarker:String) : ITask
	{
		return mMarkedTasks[aMarker];
	}
	
	public function getTaskMarker(aTask : ITask) : String
	{
		return mMarkedTasks.getKeyByValue(aTask);
	}
	
	/**
	 * If <code>TaskManagerItem</code> is associated with the specified task, 
	 * it will remove this item and all preconditions in the 
	 * <code>TaskManager</code> associated with the specified task.
	 * 
	 * @param ITask task that will be no longer tracked in the <code>TaskManager</code>
	 */
	public function removeTask(aTask : ITask) : Void
	{
		var item : TaskManagerItem = findItem(aTask);
		if(item != null)
		{
			removeItem(aTask);
			removeAssociatedPreconditions(aTask);
		}
	}
	
	/**
	 * If <code>TaskManagerItem</code> is associated with the specified task, 
	 * it will replase its scheduled task with the new one. It will also 
	 * replace the event sources of the preconditions that are listening for 
	 * events comming from the old task. The new task will be the new source 
	 * for them.
	 * 
	 * @param ITask old task
	 * @param ITask new task
	 */
	public function replaceTask(
			aTask : ITask, 
			aNewTask : ITask) : Void
	{
		var item : TaskManagerItem = findItem(aTask);
		if(item != null)
		{
			item.ScheduledTask = aNewTask;
			replaceAssociatedPreconditions(aTask, aNewTask);
		}
	}
	
	private function createItem(aTask : ITask) : TaskManagerItem
	{
		var key : String = generateKey();
		var result : TaskManagerItem = new TaskManagerItem(aTask, mAccepting);
		mItems.add(key, result);
		return result;
	}
	
	private function findItem(aTask : ITask) : TaskManagerItem
	{
		var result : TaskManagerItem = null;
		var key : String = findItemKey(aTask);
		if(key != null)
		{
			result = TaskManagerItem(mItems[key]);
		}
		
		return result;	
	}
	
	private function findItemKey(aTask : ITask) : String
	{
		var result : String = null;
		for (var key : String in mItems)
		{
			if(TaskManagerItem(mItems[key]).ScheduledTask == aTask)
			{
				result = key;
				break;
			}
		}
		
		return result; 
	}
	
	private function removeItem(aTask : ITask) : Void
	{
		var key : String = findItemKey(aTask);
		if(key != null)
		{
			TaskManagerItem(mItems.remove(key)).dispose();
		}
	}
	
	private function removeAssociatedPreconditions(aTask : ITask) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).removePreconditionsByEventSource(aTask);
		}
		
		mFinalPreconditions.removeByEventSource(aTask);
	}

	private function replaceAssociatedPreconditions(
			aTask : ITask, 
			aNewTask : ITask) : Void
	{
		for (var key : String in mItems)
		{
			TaskManagerItem(mItems[key]).replacePreconditionsEventSource(aTask, aNewTask);
		}
		
		mFinalPreconditions.replaceEventSource(aTask, aNewTask);
	}
	
	private function generateKey() : String
	{
		var result : String = GUID.create();
		while(mItems.containsKey(result))
		{
			result = GUID.create();	
		}
		return result;
	}
	
	private function applyNewItemState(aItem : TaskManagerItem) : Void
	{
		/**
		 * TODO: Is this the only case? Shouldn't be revised?
		 */
		if(mIsRunning)
		{
			aItem.start();
		}
	}
	
	private function onFinalPreconditionsMet() : Void
	{
		mIsRunning = false;
		
		dispatchEvent({type : "completed", target : this});
	}

	private function onItemsInterrupted() : Void 
	{
		mIsRunning = false;
		
		dispatchEvent({type : "interrupted", target : this});		
	}
}