import com.bumpslide.events.Event;
import com.bumpslide.ui.Yanker;
import com.bumpslide.util.FlashDebug;
import com.bumpslide.util.FramerateMonitor;
import com.bumpslide.util.GridLayout;

/**
 * Scrolling Grid Demo
 * 
 * @author David Knape
 */

class ScrollDemo extends com.bumpslide.core.BaseClip 
{
	// timeline clips
	//--------------------

	// Layer 1
	public var grid1_mc:ScrollGrid;
	public var grid2_mc:ScrollGrid;
	public var yanker_mc:Yanker;
	public var status_txt:TextField;
	public var togglemask_mc:MovieClip;
	
	function onLoad() {
		super.onLoad();		
		
		// watch the frame rate
		FramerateMonitor.display( _root, 0xffffff );
		
		yanker_mc.addEventListener( Yanker.EVENT_HANDLE_DRAGGED, delegate( onYankerDragged ) );		
		
		// scroll grids when yanker is dragged
		grid1_mc.grid.addEventListener( GridLayout.EVENT_CHANGED, delegate( onGridChanged ) );
		
		// toggle mask on button click
		togglemask_mc.onRelease = delegate( grid2_mc, grid2_mc.toggleMask );
		
		FlashDebug.init();
		
	}
	
	function onYankerDragged(e:Event) {				
		grid1_mc.scroll( e.distance/200 );
		grid2_mc.scroll( e.distance/200 );		
	}
	
	function onGridChanged(e:Event) {
		var grid:GridLayout = GridLayout( e.target );
		
		var first = Math.round( grid.offset + 1 );
		var last = first + grid.itemsPerPage - 1;
		var total = grid.length;
		
		status_txt.text = "Records " + first + "-" + last + " of " + total;
		
	}
	
	
	
	
}
