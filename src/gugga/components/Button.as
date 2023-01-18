import gugga.common.UIComponentEx;
import gugga.tracking.Tracker;
import gugga.utils.DebugUtils;

[Event("click")]
[Event("rollOver")]
[Event("rollOut")]
[Event("press")]

class gugga.components.Button extends UIComponentEx
{
	//TODO: constants names should be more descriptive. Example - STATE_OFF
	
	//button states
	private static var OFF:String = "off";
	private static var ON:String = "on";
	private static var OFF_DISABLE:String = "offDisable";
	private static var ON_DISABLE:String = "onDisable";
	
	//mouse states
	private static var ROLL:String = "Roll";
	private static var DOWN:String = "Down";
	private static var NORMAL:String = "";

	//frame where the movie stops for last time
	private var mLastStopedFrame:Number;
	private var mLastPlayedLabel:String; 
	
	private var mButtonState:String; 
	private var mMouseState:String;
	
	private var mEnabled:Boolean;
	public function get Enabled():Boolean { return mEnabled; }
	public function set Enabled(aValue:Boolean):Void 
	{
		if(aValue == true)
		{
			enable();
		}
		else
		{
			disable();
		}
	}
	
	private var mSelected : Boolean;
	public function get Selected() : Boolean { return mSelected; }
	public function set Selected(aValue : Boolean) : Void 
	{ 
		if(aValue == true)
		{
			select();
		}
		else
		{
			unselect();
		}
	}
	
	private var mTrackClick : Boolean = true;
	public function get TrackClick() : Boolean { return mTrackClick; }
	public function set TrackClick(aValue:Boolean) : Void { mTrackClick = aValue; }
	
	function Button()
	{
		mTrackableID = this._name;
		
		mButtonState = OFF;
		mMouseState = NORMAL;

		mLastPlayedLabel = null;
		mLastStopedFrame = null;
		
		useHandCursor = true;
		mSelected = false;
		mEnabled = true;
	}
	
	
	function onRelease()
	{
		if (mEnabled)
		{
			//check if button is rolled or no
			startTransitonToState(mButtonState, ROLL);
			
			if(mTrackClick)
			{
				Tracker.getTrackerFor(this).trackClick(this, this._xmouse, this._ymouse);
			}
			
			dispatchEvent({type:"click",target:this});
		}
	}

	function onRollOver():Void
	{
		startTransitonToState(mButtonState, ROLL);
		dispatchEvent({type:"rollOver", target:this});
	}

	function onDragOver():Void
	{
		onRollOver();
	}
	
	function onRollOut():Void
	{
		startTransitonToState(mButtonState, NORMAL);
		dispatchEvent({type:"rollOut", target:this});
	}

	function onDragOut():Void
	{
		onRollOut();
	}
	
	function onPress():Void
	{
		if (mEnabled)
		{
			startTransitonToState(mButtonState, DOWN);
			dispatchEvent({type:"press", target:this});
		}
	}
	
	function onOver()
	{
		onRollOver();
	}
	
	/*function setEnabled(flag:Boolean):Void
	{
		enabled = flag;
		_alpha = flag ? 100 : 50;
	}*/
	
	//TODO: all transitions can be separated in methods which can be overriden 
	// and can be played independently. 
	
	public function playRollOver()
	{
		startTransitonToState(mButtonState, ROLL);
	}
	
	public function playRollOut()
	{
		startTransitonToState(mButtonState, NORMAL);
	}
	
	public function click()
	{
		onRelease();
	}
	
	public function disable()
	{
		if (mEnabled)
		{
			if (mSelected)
			{
				startTransitonToState(ON_DISABLE, mMouseState);
			}
			else
			{
				startTransitonToState(OFF_DISABLE, mMouseState);
			}
			
			
			mEnabled = false;
			useHandCursor = false;
		}
	}
	
	public function enable()
	{
		if (!mEnabled)
		{
			if (mSelected)
			{
				startTransitonToState(ON, mMouseState);
			}
			else
			{
				startTransitonToState(OFF, mMouseState);
			}
			
			mEnabled = true;
			useHandCursor = true;
		}
	}
	
	public function select():Void
	{
		if(!mSelected)
		{
			startTransitonToState(ON, mMouseState);
			mSelected = true;
		}
	}
	
	public function unselect():Void
	{
		if(mSelected)
		{
			startTransitonToState(OFF, mMouseState);
			mSelected = false;
		}
	}
	
	/**
	 * The reasnos why the movie doesn't play are:
	 *  1) There is no label aLabel
	 *  2) mLastStopedFrame is equal to the aLabel frame. This
	 *  solves the problem with gotoAndPlay function which works
	 *  as following:
	 *  If gotoAndPlay is called for current frame it doesn't
 	 *  execute the source code in timeline for this frame and that's 
 	 *  why if there is stopPlaying() on it the movie will not stopPlaying().
 	 *  
 	 * @return Whether the movie start playing from label or not
	 */
	private function playLabel(aLabel:String):Boolean
	{
		var oldCurFrame:Number = this._currentframe;
		this.gotoAndPlay(aLabel);

		//mLastStopedFrame is equal to the aLabel frame
		if (mLastStopedFrame == this._currentframe)
		{
			this.gotoAndStop(aLabel);
			mLastPlayedLabel = aLabel;
			return false;
		}
		
		//There is no label aLabel
		if (oldCurFrame == this._currentframe)
		{
			return false;
		}

		mLastPlayedLabel = aLabel;
		return true;
	}
	
	/**
	 * Called from timeline every time when the movie must stop
	 */
	private function stopPlaying()
	{
		this.stop();
		mLastStopedFrame = this._currentframe;
		
		var labelForCurState:String = getLabelForCurrentState();
		if(mLastPlayedLabel != labelForCurState)
		{
			playLabel(labelForCurState);
		}
	}
	
	private function getLabelForCurrentState():String
	{
		return mButtonState + mMouseState;
	}
	
	//try to transit between current and next state and 
	//if there is no transition, play label for next state
	private function startTransitonToState(aNewButtonState:String, aNewMouseState:String)
	{
		var labelForCurState:String = getLabelForCurrentState();
		mButtonState = aNewButtonState;
		mMouseState = aNewMouseState;
		var labelForNextState:String = getLabelForCurrentState();
		
		var isPlaying:Boolean = playLabel(labelForCurState + "_" + labelForNextState);

		if (!isPlaying)
		{
			playLabel(labelForNextState);
		}
	}
}