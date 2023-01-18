import com.bumpslide.events.Event;
import flash.geom.Rectangle;

/**
* Generic Resize Handle implementation
* 
* Original concept by Michael Godfrey.  
* Refactored by David Knape.
* 
* @author Michael Godfrey, David Knape
*/ 

class com.bumpslide.ui.ResizeHandle extends com.bumpslide.ui.Button
{
	
	//=== events ===
	
	public static var EVENT_HANDLE_DRAG = "onResizeHandleDrag";
	public static var EVENT_HANDLE_STOP = "onResizeHandleStop";
	
	
	//=== getters/setter ===
	
	
	/**
	* whether or not we are dragging
	* 
	* @return
	*/
	public function get isDragging():Boolean
	{
		return mIsDragging;
	}
	
	/**
	* Current drag contraint
	* 
	* @return
	*/	
	public function get constraint():Rectangle
	{
		return mConstraint;
	}
	
	/**
	* Sets drag contraints as rectangle 
	* 
	* (left, top, right, bottom)
	* aka. (minX, minY, maxX, maxY);
	* 
	* @param	val
	*/
	public function set constraint( val:Rectangle ):Void
	{
		mConstraint = val;
		if(mIsDragging) {
			// restart dragging within new constraint
			startDragging();
		}
	}
		
	
	
	//=== private ===
	
	
	
	// state
	private var mIsDragging:Boolean = false;
	
	// drag constraints
	private var mConstraint:Rectangle;
		
	// listener
	private var mouseListener:Object;
	
	
	/**
	* on load, create mouse listener
	*/
	private function onLoad() : Void
	{
		super.onLoad();
		mouseListener = new Object();
		mouseListener.onMouseMove = delegate( mouseMoved );
	}
	
	/**
	* just in case 
	*/
	private function onUnload() : Void
	{
		super.onUnload();
		Mouse.removeListener( mouseListener );	
	}
	
	/**
	* on mouse press, start dragging
	*/
	private function onPress() : Void 
	{
		debug( 'onPress' );
		mIsDragging = true;	
		startDragging();
		Mouse.addListener( mouseListener );
		super.onPress();
	}
	
	/**
	* starts dragging within current constraint
	*/
	private function startDragging () : Void 
	{
		mIsDragging = true;	
		mMc.startDrag( false, constraint.left, constraint.top, constraint.right, constraint.bottom );		
	}
	
	/**
	* while dragging, dispatch events
	*/
	private function mouseMoved() : Void 
	{
		//trace('mouse moved');
		if ( mIsDragging ) {
			dispatchEvent( new Event( EVENT_HANDLE_DRAG, this, {x:mMc._x, y:mMc._y} ) );
		}
	}
	
	/**
	* on any mouse up, stop dragging
	* 
	* dispatches one last handle dragged event if we were in fact dragging
	*/
	private function onMouseUp () : Void 
	{
		mMc.stopDrag();
		Mouse.removeListener( mouseListener );		
		if(mIsDragging) {
			dispatchEvent( new Event( EVENT_HANDLE_STOP, this, {x:mMc._x, y:mMc._y} ) );
		}		
		mIsDragging = false;
	}
		
	
	
	// --- DEBUG ---
	private var mDebug:Boolean = true;
	public function toString ():String {
		return '[ResizeHandle '+mName+']';
	}
}