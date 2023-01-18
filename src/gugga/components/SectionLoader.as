/**
 * @author Todor Kolev
 */

import mx.utils.Delegate;

import gugga.application.Section;
import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.components.ImageLoader;
import gugga.components.ISectionLoader;
import gugga.utils.Listener;


class gugga.components.SectionLoader 
	extends ImageLoader
	implements ISectionLoader 
{
	private var mSection : gugga.application.Section;
	public function get Section() : gugga.application.Section { return mSection; }
	
	private var mSectionInstanceName : String = "Section";
	public function get SectionInstanceName() : String { return mSectionInstanceName; }
	public function set SectionInstanceName(aValue:String) : Void { mSectionInstanceName = aValue; }

	private var mAutoInitializeSection : Boolean = true;
	public function get AutoInitializeSection() : Boolean { return mAutoInitializeSection; }
	public function set AutoInitializeSection(aValue:Boolean) : Void { mAutoInitializeSection = aValue; }

	//private var mIsRunning : Boolean = false;
	private var mIsInitializingSection : Boolean = false;
	//private var mIsInterrupting : Boolean = false;

	private var mUIInitializedListener : Listener;
	private var mInitializedListener : Listener;

	private function onLoadInit()
	{
		mSection = getComponentByPath(["contentHolder", mSectionInstanceName]);
		
		mUIInitializedListener = Listener.createSingleTimeMergingListener(
			new EventDescriptor(mSection, "uiInitialized"),
			Delegate.create(this, onSectionUIInitialized)
		);
		
		dispatchEvent({type: "sectionAvailable", target: this, section: mSection});
				
		super.onLoadInit();
	}

	private function onSectionUIInitialized()
	{
		dispatchEvent({type: "sectionUIInitialized", target:this, section: mSection});
			
		if(mAutoInitializeSection)
		{
			mInitializedListener = Listener.createSingleTimeMergingListener(
				new EventDescriptor(mSection, "initialized"),
				Delegate.create(this, onSectionInitialized)
			);
				
			mIsInitializingSection = true;
			mSection.initialize();
		}
	}
	
	private function onSectionInitialized(ev)
	{
		mIsInitializingSection = false;
		mIsRunning = false;
		
		dispatchEvent({type: "sectionInitialized", target:this, section: mSection});
		
		if(mIsInterrupting)
		{
			dispatchEvent({type: "interrupted", target:this});
		}
		else
		{
			dispatchEvent({type: "completed", target:this});
		}				
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		if(mIsInitializingSection)
		{
			return false && super.isImmediatelyInterruptable();
		}
		else
		{
			return true && super.isImmediatelyInterruptable();
		}
	}

	public function interrupt() : Void 
	{
		mIsInterrupting = true;
		
		super.interrupt();
		
		mUIInitializedListener.stop();
		
		if(!mIsInitializingSection)
		{
			mIsRunning = false;
			mIsInterrupting = false;
			
			mInitializedListener.stop();
			
			dispatchEvent({type: "interrupted", target: this});
		}
	}
	
	//******************************** This functionality is candidate for ImageLoader class in gugga library
	private var mContentParameters : HashTable;
	public function get ContentParameters() : HashTable { return mContentParameters; }
	public function set ContentParameters(aValue : HashTable) : Void { mContentParameters = aValue; }
	
	private var mLockContentRoot : Boolean;

	private var mIsInterrupting : Object;
	public function get LockContentRoot() : Boolean { return mLockContentRoot; }
	public function set LockContentRoot(aValue : Boolean) : Void { mLockContentRoot = aValue; }
	
	public function load(pContentPath:String)
	{
		this["contentHolder"]._lockroot = mLockContentRoot;
		super.load(pContentPath);
	}
	
	private function onLoadComplete()
	{
		super.onLoadComplete();
		for (var key:String in mContentParameters)
		{
			this["contentHolder"][key] = mContentParameters[key];
		}
	}
	//********************************	
}