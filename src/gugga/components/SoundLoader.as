import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.IProgressiveTask;
import gugga.common.ProgressEventInfo;
import gugga.debug.Assertion;

[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author ivo
 */
class gugga.components.SoundLoader extends EventDispatcher implements IProgressiveTask 
{
	private var PROGRESS_INTERVAL:Number = 100;
	private var mIntervalID:Number;
	private var mSound:Sound;
	
	private var mIsRunning:Boolean;
	private var mInterrupted:Boolean;
	
	private var mPercentsLoaded:Number;
	
	private var mSoundPath:String;
	public function get SoundPath():String { return mSoundPath; }
	public function set SoundPath(aValue:String):Void { mSoundPath = aValue; }
	
	private var mIsStreaming:Boolean;
	public function get IsStreaming():Boolean { return mIsStreaming; }
	public function set IsStreaming(aValue:Boolean):Void { mIsStreaming = aValue; }
	
	
	public function SoundLoader(aSound:Sound, aSoundPath:String, aIsStreaming:Boolean)
	{
		mSound = aSound;
		mSoundPath = aSoundPath;
		mIsStreaming = aIsStreaming;
		mIsRunning = false;
		mPercentsLoaded = 0;
	}
	
	public function start() : Void 
	{
		reset();
		
		mIsRunning = true;
		mInterrupted = false;
		mPercentsLoaded = 0;
		
		dispatchEvent({type:"start", target:this});
		
		mSound.onLoad = Delegate.create(this, onSoundLoaded);
		mIntervalID = setInterval(this, "onSoundProgress", PROGRESS_INTERVAL);
		
		mSound.loadSound(mSoundPath, mIsStreaming);	
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return false;
	}
	
	public function interrupt() : Void
	{
		reset();
		mInterrupted = true;
	}
	
	private function reset()
	{
		mSound.stop();
		clearInterval(mIntervalID);
		mSound.onLoad = null;
	}
	
	private function onSoundProgress(ev) : Void 
	{
		var bytesLoaded:Number = mSound.getBytesLoaded();
		var bytesTotal:Number = mSound.getBytesTotal();
		mPercentsLoaded = (bytesLoaded / bytesTotal) * 100;
		
		dispatchEvent(new ProgressEventInfo(this, bytesTotal, bytesLoaded, mPercentsLoaded));
	}
	
	private function onSoundLoaded(aSuccess:Boolean)
	{
		reset();
		
		mPercentsLoaded = 100;
		mIsRunning = false;
		
		Assertion.failIfFalse(
				aSuccess,
				"File not loaded", this, arguments);
		
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