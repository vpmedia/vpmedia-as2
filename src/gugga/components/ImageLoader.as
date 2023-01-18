import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.common.IProgressiveTask;
import gugga.common.ProgressEventInfo;
import gugga.common.UIComponentEx;
import gugga.components.ImageLoaderScheduler;
import gugga.debug.Assertion;
import gugga.utils.Listener;

[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]
class gugga.components.ImageLoader extends UIComponentEx implements IProgressiveTask
{	
	private var mcLoader:MovieClipLoader;
	
	private var mIsRunning:Boolean; 
	private var mPercentsLoaded:Number;
	
	private var mUiInitialized : Boolean = false;
	
	private var mIsCompleted : Boolean;
	public function get IsCompleted() : Boolean
	{
		return mIsCompleted;
	}
	
	private var mContentPath:String;
	public function get ContentPath():String { return mContentPath; }
	public function set ContentPath(value:String):Void { mContentPath = value; }
	
	public function get content():MovieClip{
		return this["contentHolder"];
	}
	
	private var mContentParameters : HashTable;
	public function get ContentParameters() : HashTable { return mContentParameters; }
	public function set ContentParameters(aValue : HashTable) : Void { mContentParameters = aValue; }
	
	private var mLockContentRoot : Boolean;
	public function get LockContentRoot() : Boolean { return mLockContentRoot; }
	public function set LockContentRoot(aValue : Boolean) : Void { mLockContentRoot = aValue; }
	
	private var mUseImageLoaderScheduler : Boolean = true;
	public function get UseImageLoaderScheduler() : Boolean { return mUseImageLoaderScheduler; }
	public function set UseImageLoaderScheduler(aValue : Boolean) : Void { mUseImageLoaderScheduler = aValue; }
	
	public function ImageLoader() 
	{
		super();
		mPercentsLoaded = 0;
		mIsRunning = false;
		mIsCompleted = false;
		mLockContentRoot = false;
	}
	
	public function start() : Void 
	{
		mPercentsLoaded = 0;
		mIsCompleted = false;
		mIsRunning = true;
		load();
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return true;
	}
	
	public function interrupt() : Void
	{
		unloadData();
		dispatchEvent({type:"interrupted", target:this});
	}
	
	public function load(aContentPath:String)
	{
		mIsCompleted = false;
		if(aContentPath)
		{
			mContentPath = aContentPath;
		}
		
		unloadData();
		this["contentHolder"]._lockroot = mLockContentRoot;
		
		if(mUseImageLoaderScheduler)
		{
			scheduleLoading();
		}
		else
		{
			triggerLoad();
		}
	}
	
	public function unloadData() : Boolean
	{
		ImageLoaderScheduler.Instance.removeLoader(this);
		
		mIsRunning = false;
		mIsCompleted = false;
		var result : Boolean = mcLoader.unloadClip(this["contentHolder"]);

		return result;
	}
	
	private function initUI()
	{
		super.initUI();
		
		mcLoader = new MovieClipLoader();
		mcLoader.addListener(this);
		this.createEmptyMovieClip("contentHolder", this.getNextHighestDepth());
		
		mUiInitialized = true;
	}
	
	private function scheduleLoading() : Void 
	{
		ImageLoaderScheduler.Instance.addLoader(this);
	}
	
	private function triggerLoad() : Void
	{
		if(mUiInitialized)
		{
			triggerLoadActual();
		}
		else
		{
			Listener.createSingleTimeListener(
				new EventDescriptor(this, "uiInitialized"),
				Delegate.create(this, onUiInitializedAfterStart)
			);
		}
	}
	
	private function onUiInitializedAfterStart() : Void 
	{
		triggerLoadActual();
	}
	
	private function triggerLoadActual() : Void
	{
		dispatchEvent({type: "start", target: this});
		mcLoader.loadClip(mContentPath, this["contentHolder"]);
	}
	
	private function onLoadInit()
	{
		mPercentsLoaded = 100;
		mIsRunning = false;
		mIsCompleted = true;
		dispatchEvent({type:"completed",target:this});
	}
	
	private function onLoadComplete()
	{
		for (var key : String in mContentParameters)
		{
			this["contentHolder"][key] = mContentParameters[key];
		}
	}
	
	private function onLoadError(target_mc : MovieClip, errorCode : String, httpStatus : Number)
	{
		mIsRunning = false;
		mIsCompleted = true;
		
		Assertion.warning("Image '" + ContentPath + "' not loaded ( target_mc = " + target_mc + ", errorCode = " + errorCode + ", httpStatus = " + httpStatus + " )", this, arguments);
		
		dispatchEvent({type:"completed", target:this, errorCode:errorCode, httpStatus:httpStatus});
	} 
	
	private function onLoadProgress(target_mc:MovieClip, bytesLoaded:Number, bytesTotal:Number)
	{
		mPercentsLoaded = (bytesLoaded / bytesTotal) * 100;

		dispatchEvent(new ProgressEventInfo(this, bytesTotal, bytesLoaded, mPercentsLoaded));
	}
	
	private function onLoadStart()
	{
		dispatchEvent({type:"start", target:this});			
	}
	
	public function getProgress() : Number 
	{
		return mPercentsLoaded;
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
}