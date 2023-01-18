import com.bumpslide.util.ClassUtil;
import com.bumpslide.util.Debug;
import com.bumpslide.util.GridLayout;

/**
* Grid holder
* 
* @author David Knape 
*/
class ThumbnailGrid extends MovieClip {
	
	// dynamically created empty movie clip
	public var grid_mc:MovieClip;
	
	// background rectangle (on timeline)
	public var bg_mc:MovieClip;
	
	// our grid renderer
	private var gridLayout:GridLayout;
	
	// the instance name of our grid item
	static private var GRID_CLIP:String = "ThumbnailItem";
		
	function ThumbnailGrid() {
		init();
	}
		
	/**
	* Initialization - grid setup and population
	*/
	private function init() {
		
		// create empty holder clip in which to place our grid items
		createEmptyMovieClip('grid_mc', getNextHighestDepth() );
		grid_mc._x = 5;
		grid_mc._y = 5;

		// create gridlayout intance that will attach clips with linkage ID 'm_grid_item'
		// into our grid item holder (grid_mc)
		gridLayout = new GridLayout( grid_mc, GRID_CLIP );
		gridLayout.rowHeight = 110;
		gridLayout.columnWidth = 110;
		gridLayout.mDebug = true;
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
	* sets grid width
	* 
	* @param	w
	*/
	public function setSize( w:Number, h:Number ) {
		gridLayout.setSize( w, h );
		bg_mc._width = w;
		bg_mc._height = h;
	}
	
	/**
	* sets grid dataprovider
	* 
	* @param	dp
	*/
	public function set dataProvider(dp) {
		gridLayout.dataProvider = dp;
	}	

	
	
}