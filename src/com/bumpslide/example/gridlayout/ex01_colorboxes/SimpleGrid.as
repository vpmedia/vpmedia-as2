import com.bumpslide.util.ClassUtil;
import com.bumpslide.util.Debug;
import com.bumpslide.util.GridLayout;

/**
* GridLayout example #1 - Simple Grid
* 
* In this example, we are using the GridLayout helper to create a grid of 
* gray  boxes.
* 
* @author David Knape 
*/
class SimpleGrid extends MovieClip {
	
	// dynamically created empty movie clip
	public var grid_mc:MovieClip;
	
	// our grid renderer
	private var gridLayout:GridLayout 
	
	// the instance name of our grid item
	static private var GRID_CLIP:String = "GridItem";
	
	// array of colors to be used as dataprovider for our grid
	private var gridDataProvider:Array = [ 
		0x000000, 0x111111, 0x222222, 0x333333, 0x444444, 0x555555, 
		0x666666, 0x777777, 0x888888, 0x999999, 0xaaaaaa, 0xbbbbbb
	];
	
	/**
	* Constructor - just calls init method
	*/
	function SimpleGrid() {
		init();
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
	}
	
	/**
	* Initialization - grid setup and population
	*/
	function init() {
		
		// create empty holder clip in which to place our grid items
		createEmptyMovieClip('grid_mc', getNextHighestDepth() );
		grid_mc._x = 10;
		grid_mc._y = 20;

		// create gridlayout intance that will attach clips with linkage ID 'm_grid_item'
		// into our grid item holder (grid_mc)
		gridLayout = new GridLayout( grid_mc, GRID_CLIP );

		// define grid size
		gridLayout.rowHeight = 102;
		gridLayout.columnWidth = 152;
		gridLayout.rows = 3;
		gridLayout.columns = 4;

		// populate grid with array of colors, triggers redraw
		gridLayout.dataProvider = gridDataProvider;
		
	}	
}