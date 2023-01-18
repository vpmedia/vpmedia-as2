import com.bumpslide.core.BaseClip;
import com.bumpslide.util.Align;
import com.bumpslide.util.FTween;
import com.bumpslide.events.Event;
import com.bumpslide.util.MathUtil;
import flash.geom.Point;

/**
* This Joystick control is a 2-D yanker.  It should be a drop-in replacement for yanker clips.
*  
* A "yanker" is a scrollbar-like handle that sticks to a centerpoint
* 
* Handle  bounds is automatically set to the height/width of bg_mc.
* 
* When handle is dragged, the control broadcasts an event that contains
* the distance it has been dragged.  This is useful for scrolling lists
* of an indeterminate or exceedingly long length.
* 
* @author David Knape
* @version 0.1
*/

class com.bumpslide.ui.Joystick extends BaseClip {

	public static var EVENT_HANDLE_DRAGGED : String = "onHandleMove";
	public static var EVENT_HANDLE_RELEASED : String = "onHandleRelease";
	public static var EVENT_HANDLE_PRESSED : String = "onHandlePressed";
	
	public var bg_mc:MovieClip;
	public var handle_mc:MovieClip;
	public var stick_mc:MovieClip;
		
	public function get isHandleMoved () : Boolean {
		return mIsMoved;
	}
	
	public function get isMouseDown() : Boolean {
		return mIsMouseDown;
	}
	
	private function onLoad() {
		super.onLoad();				
		init();
	}
	
	/**
	 * Initializes bounds and sizes based on background and handle size
	 */
	private function init() {		
		
		mBoundsX = bg_mc._width;
		mBoundsY = bg_mc._height;
		mHandleWidth = handle_mc._width;
		mHandleHeight = handle_mc._height;
		
		Align.middle( handle_mc, mBoundsY );
		Align.center( handle_mc, mBoundsX );
		
		mOrigHandlePosX = handle_mc._x;
		mOrigHandlePosY = handle_mc._y;	
		
		stick_mc = createEmptyMovieClip('stick', 2);
		stick_mc._x = mBoundsX/2;
		stick_mc._y = mBoundsY/2;
		
		// bring handle in front of "stick"
		handle_mc.swapDepths( 3 );
		
		// handle mouse bindings
		handle_mc.onPress = d( startDragging );
		handle_mc.onRelease = handle_mc.onReleaseOutside = d( stopDragging );	
		
		// background mouse bindings
		bg_mc.onPress = d(backgroundPress);
		bg_mc.onRelease = bg_mc.onReleaseOutside = d(stopDragging);
	}
	
	private function backgroundPress() {
		handle_mc._x = MathUtil.constrain( _xmouse-mHandleWidth/2, 0, mBoundsX - mHandleWidth);
		handle_mc._y = MathUtil.constrain( _ymouse-mHandleHeight/2, 0, mBoundsY - mHandleHeight);
		startDragging();
	}
	
	/**
	 * Stops any existing handle tween and restarts a drag behavior on the handle_mc.
	 * 
	 * Starts the 'whileDragging' interval. 
	 */
	private function startDragging() {
		mIsMoved = true;
		mIsMouseDown = true;
		FTween.stopTweening( handle_mc );
		handle_mc.onTweenComplete = null;
		
		handle_mc.startDrag( false, 0, 0, mBoundsX - mHandleWidth, mBoundsY - mHandleHeight);
				
		dispatchEvent( new Event(EVENT_HANDLE_PRESSED, this ) );
		
		clearInterval( mDragUpdateInterval );
		mDragUpdateInterval = setInterval( this, 'whileDragging', mBroadcastFrequencyMs );
	}
	
	/**
	 * Called via a setInterval defined in the startDragging function
	 */
	private function whileDragging() {
		var x =  handle_mc._x - mOrigHandlePosX;
		var y =  handle_mc._y - mOrigHandlePosY;	
		var maxX = (mBoundsX - mHandleWidth)/2;
		var maxY = (mBoundsY - mHandleHeight)/2;		
		mVector = new Point( x/maxX, y/maxY );		
		var angle = Math.atan2( y, x ) * 180 / Math.PI;
		dispatchEvent(new Event(EVENT_HANDLE_DRAGGED, this, {x:vector.x, y:vector.y, angle:angle} ) );
		//drawStick(x,y);
	}
	
	private var mVector:Point;
	
	public function get vector () : Point {
		return mVector;
	}
	
	/**
	 * stops dragging and tweens the handle. whileDragging interval is not cleared until tween is complete.
	 */
	private function stopDragging() {		
				
		mIsMouseDown = false;
		
		handle_mc.stopDrag();
		handle_mc.onRollOut();
		
		dispatchEvent(new Event(EVENT_HANDLE_RELEASED, this ) );
		
		doTween();
	}
	
	private function drawStick(x:Number,y:Number) {
		stick_mc.clear();
		stick_mc.moveTo(0,0);
		stick_mc.lineStyle( 4, 0x666666, 100);
		stick_mc.lineTo( x, y );
	}
	
	private function doTween() {
		mHandleTween = FTween.ease( handle_mc, ['_x', '_y'], [mOrigHandlePosX, mOrigHandlePosY], mTweenEasingFactor);
		mHandleTween.UPDATE_MS = mBroadcastFrequencyMs; 		
		handle_mc.onTweenComplete = d( onHandleTweenComplete );
	}
	
	private function onHandleTweenComplete() {
		clearInterval( mDragUpdateInterval );	
		mIsMoved = false;
		whileDragging();
	}
	
	// PRIVATE VARS
	//---------------------
	
	private var mBoundsX:Number = 100;
	private var mBoundsY:Number = 100;
	private var mHandleWidth:Number;
	private var mHandleHeight:Number;
	private var mOrigHandlePosX:Number;
	private var mOrigHandlePosY:Number;		
	private var mDragUpdateInterval = -1;
	private var mBroadcastFrequencyMs = 30;
	private var mIsMoved = false;	
	private var mIsMouseDown = false;
	private var mHandleTween:FTween;
	private var mTweenEasingFactor:Number = .3;
}