import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.UIComponentEx;
import gugga.components.ISectionLoader;
import gugga.utils.DebugUtils;
import gugga.utils.Listener;

/**
 * @author Todor Kolev
 */
class gugga.components.SectionAttacher 
	extends UIComponentEx 
	implements ISectionLoader 
{
	private var mSection : gugga.application.Section;
	public function get Section() : gugga.application.Section { return mSection; }
	
	private var mSectionLinkage : String;
	public function get SectionLinkage() : String { return mSectionLinkage; }
	public function set SectionLinkage(aValue:String) : Void { mSectionLinkage = aValue; }
		
	private var mAutoInitializeSection : Boolean = true;
	public function get AutoInitializeSection() : Boolean { return mAutoInitializeSection; }
	public function set AutoInitializeSection(aValue:Boolean) : Void { mAutoInitializeSection = aValue; }
		
	private var mIsRunning : Boolean = false;
	private var mIsInitializingSection : Boolean = false;
	private var mIsInterrupting : Boolean = false;

	private var mUIInitializedListener : Listener;
	private var mInitializedListener : Listener;
		
	public function start() : Void 
	{
		mIsRunning = true;
		mIsInitializingSection = false;
		mIsInterrupting = false;
		
		unloadData();
		
		mSection = gugga.application.Section(this.attachMovie(mSectionLinkage, "Section", 
			this.getNextHighestDepth(), {_x:0, _y:0}));
			
		mUIInitializedListener = Listener.createSingleTimeMergingListener(
			new EventDescriptor(mSection, "uiInitialized"),
			Delegate.create(this, onSectionUIInitialized)
		);
		
		dispatchEvent({type: "sectionAvailable", target:this, section: mSection});
	}
	
	public function unloadData() : Boolean
	{
		MovieClip(this["Section"]).removeMovieClip();
		return true;
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

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}

	public function isImmediatelyInterruptable() : Boolean 
	{
		if(mIsInitializingSection)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	public function interrupt() : Void 
	{
		mIsInterrupting = true;
		
		mUIInitializedListener.stop();
		
		if(!mIsInitializingSection)
		{
			mIsRunning = false;
			mIsInterrupting = false;
			
			mInitializedListener.stop();
			
			dispatchEvent({type: "interrupted", target: this});
		}
	}
}