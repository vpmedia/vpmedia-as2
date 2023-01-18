import com.bumpslide.events.Event;
import com.bumpslide.util.Align;
import com.bumpslide.util.FTween;
import com.bumpslide.util.MathUtil;


/**
 * Yanker is deprecated in favor of the new Joystick class
 * 
 * @author David Knape
 */

class com.bumpslide.ui.Yanker extends com.bumpslide.core.BaseClip
{	
	static var EVENT_HANDLE_DRAGGED : String = "onHandleMove";
	static var EVENT_HANDLE_RELEASED : String = "onHandleRelease";
	
	static var DIRECTION_VERTICAL : Boolean = true;
	static var DIRECTION_HORIZONTAL : Boolean = false;
	
	public var bg_mc:MovieClip;
	public var handle_mc:MovieClip;
	
	// drag bounds, defaults to height/width of bg_mc (depending on scroll direction)
	private var mBounds:Number;
	private var mHandleSize:Number;
	private var mOrigHandlePos:Number;
	private var mDirection:Boolean = true;
		
	private var dragInt = -1;
	private var whileDraggingIntervalMs = 20;
	private var isDragging = false;	
	private var handleTween:FTween;
		
	/**
	* Sets yanker direction (horiz or vert)
	* 
	* Yanker.DIRECTION_VERTICAL 
	* or
	* Yanker.DIRECTION_HORIZONTAL
	* 
	* @param	d
	*/
	public function set direction (d:Boolean) {
		mDirection = d;
		init();
	}	
	
	private function onLoad() {
		super.onLoad();		
		
		init();
		
		// handle events
		handle_mc.onPress = d( startDragging );
		handle_mc.onRelease = handle_mc.onReleaseOutside = d( stopDragging );	
	}
	
	/**
	 * Initializes bounds and sizes based on background and handle size
	 */
	private function init() {		
		// init dimensions
		if(mDirection==DIRECTION_VERTICAL) {
			mBounds = bg_mc._height;
			mHandleSize = handle_mc._height;
			Align.middle( handle_mc, mBounds );	
			mOrigHandlePos = handle_mc._y;
		} else {
			mBounds = bg_mc._width;
			mHandleSize = handle_mc._width;
			Align.center( handle_mc, mBounds );	
			mOrigHandlePos = handle_mc._x;
		}		
	}
	

	/**
	 * Stops any existing handle tween and restarts a drag behavior on the handle_mc.
	 * 
	 * Starts the 'whileDragging' interval. 
	 */
	private function startDragging() {
		isDragging = true;
		FTween.stopTweening( handle_mc );
		handle_mc.onTweenComplete = null;
		if(mDirection) {
			handle_mc.startDrag( false, handle_mc._x, 0, handle_mc._x, mBounds - mHandleSize );
		} else {
			handle_mc.startDrag( false, 0, handle_mc._y, mBounds - mHandleSize, handle_mc._y );
		}
		clearInterval( dragInt );
		dragInt = setInterval( this, 'whileDragging', whileDraggingIntervalMs );
	}
	
	/**
	 * Called via a setInterval defined in the startDragging function
	 */
	private function whileDragging() {
		var dist = (mDirection) ? handle_mc._y - mOrigHandlePos : handle_mc._x - mOrigHandlePos;
		dispatchEvent(new Event(EVENT_HANDLE_DRAGGED, this, {distance:dist} ) );
	}
	
	/**
	 * stops dragging and tweens the handle. whileDragging interval is not cleared until tween is complete.
	 */
	private function stopDragging() {		
		isDragging = false;		
		handle_mc.stopDrag();
		handle_mc.onRollOut();
		doTween();
	}
	
	private function doTween() {
		handleTween = FTween.ease( handle_mc, (mDirection) ? '_y' : '_x', mOrigHandlePos, .25);
		handle_mc.onTweenComplete = d( onHandleTweenComplete );
	}
	
	private function onHandleTweenComplete() {
		clearInterval( dragInt );	
		whileDragging();
		dispatchEvent(new Event(EVENT_HANDLE_RELEASED, this ) );
	}
}
