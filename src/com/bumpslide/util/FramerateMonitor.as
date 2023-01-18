
import com.bumpslide.util.ArrayUtil;
import com.bumpslide.util.Delegate;
import mx.events.EventDispatcher;
import org.asapframework.util.framepulse.*;

/**
* Monitors actual framerate and dispatches it in an event every second
* 
* Exampel Usage:
* 	FramerateMonitor.getInstance().addEventListener( FramerateMonitor.EVENT_FRAMERATE_UPDATE, Delegate.create(this, onFramerateUpdate) );
*    
*   function onFramerateUpdate(e) {
* 		trace('fps: e.fps');
*   }
* 
*/
class com.bumpslide.util.FramerateMonitor
{
	static var display_mc:MovieClip;
	static var displayDelegate:Function;
	
	/**
	* Displays an FPS counter in the top left corner of the stage
	* @param	host_clip
	*/
	public static function display(host_clip:MovieClip, color:Number) {
		
		// if already displaying, don't bother
		if(displayDelegate!=null) return;
		if(host_clip==null) host_clip=_root;
		if(color==null) color = 0x000000;
		
		// just in case, remove existing listener from monitor
		FramerateMonitor.getInstance().removeEventListener(FramerateMonitor.EVENT_FRAMERATE_UPDATE,  displayDelegate );
		
		// create clip to display fps in corner of screen
		display_mc = host_clip.createEmptyMovieClip('__framerate_monitor', host_clip.getNextHighestDepth());
		
		// create a text field inside that clip
		display_mc.createTextField('fps_txt', 9999879, 4, 4, 100, 16);
		display_mc.fps_txt.setNewTextFormat( new TextFormat('Verdana', 10, color) );
		display_mc.fps_txt.	selectable = false;
		// create a listener to respond to fps updates
		displayDelegate = Delegate.create( display_mc, function (e:Object) {
			this.fps_txt.text = e.fps + 'fps';
		} );
		
		// start listening
		FramerateMonitor.getInstance().addEventListener( FramerateMonitor.EVENT_FRAMERATE_UPDATE, displayDelegate );
	}
	
	/**
	* Hides framerate monitor
	*/
	static function hide() {
		FramerateMonitor.getInstance().removeEventListener(FramerateMonitor.EVENT_FRAMERATE_UPDATE,  displayDelegate );
		displayDelegate = null;
		display_mc.removeMovieClip();
	}
	
	// event
	static public var EVENT_FRAMERATE_UPDATE = "onFramerateUpdate";
	
	// singleton instance
	static private var instance:FramerateMonitor;
		
	private var framecount:Number=0;
	
	static public function getInstance() : FramerateMonitor{
		if(instance==null) instance = new FramerateMonitor();
		return instance;
	}
		
	private function FramerateMonitor() {
		EventDispatcher.initialize( this );		
		var mc:MovieClip = _root.createEmptyMovieClip('__framerateMonitorFrameBeacon', _root.getNextHighestDepth() );
		mc.onEnterFrame = Delegate.create( this, onEnterFrame );
		setInterval( this, 'updateFrameRate', 1000);
	}

	function onEnterFrame() {
		++framecount;
	}

	function updateFrameRate() {		
		dispatchEvent( {type:EVENT_FRAMERATE_UPDATE, target:this, fps:framecount} );
		framecount=0;
	}
	
	// Event Dispatcher Mix-in Functions
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	

}
