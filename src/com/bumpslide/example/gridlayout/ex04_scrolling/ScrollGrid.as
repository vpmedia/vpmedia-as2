import com.bumpslide.util.ClassUtil;
import com.bumpslide.util.Debug;
import com.bumpslide.util.Draw;
import com.bumpslide.util.GridLayout;

/**
* GridLayout example #3 - Scrolling Grid
* 
* In this example, we are using the GridLayout helper to 
* create a data grid that can be scrolled.
* 
* @author David Knape 
*/
class ScrollGrid extends MovieClip {
	
	// dynamically created empty movie clip
	public var grid_mc:MovieClip;
	public var mask_mc:MovieClip;
	
	// our grid renderer
	private var gridLayout:GridLayout 
	
	// the instance name of our grid item
	static private var GRID_CLIP:String = "GridItem";
		
	/**
	* Constructor - just calls init method
	*/
	function ScrollGrid() {
		init();
	}
	
	/**
	* public access to gridlayout instance
	* 
	* @return
	*/
	public function get grid () : GridLayout {		
		return gridLayout;
	}	
	
	/**
	* Initialization - grid setup and population
	*/
	private function init() {
		
		// create empty holder clip in which to place our grid items
		createEmptyMovieClip('grid_mc', getNextHighestDepth() );
		grid_mc._x = 1;
		grid_mc._y = 1;

		// create gridlayout intance that will attach clips with linkage ID 'm_grid_item'
		// into our grid item holder (grid_mc)
		gridLayout = new GridLayout( grid_mc, GRID_CLIP );

		// define grid size
		gridLayout.rowHeight = 40;
		gridLayout.columnWidth = 200;
		gridLayout.rows = 8;
		gridLayout.columns = 1;
		gridLayout.mDebug = true;
		
		// populate grid with array of colors, triggers redraw
		gridLayout.dataProvider = SampleData.getBigDataSet();
		
		toggleMask();		
	}	
	
	private var masked:Boolean = false;
	
	public function toggleMask() {
	
		if(masked) {
			grid_mc.setMask( null );
			masked = false;				
		} else {
			// mask the grid
			createEmptyMovieClip('mask_mc', getNextHighestDepth() );
			Draw.box( mask_mc, 198, 280, 0x00ff00, 0 );
			mask_mc._x = mask_mc._y = 1;
			grid_mc.setMask( mask_mc );
			masked = true;
		}
		
		
		
	}
	public function hideMask() {
		delete mask_mc;
	}
	
	
	/**
	* Scroll the grid
	* 
	* @param	numLines
	*/
	public function scroll( numLines:Number ) {
		gridLayout.offset += numLines;
	}
}