import gugga.animations.IAnimation;
import gugga.collections.ArrayList;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
class gugga.animations.TimeLineAnimation extends gugga.common.UIComponentEx implements IAnimation
{	
	private var mIsRunning:Boolean = false;
	private var mDoLoop:Boolean = false;
	private var mHideAfterCompletion:Boolean = true;

	private var mCuePoints:Array;
	
	public function get DoLoop():Boolean { return mDoLoop; }
	public function set DoLoop(aValue:Boolean):Void { mDoLoop = aValue; }	
	
	public function get HideAfterCompletion():Boolean { return mHideAfterCompletion; }
	public function set HideAfterCompletion(aValue:Boolean):Void { mHideAfterCompletion = aValue; }
	
	public function getCuePointEventNames() : Array 
	{
		var result : ArrayList = new ArrayList();
		for (var i : Number = 0; i < mCuePoints.length; i++)
		{
			result.push(mCuePoints[i].event);
		}
		return result;
	}
	
	function TimeLineAnimation()
	{		
		mCuePoints = new Array();
		this.onEnterFrame = null;

		stop();
		hide();
	}
	
	public function addCuePoint(aFrame:Number, aEventName:String) : Void 
	{
		mCuePoints.push({position:aFrame, event:aEventName});
		mCuePoints.sortOn("position");
	}
	
	public function show():Void
	{
		this._visible = true;
	}
	
	public function hide():Void
	{
		this._visible = false;
	}

	public function start():Void
	{
		if (!mIsRunning)
		{
			mIsRunning = true;
			
			dispatchEvent({type:"start", target:this});
			
			gotoAndStop(1);
			
			show();
			this.play();
		}
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function play():Void
	{
		this.onEnterFrame = this.onEnterFrameHandler;
		
		super.play();
	}
	 
	public function stop():Void
	{
		interrupt();
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return true;
	}
	
	public function interrupt() : Void
	{
		mIsRunning = false;
		
		this.onEnterFrame = null;
		super.stop();
		
		dispatchEvent({type:"interrupted", target:this});
	}
	
	public function onEnterFrameHandler()
	{
		if (!mIsRunning)
		{
			this.onEnterFrame = null;
			return;
		}
		
		for(var i:Number = mCuePoints.length - 1; i >= 0; i--)
		{
			if(this._currentframe >= mCuePoints[i].position)
			{
				dispatchEvent({type:mCuePoints[i].event, target:this});
				break;
			}
		}
		
		if (!this.mDoLoop)
		{
			if(this._currentframe == this._totalframes)
			{
				onAnimationCompleted();
			}
		}
	}
	
	/**
	 * Called from timeline to dispatch timeline driven cuepoint.
	 */
	private function dispatchCuePoint(aEvent : String) : Void
	{
		dispatchEvent({type:aEvent, target:this});
	}
	
	private function onAnimationCompleted()
	{	
		this.stop();	
		
		mIsRunning = false;

		dispatchEvent({type:"completed", target:this});

		if(mHideAfterCompletion)
		{
			hide();	
		}
	}
}