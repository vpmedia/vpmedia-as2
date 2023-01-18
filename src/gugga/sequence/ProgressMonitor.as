import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.common.IProgressiveTask;
import gugga.common.ITask;
import gugga.common.ProgressEventInfo;
import gugga.components.ProgressBar;
import gugga.debug.Assertion;
import gugga.sequence.ITasksContainer;
import gugga.sequence.ProgressiveTaskDecorator;
import gugga.utils.DebugUtils;
import gugga.utils.Listener;
import gugga.sequence.MonitoringProgressiveTask;

/**
 * @author Todor Kolev
 */
class gugga.sequence.ProgressMonitor extends EventDispatcher implements IProgressiveTask 
{
	private var mLastGeneratedItemID : Number = 0;
	
	private var mItemParts : HashTable;
	private var mItems : HashTable;
	private var mFixedItems : HashTable;
	private var mCompletedItems : HashTable;
	
	private var mProgressListeners : HashTable;
	private var mCompleteListeners : HashTable;
	
	private var mVariableItemsCount : Number = 0;
	private var mFixedItemsCount : Number = 0;
	private var mFixedItemsPartSum : Number = 0;
	
	private var mProgress : Number = 0;	
	private var mRunning : Boolean = false;
	private var mProgressBar : ProgressBar;
	
	public function ProgressMonitor() 
	{
		mItemParts = new HashTable();
		mItems = new HashTable();
		mFixedItems = new HashTable();
		mCompletedItems = new HashTable();
		mProgressListeners = new HashTable();
		mCompleteListeners = new HashTable();
	}
	
	public function start() : Void 
	{ 
		mRunning = true;
		dispatchEvent({type : "start", target : this});
		
		if(mCompletedItems.count == mItems.count)
		{
			//TODO: Sheduele all these for nex frame - same in Preconditions task
			//Someone can call start, but mRunning will be false, and event is still not dispatched!
			
			mRunning = false;
			mProgressBar.progressFull();
			
			dispatchEventLater({type : "completed", target : this});
		}
	}

	public function attachProgressBar(aProgressBar:ProgressBar)
	{
		mProgressBar = aProgressBar;
	}

	public function addItems(aItems : Array) : Void
	{
		for (var i:Number = 0; i < aItems.length; i++)
		{
			addTask(aItems[i]);
		}
	}
	
	//TODO: removeTask()
	public function addTask(aTask : ITask) : Void
	{
		if(aTask instanceof IProgressiveTask)
		{
			addItem(IProgressiveTask(aTask));
		}
		else if(aTask instanceof ITasksContainer)
		{
			monitorTasksContainer(ITasksContainer(aTask));
		}
		else if(aTask instanceof ITask)
		{
			var progressiveDecorator : ProgressiveTaskDecorator
				= new ProgressiveTaskDecorator(aTask);
		
			//should be done when ProgressMonitor is started 
			progressiveDecorator.startProgressing();	
		
			addItem(progressiveDecorator);	
		}
		else
		{
			Assertion.fail("Argument aTask is not instance of IProgressiveTask or ITask", this, arguments);
		}
	}
	
	public function addFixedPartTask(aTask : ITask, aPercentagePart : Number) : Void
	{
		if(aTask instanceof IProgressiveTask)
		{
			addFixedPartItem(IProgressiveTask(aTask), aPercentagePart);
		}
		else if(aTask instanceof ITask)
		{
			var progressiveDecorator : ProgressiveTaskDecorator
				= new ProgressiveTaskDecorator(aTask);
				
			addFixedPartItem(progressiveDecorator, aPercentagePart);	
		}
		else
		{
			Assertion.fail("Argument aTask is not instance of IProgressiveTask or ITask", this, arguments);
		}
	}
	
	public function addItem(aItem : IProgressiveTask) : Void
	{
		mLastGeneratedItemID++;
		mVariableItemsCount++;
		
		mItems[mLastGeneratedItemID] = aItem;
		
		recalculateItemParts();
		setItemListeners(aItem, mLastGeneratedItemID);
	}

	public function addFixedPartItem(aItem : IProgressiveTask, aPercentagePart : Number) : Void
	{
		mLastGeneratedItemID++;
		mFixedItemsCount++;
		
		mItems[mLastGeneratedItemID] = aItem;
		mItemParts[mLastGeneratedItemID] = aPercentagePart;
		
		mFixedItems[mLastGeneratedItemID] = aItem;
		mFixedItemsPartSum += aPercentagePart;
		
		recalculateItemParts();
		setItemListeners(aItem, mLastGeneratedItemID);
	}
	
	public function removeItems(aItems : Array) : Void
	{
		for (var i:Number = 0; i < aItems.length; i++)
		{
			removeItem(aItems[i]);
		}
	}
	
	public function removeItem(aItem : IProgressiveTask) : Void
	{
		var itemID : Number = null;
		
		for (var key:String in mItems)
		{
			if(mItems[key] === aItem)
			{
				itemID = Number(key);
				break;
			}
		}
		
		Assertion.warningIfNull(itemID, "Suplied item does not exists in the monitored collection", this, arguments);
		
		if(mFixedItems.containsKey(itemID))
		{
			mFixedItems.remove(itemID);
			mFixedItemsCount--;
			mFixedItemsPartSum -= mItemParts[itemID];
		}
		else
		{
			mVariableItemsCount--;
		}
		
		Listener(mProgressListeners[itemID]).stop();
		Listener(mCompleteListeners[itemID]).stop();
		
		mProgressListeners.remove(itemID);
		mCompleteListeners.remove(itemID);
		mCompletedItems.remove(itemID);
		mItemParts.remove(itemID);
		mItems.remove(itemID);
		
		recalculateItemParts();
	}
	
	private function setItemListeners(aItem:IProgressiveTask, aItemID:Number)
	{
		mProgressListeners[aItemID] = Listener.createMergingListener(
			new EventDescriptor(aItem, "progress"),
			Delegate.create(this, onItemProgressed),
			{itemID: aItemID}
		);

		mCompleteListeners[aItemID] = Listener.createSingleTimeMergingListener(
			new EventDescriptor(aItem, "completed"),
			Delegate.create(this, onItemCompleted),
			{itemID: aItemID}
		);
	}
	
	private function recalculateItemParts() : Void
	{
		var variableItemPart : Number = (100 - mFixedItemsPartSum) / mVariableItemsCount;
		
		for (var key:String in mItems)
		{
			if(!mFixedItems.containsKey(key))
			{
				mItemParts[key] = variableItemPart;
			}
		}
	}

	private function onItemProgressed(ev) : Void
	{
		if(mRunning)
		{
			var actualProgress : Number = 0;
			
			for (var key:String in mItems)
			{
				if(mCompletedItems.containsKey(key))
				{
					actualProgress += mItemParts[key];
				}
				else
				{
					actualProgress += mItemParts[key] * (IProgressiveTask(mItems[key]).getProgress() / 100);				
				}
			}
			
			if(actualProgress > mProgress)
			{
				mProgress = actualProgress;
				mProgressBar.progressTo(mProgress);
				
				dispatchEvent(new ProgressEventInfo(this, 100, mProgress, mProgress));
			}
		}
	}
	
	private function onItemCompleted(ev) : Void
	{
		var itemID : Number = ev.itemID;
		
		Listener(mProgressListeners[itemID]).stop();
		mCompletedItems[itemID] = true;
		
		if(mRunning)
		{	
			onItemProgressed();
				
			if(mCompletedItems.count == mItems.count)
			{
				mRunning = false;
				mProgressBar.progressFull();
				
				dispatchEvent({type:"completed", target:this});
			}
		}
	} 

	public function isImmediatelyInterruptable() : Boolean 
	{
		return true;
	}

	public function interrupt() : Void 
	{
		mRunning = false;
	}
	
	public function getProgress() : Number 
	{
		return mProgress;
	}

	public function isRunning() : Boolean 
	{
		return mRunning;
	}
	
	//TODO: stopMonitoringTasksContainer()
	public function monitorTasksContainer(aTasksContainer : ITasksContainer)
	{
		var containedTasks : Array = aTasksContainer.getAllTasks();
		addItems(containedTasks);
		
		aTasksContainer.addEventListener("taskAdded", Delegate.create(this, onMonitoredContainerTaskAdded));
		aTasksContainer.addEventListener("tasksAdded", Delegate.create(this, onMonitoredContainerTasksAdded));
		aTasksContainer.addEventListener("taskRemoved", Delegate.create(this, onMonitoredContainerTaskRemoved));
		aTasksContainer.addEventListener("tasksRemoved", Delegate.create(this, onMonitoredContainerTasksRemoved));
	}
		
	private function onMonitoredContainerTaskAdded(ev) : Void 
	{
		var task = ev.task;
		addTask(task);
	}

	private function onMonitoredContainerTasksAdded(ev) : Void 
	{
		var tasks = ev.tasks;
		addItems(tasks);
	}

	private function onMonitoredContainerTaskRemoved(ev) : Void 
	{
		var task = ev.task;
		removeItem(task);
	}

	private function onMonitoredContainerTasksRemoved(ev) : Void 
	{
		var tasks = ev.tasks;
		removeItems(tasks);
	}
}