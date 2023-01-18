import com.bumpslide.util.Debug;
/**
* ASAP Repeater Button with disabled state
*/

class com.bumpslide.ui.RepeaterButton extends org.asapframework.ui.buttons.RepeaterButton
{
	private var mDisabled:Boolean;
	
	private var mFrameDisabled:String = "disabled";
	private var mWaitTimeOut:Number = 0;
	private var mRepeatTimeOut:Number = 200;
	
	private var mFrameNormal:String = "off";
	private var mFrameRollOver:String = "over";
	private var mFrameMouseDown:String = "down";
	
	static public var EVENT_FIRE = "onEventButtonRelease";  //EventButtonEvent.ON_RELEASE

	public function set repeatTimeOut ( n : Number ) {
		mRepeatTimeOut = n;
	}
	
	public function set waitTimeOut ( n : Number ) {
		mWaitTimeOut = n;
	}
	
	// added disabled check
	public function onMouseUp () : Void {
		super.onMouseUp();
		if(disabled) {
			gotoAndStop(mFrameDisabled);
		}
	}
	
	// getter - disabled
    public function get disabled () : Boolean {
		return mDisabled;
    }	
	
	// setter - disabled
	public function set disabled (isDisabled:Boolean) : Void {
		
		enabled = !(mDisabled = isDisabled);
		
		if(isDisabled) {
			//trace('DISABLED '+this);
			stopIntervals();
			gotoAndStop(mFrameDisabled);
		} else {
			//trace('ENABLED '+this);
			gotoAndStop(mFrameNormal);
		}		
		stop();
		onEnterFrame = fixMe;
    }
	
	private function fixMe () {
		delete onEnterFrame;
		gotoAndStop( disabled ? mFrameDisabled : mFrameNormal);
	}
}
