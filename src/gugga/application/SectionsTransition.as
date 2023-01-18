import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.application.ISectionsController;
import gugga.application.Section;
import gugga.application.TransitionInfo;
import gugga.common.EventDescriptor;
import gugga.common.IProgressiveTask;
import gugga.common.ITask;
import gugga.components.ISectionLoader;
import gugga.components.SectionAttacher;
import gugga.components.SectionLoader;
import gugga.crypt.GUID;
import gugga.debug.Assertion;
import gugga.sequence.PreconditionsTask;
import gugga.sequence.ProgressMonitor;
import gugga.utils.DoLaterUtil;
import gugga.utils.Listener;
import gugga.utils.Locker;

[Event("lazyTargetSectionAvailable")]
[Event("lazyTargetSectionUIInitialized")]
[Event("lazyTargetSectionInitialized")]

[Event("targetSectionActivate")]
[Event("targetSectionOpen")]

[Event("currentSectionDestroyed")]
[Event("currentSectionClose")]
[Event("currentSectionDestroy")]

[Event("setNavigationLock")]
[Event("clearNavigationLock")]

[Event("disposed")]

/**
 * @author Todor Kolev
 */
class gugga.application.SectionsTransition 
	extends EventDispatcher 
	implements ITask 
{
	private var mOpenTargetSectionPreconditions : PreconditionsTask;
	private var mDisposePreconditions : PreconditionsTask;
	
	private var mDoLoadTargetSection : Boolean;
	private var mDetachCurrentSectionAfterClose : Boolean;
	private var mSectionPathRest : String;
	
	private var mNavigationLock : Locker;
	
	private var mIsRunning : Boolean = false;
	
	private var mRuntimeNavigationLockID : String;
	private var mSetRuntimeNavigationLock : Boolean = false;
	public function get SetRuntimeNavigationLock() : Boolean { return mSetRuntimeNavigationLock; }
	public function set SetRuntimeNavigationLock(aValue:Boolean) : Void { mSetRuntimeNavigationLock = aValue; }
	
	private var mPreOpenProgressMonitor : ProgressMonitor;
	public function get PreOpenProgressMonitor() : ProgressMonitor { return mPreOpenProgressMonitor; }
	
	private var mSectionsController : ISectionsController;
	public function get SectionsController() : ISectionsController { return mSectionsController; }
	
	private var mCurrentSection : Section;
	public function get CurrentSection() : Section { return mCurrentSection; }
	
	private var mTargetSection : Section;
	public function get TargetSection() : Section { return mTargetSection; }
	
	private var mTargetSectionLoader : ISectionLoader;
	public function get TargetSectionLoader() : ISectionLoader { return mTargetSectionLoader; }
	
	/*
	public function SectionsTransition(aSectionsController:ISectionsController, 
		aCurrentSection:ISection, aDetachCurrentSectionAfterClose:Boolean,
		aTargetSection:ISection, aTargetSectionLoader:ISectionLoader, aDoLoadTargetSection:Boolean,
		aSectionPathRest:String) 
	{
		mSectionsController = aSectionsController;
		mCurrentSection = aCurrentSection;
		mDetachCurrentSectionAfterClose = aDetachCurrentSectionAfterClose;
		mTargetSection = aTargetSection;
		mTargetSectionLoader = aTargetSectionLoader;
		mDoLoadTargetSection = aDoLoadTargetSection;
		mSectionPathRest = aSectionPathRest;
	}
	 * 
	 */
	
	public function SectionsTransition(aTransitionInfo:TransitionInfo) 
	{
		mSectionsController = aTransitionInfo.SectionsController;
		mCurrentSection = aTransitionInfo.CurrentSection;
		mDetachCurrentSectionAfterClose = aTransitionInfo.DetachCurrentSectionAfterClose;
		mTargetSection = aTransitionInfo.TargetSection;
		mTargetSectionLoader = aTransitionInfo.TargetSectionLoader;
		mDoLoadTargetSection = aTransitionInfo.DoLoadTargetSection;
		mSectionPathRest = aTransitionInfo.SectionPathRest;
		
		mNavigationLock = new Locker();
		
		mPreOpenProgressMonitor = new ProgressMonitor();
		mOpenTargetSectionPreconditions = new PreconditionsTask();
		
		mDisposePreconditions = new PreconditionsTask();
		mDisposePreconditions.add(new EventDescriptor(this, "readyToDispose"));
		
		Listener.createSingleTimeListener(
			new EventDescriptor(mDisposePreconditions, "completed"),
			Delegate.create(this, onDisposePreconditionsMet)
		);
		
		mOpenTargetSectionPreconditions.add(new EventDescriptor(mPreOpenProgressMonitor, "completed"));
		
		Listener.createSingleTimeListener(
			new EventDescriptor(mOpenTargetSectionPreconditions, "completed"),
			Delegate.create(this, onOpenTargetSectionPreconditionsMet)
		);
	}
	 
	public function start() : Void 
	{
		if(mSetRuntimeNavigationLock)
		{
			DoLaterUtil.doLater(this, setRuntimeNavigationLockLater, null, 1);
		}
		
		mIsRunning = true;
		
		if(mCurrentSection)
		{
			mOpenTargetSectionPreconditions.add(new EventDescriptor(mCurrentSection, "closed"));
			
			Listener.createSingleTimeListener(
				new EventDescriptor(mCurrentSection, "closed"), 
				Delegate.create(this, onCurrentSectionClosed)
			);
			
			triggerCurrentSectionClose();
		}
	
		//----------------------------------------------------	
		
		if(mDoLoadTargetSection)
		{
			Listener.createSingleTimeListener(
				new EventDescriptor(mTargetSectionLoader, "sectionAvailable"), 
				Delegate.create(this, onLazyTargetSectionAvailable)
			);

			Listener.createSingleTimeListener(
				new EventDescriptor(mTargetSectionLoader, "sectionUIInitialized"), 
				Delegate.create(this, onLazyTargetSectionUIInitialized)
			);

			Listener.createSingleTimeListener(
				new EventDescriptor(mTargetSectionLoader, "sectionInitialized"), 
				Delegate.create(this, onLazyTargetSectionInitialized)
			);
			
			if(mTargetSectionLoader instanceof SectionLoader)
			{
				openLazyLoadSection();
			}
			else if(mTargetSectionLoader instanceof SectionAttacher)
			{
				openLazyAttachSection();
			}
		}
		else
		{
			openInitializedSection();
		}
	}
	
	private function setRuntimeNavigationLockLater()
	{
		mRuntimeNavigationLockID = GUID.create();
		dispatchSetNavigationLock(mRuntimeNavigationLockID);
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}

	public function canInterrupt() : Boolean 
	{
		return isImmediatelyInterruptable();
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		return 
		!mNavigationLock.isLocked() &&
		(!mCurrentSection.IsClosing || (mCurrentSection.IsClosing && mCurrentSection.canInterruptClose())) &&
		/*????*/(!mCurrentSection.IsDestroying || (mCurrentSection.IsDestroying && mCurrentSection.canInterruptDestruction())) && 
		(!mTargetSection.IsInitializing || (mTargetSection.IsInitializing && mTargetSection.canInterruptInitialization())) &&
		(!mTargetSection.IsActivating || (mTargetSection.IsActivating && mTargetSection.canInterruptActivation())) &&
		(!mTargetSection.IsOpening || (mTargetSection.IsOpening && mTargetSection.canInterruptOpen()));
	}

	public function interrupt() : Void 
	{
		var interuptedPreconditions : PreconditionsTask = new PreconditionsTask();
		var newCurrentSection : Section;
		
		if(mCurrentSection.IsClosing)
		{
			if(mCurrentSection.canInterruptClose())
			{
				newCurrentSection = mCurrentSection;
				
				interuptedPreconditions.add(new EventDescriptor(mCurrentSection, "closeInterrupted"));
				mCurrentSection.interruptClose();
			}
			else
			{
				Assertion.warning("Can not interrupt current section close", this, arguments);
			}
		}
		
		if(mCurrentSection.IsDestroying)
		{
			if(mCurrentSection.canInterruptDestruction())
			{
				newCurrentSection = mCurrentSection;
				
				interuptedPreconditions.add(new EventDescriptor(mCurrentSection, "destructionInterrupted"));
				mCurrentSection.interruptDestruction();
			}
			else
			{
				Assertion.warning("Can not interrupt current section destruction", this, arguments);
			}
		}
		
		if(mTargetSection.IsInitializing)
		{
			if(mTargetSection.canInterruptInitialization())
			{
				newCurrentSection = mCurrentSection;
				
				interuptedPreconditions.add(new EventDescriptor(mCurrentSection, "initializationInterrupted"));
				mTargetSection.interruptInitialization();
			}
			else
			{
				Assertion.warning("Can not interrupt target section initialization", this, arguments);
			}
		}
		
		if(mTargetSection.IsActivating)
		{
			if(mTargetSection.canInterruptActivation())
			{
				newCurrentSection = mTargetSection;
				
				interuptedPreconditions.add(new EventDescriptor(mTargetSection, "activationInterrupted"));
				mTargetSection.interruptActivation();
			}
			else
			{
				Assertion.warning("Can not interrupt target section activation", this, arguments);
			}
		}
		
		if(mTargetSection.IsOpening)
		{
			if(mTargetSection.canInterruptOpen())
			{
				newCurrentSection = mTargetSection;
				
				interuptedPreconditions.add(new EventDescriptor(mTargetSection, "openInterrupted"));
				mTargetSection.interruptOpen();
			}
			else
			{
				Assertion.warning("Can not interrupt target section open", this, arguments);
			}
		}
		
		Listener.createSingleTimeMergingListener(
			new EventDescriptor(interuptedPreconditions, "completed"), 
			Delegate.create(this, onInterrupted),
			{newCurrentSection: newCurrentSection}
		);
		
		interuptedPreconditions.start();
	}
	
	private function onInterrupted(ev) : Void 
	{
		dispatchEvent({type: "interrupted", target: this, newCurrentSection: ev.newCurrentSection});
		dispatchClearRuntimeNavigationLock();
		
		//dispose
		dispatchEvent({type: "readyToDispose", target: this, newCurrentSection: mTargetSection});
	}
	
	private function triggerTargetSectionActivate() : Void
	{
		dispatchEvent({type: "targetSectionActivate", target: this}); 
		mTargetSection.activate();
	}

	private function triggerTargetSectionOpen() : Void
	{
		dispatchEvent({type: "targetSectionOpen", target: this});
		mTargetSection.open();
	}

	private function triggerCurrentSectionClose() : Void
	{
		dispatchEvent({type: "currentSectionClose", target: this});
		mCurrentSection.close();
	}

	private function triggerCurrentSectionDestroy() : Void
	{
		dispatchEvent({type: "currentSectionDestroy", target: this});
		mCurrentSection.destroy();
	}
	
	private function triggerSectionsControllerOpenSection(aSectionsController : ISectionsController, 
		aSectionPath : String) : SectionsTransition
	{
		var childSectionsTransition : SectionsTransition = aSectionsController.openSection(aSectionPath);
		return childSectionsTransition;
	}	
	
	
	private function openLazyLoadSection() : Void
	{
		var targetSectionLoader : SectionLoader = SectionLoader(mTargetSectionLoader);
		mPreOpenProgressMonitor.addItem(targetSectionLoader);
		
		mTargetSectionLoader.start();
	}

	private function openLazyAttachSection() : Void
	{
		mTargetSectionLoader.start();
	}
	
	private function openInitializedSection() : Void
	{
		getAndMonitorTargetSectionPreOpenProgress();
		triggerTargetSectionActivate();
		
		openAndMonitorTargetSubSection();
		
		startMonitoringPreOpenProgress();
		startMonitoringOpenTargetSectionPreconditions();
	}
	
	private function onLazyTargetSectionAvailable(ev) : Void 
	{
		mTargetSection = ev.section;
		dispatchEvent({type: "lazyTargetSectionAvailable", target: this, section: ev.section});
	}

	private function onLazyTargetSectionUIInitialized(ev) : Void 
	{
		dispatchEvent({type: "lazyTargetSectionUIInitialized", target: this, section: ev.section});
		
		getAndMonitorTargetSectionPreOpenProgress();
		startMonitoringPreOpenProgress();
	}

	private function onLazyTargetSectionInitialized(ev) : Void 
	{
		dispatchEvent({type: "lazyTargetSectionInitialized", target: this, section: ev.section});
		triggerTargetSectionActivate();

		openAndMonitorTargetSubSection();
		startMonitoringOpenTargetSectionPreconditions();
	}
	
	private function startMonitoringOpenTargetSectionPreconditions() : Void
	{
		mOpenTargetSectionPreconditions.start();
	}

	private function startMonitoringPreOpenProgress() : Void
	{
		mPreOpenProgressMonitor.start();
	}

	private function getAndMonitorTargetSectionPreOpenProgress() : Void
	{
		var sectionPreOpenProgressMonitoringTask : IProgressiveTask = mTargetSection.getPreOpenProgressMonitoringTask();
		
		if(sectionPreOpenProgressMonitoringTask)
		{	
			monitorTargetSectionPreOpenProgress(sectionPreOpenProgressMonitoringTask);
		}
	}
	
	private function monitorTargetSectionPreOpenProgress(aSectionPreOpenProgressMonitoringTask : IProgressiveTask) : Void
	{
		mPreOpenProgressMonitor.addItem(aSectionPreOpenProgressMonitoringTask);
	}
	
	private function openAndMonitorTargetSubSection() : Void
	{		
		if((mTargetSection instanceof ISectionsController) && (mSectionPathRest != "" && mSectionPathRest != null && mSectionPathRest != undefined))
		{
			var childSectionsTransition : SectionsTransition = 
				triggerSectionsControllerOpenSection(ISectionsController(mTargetSection), mSectionPathRest);
			
			if(childSectionsTransition)
			{
				monitorSubTransition(childSectionsTransition);
				mDisposePreconditions.add(new EventDescriptor(childSectionsTransition, "disposed"));
			}
		}	
		
		mDisposePreconditions.start();
	}

	private function monitorSubTransition(aSubTransition:SectionsTransition) : Void
	{		
		aSubTransition.addEventListener("setNavigationLock", Delegate.create(this, onSubTransitionSetNavigationLock));
		aSubTransition.addEventListener("clearNavigationLock", Delegate.create(this, onSubTransitionClearNavigationLock));
		
		monitorSubTransitionPreOpenProgress(aSubTransition.PreOpenProgressMonitor);
	}
	
	private function monitorSubTransitionPreOpenProgress(aChildSectionsPreOpenMonitor:IProgressiveTask) : Void
	{		
		mPreOpenProgressMonitor.addItem(aChildSectionsPreOpenMonitor);
	}
	
	public function addOpenTargetSectionPrecondition(aEventDescriptor:EventDescriptor) : Void
	{
		mOpenTargetSectionPreconditions.add(aEventDescriptor);
	}
	
	private function onOpenTargetSectionPreconditionsMet(ev) : Void
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mTargetSection, "opened"), 
			Delegate.create(this, onTargetSectionOpened)
		);
		
		triggerTargetSectionOpen();
	}
	
	private function onCurrentSectionClosed(ev) : Void
	{
		if(mDetachCurrentSectionAfterClose)
		{
			Listener.createSingleTimeMergingListener(
				new EventDescriptor(mCurrentSection, "destroyed"),
				Delegate.create(this, onCurrentSectionDestroyed)
			);
			
			triggerCurrentSectionDestroy();
		}
	}
	
	private function onCurrentSectionDestroyed(ev) : Void
	{
		dispatchEvent({type: "currentSectionDestroyed", target: this});
	}
	
	private function onTargetSectionOpened(ev) : Void
	{
		completed();
	}
	
	private function onSubTransitionSetNavigationLock(ev) : Void 
	{
		dispatchSetNavigationLock(ev.lockID);	
	}

	private function onSubTransitionClearNavigationLock(ev) : Void 
	{
		dispatchClearNavigationLock(ev.lockID);
	}
	
	public function dispatchSetNavigationLock(aLockID:String) : Void
	{
		mNavigationLock.setLock(aLockID);
		dispatchEvent({type: "setNavigationLock", target: this, lockID: aLockID});
	}
	
	public function dispatchClearNavigationLock(aLockID:String) : Void
	{
		mNavigationLock.clearLock(aLockID);
		dispatchEvent({type: "clearNavigationLock", target: this, lockID: aLockID});
	}
	
	private function completed() : Void
	{
		mIsRunning = false;
		dispatchEvent({type: "completed", target: this, newCurrentSection: mTargetSection});
	
		dispatchClearRuntimeNavigationLock();
	
		//dispose
		dispatchEvent({type: "readyToDispose", target: this, newCurrentSection: mTargetSection});
	}

	private function dispatchClearRuntimeNavigationLock() : Void
	{
		if(mRuntimeNavigationLockID)
		{
			dispatchClearNavigationLock(mRuntimeNavigationLockID);
		}
	}

	private function onDisposePreconditionsMet() : Void 
	{
		//finish current frame's code and dispose
		DoLaterUtil.doLater(this, dispose, null, 1);
	}
	
	private function dispose() : Void
	{
		dispatchEvent({type: "disposed", target: this, newCurrentSection: mTargetSection});
		removeAllEventListeners();
	}

}