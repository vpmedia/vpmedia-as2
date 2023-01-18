import mx.controls.MediaDisplay;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.IProgressiveTask;
import gugga.common.MediaTypes;
import gugga.common.ProgressEventInfo;

 
[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author ivo
 */
class gugga.components.MediaLoader extends EventDispatcher implements IProgressiveTask 
{
	private var mIsRunning:Boolean;
	private var mInterrupted:Boolean;
	
	private var mPercentsLoaded:Number;
	
	private var mProgressDelegate:Function;
	
	private var mMedia:MediaDisplay;
	
	private var mMediaPath:String;
	public function get MediaPath():String { return mMediaPath; }
	public function set MediaPath(aValue:String):Void { mMediaPath = aValue; }
		
	private var mMediaType:MediaTypes; 
	public function get MediaType():MediaTypes { return mMediaType; }
	public function set MediaType(aValue:MediaTypes):Void { mMediaType = aValue; }
	
	private var mUnloadMediaAfterLoad:Boolean;
	public function get UnloadMediaAfterLoad():Boolean { return mUnloadMediaAfterLoad; }
	public function set UnloadMediaAfterLoad(aValue:Boolean):Void { mUnloadMediaAfterLoad = aValue; }
	
	
	public function MediaLoader(aMedia:MediaDisplay, aMediaPath:String, aMediaType:MediaTypes)
	{
		mMedia = aMedia;
		mMediaPath = aMediaPath;
		mMediaType = aMediaType;
		
		mIsRunning = false;
		mUnloadMediaAfterLoad = false;
		
		mPercentsLoaded = 0;
		
		mProgressDelegate = Delegate.create(this, onMediaProgress);
	}
	
	public function start() : Void 
	{
		
		unloadData();
		mMedia.addEventListener("progress", mProgressDelegate);
		mIsRunning = true;
		mInterrupted = false;
		mPercentsLoaded = 0;
		
		dispatchEvent({type:"start", target:this});
				
		mMedia.setMedia(mMediaPath, mMediaType.toString());		
	}

	public function isImmediatelyInterruptable() : Boolean
	{
		return false;
	}
	
	public function interrupt() : Void
	{
		unloadData();
		mInterrupted = true;
	}
	
	public function unloadData() : Void
	{
		mMedia.stop();
		mMedia.setMedia("");
	}
	
	private function onMediaProgress(ev) : Void 
	{
		mPercentsLoaded  = (mMedia.bytesLoaded / mMedia.bytesTotal) * 100;
				
		dispatchEvent(new ProgressEventInfo(this, mMedia.bytesTotal, mMedia.bytesLoaded, mPercentsLoaded));
				
		if (mMedia.bytesLoaded == mMedia.bytesTotal)
		{
			mediaLoaded();
		}
	}
	
	private function mediaLoaded() : Void 
	{
		mMedia.removeEventListener("progress", mProgressDelegate);
		mPercentsLoaded = 100;
		
		if (mUnloadMediaAfterLoad)
		{
			unloadData();
		}
		
		mIsRunning = false;
		
		if(mInterrupted)
		{
			dispatchEvent({type:"interrupted", target:this});
		}
		else
		{
			dispatchEvent({type:"completed", target:this});
		}
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