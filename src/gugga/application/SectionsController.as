import mx.utils.Delegate;

import gugga.application.ISectionsController;
import gugga.application.Section;
import gugga.application.SectionsTransition;
import gugga.application.TransitionInfo;
import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.components.ISectionLoader;
import gugga.components.SectionAttacher;
import gugga.components.SectionLoader;
import gugga.debug.Assertion;
import gugga.logging.Logger;
import gugga.navigation.INavigation;
import gugga.sequence.ExecuteAsyncMethodTask;
import gugga.sequence.ExecuteMethodTask;
import gugga.sequence.FictiveTask;
import gugga.sequence.TaskManager;
import gugga.utils.DebugUtils;
import gugga.utils.Listener;
import gugga.utils.Locker;

class gugga.application.SectionsController extends Section implements ISectionsController
{
	private var mSections : HashTable;
	private var mMenuItemToSectionID : HashTable;
	
	private var mSectionNavigation : INavigation;

	private var mMouseEventsLocker : Locker;
	private var mNavigationLocker : Locker;

	private var mLazySectionLoaders : HashTable;
	private var mDetachAfterCloseSections : HashTable;

	private var mTransition : SectionsTransition;
	
	private var mCurrentSection : Section;
	public function get CurrentSection() : Section { return mCurrentSection; }
	
	private var mCurrentSectionID : String;
	public function get CurrentSectionID() : String { return mCurrentSectionID; }
	
	private var mTargetSectionID : String;
	
	private var mIsTransitingSections : Boolean = false;
	public function get IsTransitingSections() : Boolean { return mIsTransitingSections; }
	public /*protected*/ function set IsTransitingSections(aValue:Boolean) : Void { mIsTransitingSections = aValue; }

	/**
	 * section transitions should be revised to make mDisableNavigationWhenTransiting false by default
	 * posible dangerous behaviour if changing section in the middle of the transition
	 */
	private var mDisableNavigationWhenTransiting : Boolean = true;
	public function get DisableNavigationWhenTransiting() : Boolean { return mDisableNavigationWhenTransiting; }
	public function set DisableNavigationWhenTransiting(aValue:Boolean) : Void { mDisableNavigationWhenTransiting = aValue; }

	private var mSectionSwfsLoadingPart : Number = 70;
	public function get SectionSwfsLoadingPart() : Number { return mSectionSwfsLoadingPart; }
	public function set SectionSwfsLoadingPart(aValue:Number) : Void { mSectionSwfsLoadingPart = aValue; }

	function SectionsController()
	{
		mSections = new HashTable();
		mMenuItemToSectionID = new HashTable();
		mMouseEventsLocker = new Locker();
		mNavigationLocker = new Locker();
		
		mLazySectionLoaders = new HashTable();
		mDetachAfterCloseSections = new HashTable();
	}
	
	private function initUI() : Void
	{
		super.initUI();
		
		createSectionInitializationSequence();
	}
	
	private var mSectionsInitializationStartTask : FictiveTask;
	private var mSectionsInitializationEndTask : FictiveTask;
	private var mSectionsControllerInitializingSequence : TaskManager;
	//private var mSubSectionsInitializationSequence : TaskSequence;
	
	private function createSectionInitializationSequence() : Void
	{
		var initializingSequence : TaskManager = new TaskManager();
		mSectionsInitializationStartTask = new FictiveTask();
		mSectionsInitializationEndTask = new FictiveTask();
		
		initializingSequence.addStartingTasks([mSectionsInitializationStartTask]);
		
		var initializeNavigationTask : ExecuteMethodTask = ExecuteMethodTask.create(this, initializeNavigation);
		initializingSequence.addTaskWithPredecessor(initializeNavigationTask, mSectionsInitializationStartTask);
		
		initializingSequence.addTaskWithPredecessor(mSectionsInitializationEndTask, initializeNavigationTask);
		initializingSequence.setFinalTask(mSectionsInitializationEndTask);
		
		//sub sections initialization
		//mSubSectionsInitializationSequence = new TaskSequence();
		
		//initializingSequence.addTaskWithPredecessor(mSubSectionsInitializationSequence, mSectionsInitializationStartTask);
		//initializingSequence.addTaskPredecessor(mSectionsInitializationEndTask, mSubSectionsInitializationSequence);
		
		//register
		mSectionsControllerInitializingSequence = initializingSequence;
		registerInitializingTask(initializingSequence);
	}
	
	private function initializeNavigation()
	{
		if(mSectionNavigation)
		{
			mSectionNavigation.addEventListener("navigate", Delegate.create(this, onSectionNavigationNavigate));
			mSectionNavigation.start();
		}
	}
	
	public function registerMenuItemToSectionIDMapping(aMenuItemID:String, aSectionID:String)
	{
		Assertion.failIfEmpty(aMenuItemID, "aMenuItemID is empty", this, arguments); 
		Assertion.failIfNull(aSectionID, "aSectionID is null", this, arguments);

		mMenuItemToSectionID[aMenuItemID] = aSectionID;
	}
	
	public function registerSection(aSectionInstance:Section, aID:String, aMenuItemID:String)
	{
		Assertion.failIfEmpty(aID, "aID is empty", this, arguments);			
		Assertion.failIfNotNull(mSections[aID], "mSections[" + aID + "] already exists", this, arguments);	
		Assertion.failIfNull(aSectionInstance, "aSectionInstance is null", this, arguments);				
				
		mSections[aID] = aSectionInstance;
		
		var initializeSectionTask : ExecuteAsyncMethodTask = ExecuteAsyncMethodTask.createBasic(
			"initialized", aSectionInstance, aSectionInstance.initialize);
			
		//mSubSectionsInitializationSequence.addTask(initializeSectionTask);
		mSectionsControllerInitializingSequence.addTaskWithPredecessor(initializeSectionTask, mSectionsInitializationStartTask);
		mSectionsControllerInitializingSequence.addTaskPredecessor(mSectionsInitializationEndTask, initializeSectionTask);
		
		if(aMenuItemID != "" && aMenuItemID != null && aMenuItemID != undefined)
		{
			Assertion.failIfNotNull(mMenuItemToSectionID[aMenuItemID], "mMenuItemToSectionID[" + aMenuItemID + "] already exists", this, arguments);
			
			mMenuItemToSectionID[aMenuItemID] = aID;
		}
	}
	
	public function registerChildSection(aSectionInstanceName:String, aID:String, aMenuItemID:String)
	{
		registerSection(this[aSectionInstanceName], aID, aMenuItemID);
		return this[aSectionInstanceName];
	}
	
	public function registerLazyLoadSection(aSectionLoader:SectionLoader, aSectionSwfPath:String, aID:String, aMenuItemID:String, aDetachAfterClose:Boolean)
	{
		Assertion.failIfEmpty(aSectionSwfPath, "aSectionSwfPath is empty", this, arguments);				
		
		aSectionLoader.ContentPath = aSectionSwfPath;
		registerLazySection(aSectionLoader, aID, aMenuItemID, aDetachAfterClose);
	}
	
	public function registerLazyAttachSection(aSectionAttacher:SectionAttacher, aSectionLinkage:String, aID:String, aMenuItemID:String, aDetachAfterClose:Boolean)
	{
		Assertion.failIfEmpty(aSectionLinkage, "aSectionLinkage is empty", this, arguments);
		
		aSectionAttacher.SectionLinkage = aSectionLinkage;
		registerLazySection(aSectionAttacher, aID, aMenuItemID, aDetachAfterClose);
	}
	
	public function registerLazySection(aSectionLoader:ISectionLoader, aID:String, aMenuItemID:String, aDetachAfterClose:Boolean)
	{
		Assertion.failIfEmpty(aID, "aID is empty", this, arguments);			
		Assertion.failIfNotNull(mSections[aID], "mSections[" + aID + "] is already exists", this, arguments);	
		
		mLazySectionLoaders[aID] = aSectionLoader;
		mDetachAfterCloseSections[aID] = aDetachAfterClose;
		
		if(aMenuItemID != "" && aMenuItemID != null && aMenuItemID != undefined)
		{
			Assertion.failIfNotNull(mMenuItemToSectionID[aMenuItemID], "mMenuItemToSectionID[" + aMenuItemID + "] is already exists", this, arguments);
			
			mMenuItemToSectionID[aMenuItemID] = aID;
		}
	}
	
	public function setNavigationInstance(aNavigation:INavigation)
	{
		Assertion.failIfNull(aNavigation, "aNavigation is null", this, arguments);
		
		mSectionNavigation = aNavigation;
	}

	public function navigate(aMenuItemID:String, aAdditionalData)//overridable
	{
		var sectionID:String = mMenuItemToSectionID[aMenuItemID];
		if(sectionID)
		{
			openSection(sectionID);
		}
	}

	public function markNavigation(aSectionID:String) : Void
	{
		var menuID : String = getMenuItemIDForSection(aSectionID);
		mSectionNavigation.setSelectedItemID(menuID);
	} 
	
	public function getMenuItemIDForSection(aSectionID:String) : String
	{
		Assertion.failIfEmpty(aSectionID, "aSectionID is empty", this, arguments);

		for (var key : String in mMenuItemToSectionID)
		{
			if(mMenuItemToSectionID[key] == aSectionID)
			{
				return key;
			}
		}
	}
		
	private function isSectionIDRegistered(aSectionID:String) : Boolean
	{
		if(mSections.containsKey(aSectionID))
		{
			return true;
		}
		else if(mLazySectionLoaders.containsKey(aSectionID))
		{
			return true;
		}
		else
		{
			return false;
		}
	}		
		
	private function isLazySection(aSectionID:String) : Boolean
	{
		return mLazySectionLoaders.containsKey(aSectionID);
	}
	
	private function isDetachAfterCloseSection(aSectionID:String) : Boolean
	{
		if(mDetachAfterCloseSections.containsKey(aSectionID))
		{
			return mDetachAfterCloseSections[aSectionID];
		}
		else
		{
			return false;
		}
	}
	
	private function needLazyLoad(aSectionID:String) : Boolean
	{
		if(mSections.containsKey(aSectionID))
		{
			return false;
		}
		else if(mLazySectionLoaders.containsKey(aSectionID))
		{
			return true;
		}
		else
		{
			Assertion.fail("Invalid section ID", this, arguments);
		}
	}
	
	private function getTransitionInfo(aSectionID:String, aSectionPathRest:String) : TransitionInfo
	{
		var transitionInfo : TransitionInfo = new TransitionInfo();
		
		transitionInfo.SectionsController = this;
		
		transitionInfo.CurrentSection = mCurrentSection;
		transitionInfo.TargetSection = mSections[aSectionID];
		
		if(isLazySection(aSectionID))
		{
			transitionInfo.TargetSectionLoader = mLazySectionLoaders[aSectionID];
			transitionInfo.DoLoadTargetSection = needLazyLoad(aSectionID);
		}
		
		transitionInfo.DetachCurrentSectionAfterClose = isDetachAfterCloseSection(aSectionID);
		transitionInfo.SectionPathRest = aSectionPathRest;
		
		return transitionInfo; 
	}	
	
	private function getTransition(aSectionID:String, aSectionPathRest:String) : SectionsTransition
	{
		var transitionInfo : TransitionInfo = getTransitionInfo(aSectionID, aSectionPathRest);
	
		var transition : SectionsTransition = new SectionsTransition(transitionInfo);		
		return transition;
	}
	
	private function startTransition(aTransition:SectionsTransition) : Void
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(aTransition, "lazyTargetSectionInitialized"), 
			Delegate.create(this, onLazyTargetSectionInitialized)
		);
		
		Listener.createSingleTimeListener(
			new EventDescriptor(aTransition, "completed"), 
			Delegate.create(this, onTransitionCompleted)
		);
		
		Listener.createSingleTimeListener(
			new EventDescriptor(aTransition, "disposed"), 
			Delegate.create(this, onTransitionDisposed)
		);
		
		aTransition.addEventListener("setNavigationLock", Delegate.create(this, onTransitionSetNavigationLock));
		aTransition.addEventListener("clearNavigationLock", Delegate.create(this, onTransitionClearNavigationLock));
		
		aTransition.start();
	}
	
	//TODO: this method is too long, should be separeted in smaller ones 
	public function openSection(aSectionPath:String) : SectionsTransition
	{
		Assertion.failIfEmpty(aSectionPath, "Argument aPath is empty", this, arguments);
	
		var pathArray:Array = aSectionPath.split(".");
		var sectionID:String = pathArray[0];
		var sectionPathRest:String = ""; 
		
		Assertion.failIfReturnsFalse(
			this, isSectionIDRegistered, [sectionID], 
			"Section ID '" + sectionID + "' is not registered", this, arguments);
		
		if(pathArray.length > 1)
		{
			var sectionPathRestArray:Array = pathArray.slice(1);
			sectionPathRest = sectionPathRestArray.join(".");
		}
	
		if(mCurrentSectionID == sectionID)
		{
			var currentSection : Section = Section(mSections[mCurrentSectionID]);
			
			if((currentSection instanceof ISectionsController) && 
				(sectionPathRest != "" && sectionPathRest != null && sectionPathRest != undefined))
			{
				var openChildSectionsTask : SectionsTransition = 
					ISectionsController(currentSection).openSection(sectionPathRest);
				
				return openChildSectionsTask;
			}			
			else
			{
				return null;
			}
		}
	
		if (!mNavigationEnabled)
		{
			Logger.logInfo("Section '" + sectionID + "' will not be opened. Navigation is disabled.", this);
			return null;
		}
		
		if(mTransition && mTransition.isRunning())
		{
			if(mTransition.isImmediatelyInterruptable())
			{
				interruptCurrentTransition();
			}
			else
			{
				Logger.logInfo("Section '" + sectionID + "' will not be opened. Current transition can not be interupted.", this);
				return null;
			}
		}
		
		//-------------- actual section opening
		
		mIsTransitingSections = true;
		
		if(mDisableNavigationWhenTransiting)
		{
			setNavigationLock("DisableNavigationWhenTransitingLock_" + this);
		}
		
		mTargetSectionID = sectionID;
		
		mTransition = getTransition(sectionID, sectionPathRest);
		
		if(mTransition)
		{
			startTransition(mTransition);
			markNavigation(sectionID);
		}
		
		return mTransition;
	}
		
	private function interruptCurrentTransition() : Void
	{
		Listener.createSingleTimeListener(
			new EventDescriptor(mTransition, "interrupted"), 
			Delegate.create(this, onTransitionInterrupted)
		);
		
		mTransition.interrupt();
	}
	
	private function onTransitionCompleted(ev) : Void 
	{
		mCurrentSectionID = mTargetSectionID; 
		mCurrentSection = ev.newCurrentSection;
		mTargetSectionID = null;
		
		mIsTransitingSections = false;
		clearNavigationLock("DisableNavigationWhenTransitingLock_" + this);
	}
	
	private function onTransitionDisposed() : Void 
	{
		delete mTransition;
	}

	private function onTransitionInterrupted(ev) : Void 
	{
		mCurrentSection = ev.newCurrentSection;
		mCurrentSectionID = getSectionID(mCurrentSection); 
		mTargetSectionID = null;
				
		mIsTransitingSections = false;
		clearNavigationLock("DisableNavigationWhenTransitingLock_" + this);
	}
	
	private function onLazyTargetSectionInitialized(ev) : Void 
	{
		var section : Section = ev.section;
		
		mSections[mTargetSectionID] = section;
	}
	
	private function onCurrentSectionDestroyed(ev) : Void
	{
		var sectionID : String = ev.sectionID;
		var section : Section = mSections[sectionID];
		
		if(mLazySectionLoaders.containsKey(sectionID))
		{
			var sectionLoader : ISectionLoader = mLazySectionLoaders[sectionID];
			sectionLoader.unloadData();
		}
		
		mSections[sectionID] = null;
	}
		
	private function onSectionNavigationNavigate(ev) : Void
	{
		Assertion.failIfEmpty(ev.id, "ev.id is empty", this, arguments);
		
		navigate(ev.id, ev.additionalData);
	}
	
	private var mNavigationEnabled : Boolean = true;
	public function enableNavigation() : Void
	{ 
		if(mNavigationEnabled == false)
		{
			mNavigationLocker.clearAllLocks();
			mNavigationEnabled = true;
			mSectionNavigation.enable();
		}
	}

	public function disableNavigation() : Void
	{
		if(mNavigationEnabled == true)
		{
			mNavigationEnabled = false;
			mSectionNavigation.disable();
		}
	}
	
	private function getSectionID(aSection:Section) : String
	{
		for(var key:String in mSections)
		{
			if(mSections[key] == aSection)
			{
				return key;
			}
		}
		
		Assertion.warning(aSection + " not found", this, arguments);
	}
	
	public function enableBoundingBoxMouseEvents() : Void
	{
		mMouseEventsLocker.clearAllLocks();
		super.enableBoundingBoxMouseEvents();
	}
	
	public function setMouseEventsLock(aLockID:String) : String
	{
		disableBoundingBoxMouseEvents();
		return mMouseEventsLocker.setLock(aLockID);
	}
	
	public function clearMouseEventsLock(aLockID:String) : Void
	{
		mMouseEventsLocker.clearLock(aLockID);
		
		if(!mMouseEventsLocker.isLocked())
		{
			super.enableBoundingBoxMouseEvents();
		}
	}	
	
	public function setNavigationLock(aLockID:String) : String
	{
		disableNavigation();
		return mNavigationLocker.setLock(aLockID);
	}
	
	public function clearNavigationLock(aLockID:String) : Void
	{
		mNavigationLocker.clearLock(aLockID);
		
		if(!mNavigationLocker.isLocked())
		{
			enableNavigation();
		}
	}

	private function onTransitionSetNavigationLock(ev) : Void 
	{
		var lockID : String = ev.lockID;
		Assertion.warningIfEmpty(lockID);
		
		setNavigationLock(lockID);	
	}

	private function onTransitionClearNavigationLock(ev) : Void 
	{
		var lockID : String = ev.lockID;
		Assertion.warningIfEmpty(lockID);
		
		clearNavigationLock(lockID);
	}
}