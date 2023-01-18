import com.bumpslide.core.BaseClip;
import com.bumpslide.util.Delegate;
import com.bumpslide.util.GridLayout;


/**
 * Grid Controls
 * 
 * @author David Knape
 */

class GridControls extends BaseClip
{
	// timeline clips
	//--------------------

	public var start_mc:MovieClip;
	public var end_mc:MovieClip;
	public var backward_mc:MovieClip;
	public var forward_mc:MovieClip;
	
	public var status_txt:TextField;
	
	// the grid we are controlling
	private var _grid:GridLayout;
	
	/**
	* Public setter, used to assign these controls to a grid
	* @param	g
	*/
	public function set grid ( g:GridLayout ) {
		_grid = g;
		_grid.addEventListener( GridLayout.EVENT_CHANGED, delegate( updateResultsText ) );
		initButtons();
	}	
	
	private function initButtons() {
		start_mc.onRelease 		= delegate( gotoStart );
		end_mc.onRelease 		= delegate( gotoEnd );
		backward_mc.onRelease 	= delegate( pagePrevious );
		forward_mc.onRelease 	= delegate( pageNext );
	}
		
	
	private function updateResultsText() {

		if(_grid.length==undefined) {
			status_txt.text = "";
			return;
		}
		var first = Math.round( _grid.offset + 1);
		var last = first + _grid.itemsPerPage - 1;
		var total = _grid.length;
		
		status_txt.text = ""+first + "-" + last + " of " + total;
	}
	
	// paging commands...
	
	private function gotoStart() {
		_grid.offset = 0;
	}
	
	private function gotoEnd() {
		_grid.offset = _grid.length;
	}
	
	private function pagePrevious() {
		_grid.pagePrevious();
	}
	
	private function pageNext() {
		_grid.pageNext();
	}
	
	
	
	
}
