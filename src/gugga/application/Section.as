import mx.utils.Delegate;

import gugga.application.ISection;
import gugga.common.EventDescriptor;
import gugga.common.IProgressiveTask;
import gugga.common.ITask;
import gugga.common.UIComponentEx;
import gugga.debug.Assertion;
import gugga.logging.Logger;
import gugga.sequence.FictiveTask;
import gugga.sequence.MonitoringProgressiveTask;
import gugga.sequence.MonitoringTask;
import gugga.sequence.PreconditionsTask;
import gugga.sequence.ProgressiveTaskDecorator;
import gugga.utils.Listener;

[Event("initialize")]
[Event("initialized")]
[Event("initializationInterrupted")]
[Event("activate")]
[Event("activated")]
[Event("activationInterrupted")]
[Event("open")]
[Event("opened")]
[Event("openInterrupted")]
[Event("close")]
[Event("closed")]
[Event("closeInterrupted")]
[Event("destroy")]
[Event("destroyed")]
[Event("destructionInterrupted")]
class gugga.application.Section extends UIComponentEx implements ISection
{
	private var mInitializingTask : ITask;
	private var mActivatingTask : ITask;
	private var mOpeningTask : ITask;
	private var mClosingTask : ITask;
	private var mDestroyingTask : ITask;
	
	private var mInitializingTaskCompletedDelegate : Function;
	private var mActivatingTaskCompletedDelegate : Function;
	private var mOpeningTaskCompletedDelegate : Function;
	private var mClosingTaskCompletedDelegate : Function;
	private var mDestroyingTaskCompletedDelegate : Function;
	
	private var mCanClose : Boolean = false;

	private var mIsInitializing : Boolean = false;
	private var mIsActivating : Boolean = false;
	private var mIsOpening : Boolean = false;
	private var mIsClosing : Boolean = false;
	private var mIsDestroying : Boolean = false;
	
	private var mIsInitialized : Boolean = false;
	private var mIsOpened : Boolean = false;
	private var mIsClosed : Boolean = false;

	public function get CanClose():Boolean { return mCanClose; }
	public function get IsInitializing() : Boolean { return mIsInitializing; }
	public function get IsActivating() : Boolean { return mIsActivating; }
	public function get IsOpening() : Boolean { return mIsOpening; }
	public function get IsClosing() : Boolean { return mIsClosing; }
	public function get IsDestroying() : Boolean { return mIsDestroying; }
	
	public function get IsInitialed() : Boolean { return mIsInitialized; }
	public function get IsOpened() : Boolean { return mIsOpened; }
	public function get IsClosed() : Boolean { return mIsClosed; }
		
	public function Section()
	{
		//this.MinimizeWhenInvisible = true;
		this.MoveOutOfSceneWhenInvisible = true;
		this.hide();
		
		mInitializingTaskCompletedDelegate = Delegate.create(this, onInitialized);
		mActivatingTaskCompletedDelegate = Delegate.create(this, onActivated);
		mOpeningTaskCompletedDelegate = Delegate.create(this, onOpened);
		mClosingTaskCompletedDelegate = Delegate.create(this, onClosed);
		mDestroyingTaskCompletedDelegate = Delegate.create(this, onDestroyed);
	}
	
	private function registerInitializingTask(aTask:ITask)
	{
		mInitializingTask.removeEventListener("completed", mInitializingTaskCompletedDelegate);
		mInitializingTask = aTask;
		mInitializingTask.addEventListener("completed", mInitializingTaskCompletedDelegate);
	}

	private function registerActivatingTask(aTask:ITask)
	{
		mActivatingTask.removeEventListener("completed", mActivatingTaskCompletedDelegate);
		mActivatingTask = aTask;
		mActivatingTask.addEventListener("completed", mActivatingTaskCompletedDelegate);
		
	}

	private function registerOpeningTask(aTask:ITask)
	{
		mOpeningTask.removeEventListener("completed", mOpeningTaskCompletedDelegate);
		mOpeningTask = aTask;
		mOpeningTask.addEventListener("completed", mOpeningTaskCompletedDelegate);
	}
	
	private function registerClosingTask(aTask:ITask)
	{
		mClosingTask.removeEventListener("completed", mClosingTaskCompletedDelegate);
		mClosingTask = aTask;
		mClosingTask.addEventListener("completed", mClosingTaskCompletedDelegate);
	}

	private function registerDestroyingTask(aTask:ITask)
	{
		mDestroyingTask.removeEventListener("completed", mDestroyingTaskCompletedDelegate);
		mDestroyingTask = aTask;
		mDestroyingTask.addEventListener("completed", mDestroyingTaskCompletedDelegate);
	}
	
	public function getPreOpenProgressMonitoringTask() : IProgressiveTask
	{
		Logger.logInfo("Returns null, so no progress will be monitored.", this, arguments);
		return null;
	}
	
	private function getInitializationProgressMonitoringTask() : IProgressiveTask
	{
		if(!mIsInitialized)
		{
			if(mInitializingTask)
			{
				return getProgressMonitoringTask(mInitializingTask);
			}
			else
			{
				var sectionInitializedTask : PreconditionsTask = new PreconditionsTask();
				sectionInitializedTask.add(new EventDescriptor(this, "initialized"));
				
				var sectionInitializedProgressiveTask : IProgressiveTask = 
					new ProgressiveTaskDecorator(sectionInitializedTask);
				
				sectionInitializedTask.start();
				return sectionInitializedProgressiveTask;
			}
		}
		else
		{
			return new ProgressiveTaskDecorator(new FictiveTask());
		}
	}

	private function getActivationProgressMonitoringTask() : IProgressiveTask
	{
		if(mActivatingTask)
		{
			return getProgressMonitoringTask(mActivatingTask);
		}
		else
		{
			var sectionInitializedTask : PreconditionsTask = new PreconditionsTask();
			sectionInitializedTask.add(new EventDescriptor(this, "activated"));
			
			var sectionInitializedProgressiveTask : IProgressiveTask = 
				new ProgressiveTaskDecorator(sectionInitializedTask);
			
			sectionInitializedTask.start();
			return sectionInitializedProgressiveTask;
		}
	}
	
	private function getProgressMonitoringTask(aTask:ITask) : IProgressiveTask
	{
		if(aTask instanceof IProgressiveTask)
		{
			var monitoringProgressiveTask : MonitoringProgressiveTask = 
				new MonitoringProgressiveTask(IProgressiveTask(aTask)); 
				
			return monitoringProgressiveTask;
		}
		else
		{
			var monitoringTask : MonitoringTask = 
				new MonitoringTask(aTask); 
				
			var monitoringProgressiveTask : IProgressiveTask = 
				new ProgressiveTaskDecorator(monitoringTask);
				
			return monitoringProgressiveTask;
		}
	}
	
	public function initialize() : Void 
	{
		Assertion.warningIfTrue(
				mIsInitialized,
				"Section already initialized", this, arguments);
				
		mIsInitializing = true;
		dispatchEvent({type:"initialize", target:this});
		
		if(mInitializingTask)
		{
			mInitializingTask.start();
		}
		else
		{
			onInitialized();
		}
	}

	public function activate() : Void 
	{
		mIsActivating = true;
		dispatchEvent({type:"activate", target:this});
		
		if(mActivatingTask)
		{
			mActivatingTask.start();
		}
		else
		{
			onActivated();
		}
	}

	public function open() : Void 
	{
		mIsOpening = true;
		mIsOpened = false;
		dispatchEvent({type:"open", target:this});
		
		if(mOpeningTask)
		{
			mOpeningTask.start();
		}
		else
		{
			show();
			onOpened();
		}
	}

	public function close() : Void 
	{
		mIsClosing = true;
		mIsClosed = false;
		dispatchEvent({type:"close", target:this});
		
		if(mClosingTask)
		{
			mClosingTask.start();
		}
		else
		{
			hide();
			onClosed();
		}
	}

	public function destroy() : Void 
	{
		mIsDestroying = true;
		dispatchEvent({type:"destroy", target:this});

		if(mDestroyingTask)
		{
			mDestroyingTask.start();
		}
		else
		{
			onDestroyed();
		}
	}
	
	public function canInterruptInitialization() : Boolean 
	{
		return mInitializingTask.isRunning() && mInitializingTask.isImmediatelyInterruptable();
	}

	public function interruptInitialization() : Void 
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mInitializingTask, "interrupted"),
			Delegate.create(this, onInitializationInterrupted)
		);
		
		mInitializingTask.interrupt();
	}
	
	private function onInitializationInterrupted(ev) : Void
	{
		dispatchEvent({type: "initializationInterrupted", target: this});
	}	
	
	public function canInterruptActivation() : Boolean 
	{
		return mActivatingTask.isRunning() && mActivatingTask.isImmediatelyInterruptable();
	}

	public function interruptActivation() : Void 
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mActivatingTask, "interrupted"),
			Delegate.create(this, onActivationInterrupted)
		);
		
		mActivatingTask.interrupt();
	}
	
	private function onActivationInterrupted(ev) : Void
	{
		dispatchEvent({type: "activationInterrupted", target: this});
	}	
	
	public function canInterruptOpen() : Boolean 
	{
		return mOpeningTask.isRunning() && mOpeningTask.isImmediatelyInterruptable();
	}

	public function interruptOpen() : Void 
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mOpeningTask, "interrupted"),
			Delegate.create(this, onOpenInterrupted)
		);
		
		mOpeningTask.interrupt();
	}
	
	private function onOpenInterrupted(ev) : Void
	{
		dispatchEvent({type: "openInterrupted", target: this});
	}
	
	public function canInterruptClose() : Boolean 
	{
		return mClosingTask.isRunning() && mClosingTask.isImmediatelyInterruptable();
	}

	public function interruptClose() : Void 
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mClosingTask, "interrupted"),
			Delegate.create(this, onCloseInterrupted)
		);
		
		mClosingTask.interrupt();
	}
	
	private function onCloseInterrupted(ev) : Void
	{
		dispatchEvent({type: "closeInterrupted", target: this});
	}
	
	/*????*/public function canInterruptDestruction() : Boolean 
	{
		return mDestroyingTask.isRunning() && mDestroyingTask.isImmediatelyInterruptable();
	}

	/*????*/public function interruptDestruction() : Void 
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mDestroyingTask, "interrupted"),
			Delegate.create(this, onDestructionInterrupted)
		);
		
		mDestroyingTask.interrupt();
	}
	
	/*????*/private function onDestructionInterrupted(ev) : Void
	{
		dispatchEvent({type: "destructionInterrupted", target: this});
	}
	
	private function onInitialized(ev) : Void
	{
		mIsInitializing = false;
		mIsInitialized = true;
		
		dispatchEvent({type:"initialized", target:this});
	}
	
	private function onActivated(ev) : Void
	{
		mIsActivating = false;
		dispatchEvent({type:"activated", target:this});
	}
	
	private function onOpened(ev) : Void
	{
		mIsOpening = false;
		mIsOpened = true;
		mIsClosed = false;
		
		dispatchEvent({type:"opened", target:this});
	}
	
	private function onClosed(ev) : Void
	{
		mIsClosing = false;
		mIsClosed = true;
		mIsOpened = false;
		
		dispatchEvent({type:"closed", target:this});
	}
	
	private function onDestroyed(ev) : Void
	{
		mIsDestroying = false;
		dispatchEvent({type:"destroyed", target:this});
	}
	
}