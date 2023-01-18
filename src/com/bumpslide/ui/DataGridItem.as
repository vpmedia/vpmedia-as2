import com.bumpslide.ui.DataGrid;
import com.bumpslide.util.GridLayout;
import com.bumpslide.util.QueuedLoader;

/**
* This is an abstract DataGrid Item class 
* 
* Maybe we should pull this out into an interface.
* Michael, get to work. :)
*/
class com.bumpslide.ui.DataGridItem extends com.bumpslide.core.BaseClip
{
	// Data passed in via initObj from GridLayout class
	private var _gridItemData:Object;
	private var _gridIndex:Number;
	private var _gridLayout:GridLayout;
	
	// reference to datagrid and queued loader (if applicable)
	private var dataGrid:DataGrid;
	private var qloader:QueuedLoader;
		
	private var mName:String = "DataGridItem";
	
	
	function DataGridItem()
	{
		super();
		dataGrid = DataGrid( _gridLayout.timeline._parent );
		qloader = dataGrid.qloader;
	}
	
	/**
	* Called when datagrid row needs to be updated with new content
	*/ 
	function update() {
		debug('update ');
	}
	
	function destroy() {
		debug('destroy');
	}
	
	function onLoad() {
		super.onLoad();
		update();
	}
	
	function onUnload(){ 
		super.onUnload();
		destroy();
	}
}
