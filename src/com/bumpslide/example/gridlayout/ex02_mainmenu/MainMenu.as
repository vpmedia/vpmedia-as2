import com.bumpslide.util.Align;
import com.bumpslide.util.ClassUtil;
import com.bumpslide.util.Delegate;
import com.bumpslide.util.GridLayout;

/**
* GridLayout example #2 - Horizontal Menu
* 
* In this example, we are using GridLayout place our buttons and
* populate them with data, but we are listening for the layout 
* complete event so we can adjust the button positions based on their
* sizes.
* 
* @author David Knape 
*/
class MainMenu extends MovieClip {
	
	// dynamically created empty movie clip
	public var grid_mc:MovieClip;
	
	// our grid renderer
	private var gridLayout:GridLayout 
	
	// the instance name of our grid item
	static private var GRID_CLIP:String = "MenuItem";
	
	// array of menu data
	private var gridDataProvider:Array = [ 
		"Home",
		"Portfolio",
		"Consulting Services",
		"Locations",
		"Help"
	];
	
	/**
	* Constructor - just calls init method
	*/
	function MainMenu() {
		onMouseDown = buildMenu;
		buildMenu();
	}
	
	/**
	* Creates the menu
	*/
	function buildMenu() {
		
		// create empty holder clip in which to place our grid items
		createEmptyMovieClip('grid_mc', getNextHighestDepth() );

		// create gridlayout intance that will attach clips with linkage ID 'm_grid_item'
		// into our grid item holder (grid_mc)
		gridLayout = new GridLayout( grid_mc, GRID_CLIP );

		// define grid size
		gridLayout.rows = 1;
		gridLayout.columns = 99;
		gridLayout.columnWidth = 100;
	
		// attach items all at once (no delay)
		gridLayout.attachDelay = 0;
		
		// populate grid with array of colors, triggers redraw
		gridLayout.dataProvider = gridDataProvider;
		
		gridLayout.addEventListener( GridLayout.EVENT_LAYOUT_COMPLETE, Delegate.create( this, updateButtons ) );
		
	}	
	
	/**
	* GridLayout.EVENT_LAYOUT_COMPLETE - event handler
	* 
	* positions buttons once they have been placed
	*/
	function updateButtons() {		
		Align.hbox( gridLayout.itemClips, 2 );
	}
}