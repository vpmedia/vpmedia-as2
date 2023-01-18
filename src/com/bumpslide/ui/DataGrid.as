import com.bumpslide.events.Event;
import com.bumpslide.util.*;
import mx.remoting.RecordSet;

/**
* MovieClip Class that wraps GridLayout and support paging. (Deprecated)
* 
* This class is now deprecated.  GridLayout has everything you need, 
* and is now based on a system of indexes, so you can use it to manage both
* paged and scrolling data grids. 
* 
* This is a generic data grid with the features common to all the datagrids
* I've been building lately.  
* 
* To use, make a movieclip class that extends this one, and override the getters and 
* setters or bind them to state variables.
* 
* Alternatively, you can just create an instance of this class using 
* ClassUtil.createMovieClip
* 
* {@code 
*		import com.bumpslide.util.ClassUtil;
* 		import com.bumpslide.ui.DataGrid;
* 		import com.bumpslide.events.Event;
* 
* 		class MyGridContainer extends MovieClip 
* 		{
* 			var datagrid:DataGrid;
* 			var next_btn:MovieClip;
* 			var prev_btn:MovieClip;
* 
*      		function onLoad() {
*   			ClassUtil.createMovieClip( 'datagrid', this, DataGrid);
* 				next_btn.onRelease = Delegate.create( datagrid, datagrid.pageNext );
* 				prev_btn.onRelease = Delegate.create( datagrid, datagrid.pagePrevious );
* 			} 
* 		}
* }
* 
* Copyright (c) 2006, 2007 David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/

class com.bumpslide.ui.DataGrid extends com.bumpslide.core.BaseClip 
{
	
	static public var EVENT_PAGE_CHANGED:String = "onDataGridPageChanged";
	static public var EVENT_REDRAW:String = "onDataGridRedraw";
	static public var EVENT_GRIDLAYOUT_COMPLETE:String = "onDataGridLayoutComplete";
		
	private var mName = "DataGrid";
	
	// height and width
	private var mWidth:Number = 500;
	private var mHeight:Number = 500;	
	
	// the grid clip associated with the GridLayout instance
	private var gridholder_mc : MovieClip;
		
	// grid layout
	private var gridLayout:GridLayout;
		
	// grid layout item linkage name
	private var _itemLinkage:String = "m_results_list_item";

	// config - whether or not to kill the grid layout 
	// on every redraw.  By default thhis is false
	// and we rely on the gridLayout update feature
	// to broadcast data changes to the grid items
	// if true, then, the grid items are re-attached on each page change	
	public var killGridOnRedraw = false;
	
	// datagrid settings
	private var _columns:Number = 1;
	private var _rows:Number = 5;
	private var _columnWidth:Number = undefined;
	private var _rowHeight:Number = 70;
	
	
	
	
	// grid position (top,right,bottom,left) and padding used to calculate available space
	private var _padding : Array;
	
	// state vars
	private var _currentPage:Number = 0;
	private var _dataProvider:Array;	
	private var sleeping = false;
	private var redrawWhenAwake = false;
	
	// redraw interval stuff
	private var _redrawDelay:Number = 300;
	private var _redrawInt:Number = -1;
	
	private var mDebug:Boolean = false;
	
	// datagrids often need a centrally managed queuedLoader
	private var _qloader:QueuedLoader;

	
	function DataGrid() {
		super();
		
		// init padding
		_padding = [0,null,null,null];
		
		// create queued loaded
		_qloader = new QueuedLoader('datagrid_qloader_'+_name);

		init();		
	}
	
	private function init() {		
		reset();
	}
		
	/**
	* kills the grid and clears the loading queue
	*/
	function reset() {
		killGrid();
		qloader.clearQueue();
	}
	
	/**
	* onUnload, kill the grid
	*/
	function onUnload() : Void {
		super.onUnload();
		reset();
	}
	
	public function get redrawDelay():Number
	{
		return _redrawDelay;
	}
	
	public function set redrawDelay( val:Number ):Void
	{
		_redrawDelay = val;
		
	}
	
	
	/**
	* returns number of rows
	* @return
	*/
	public function get rows():Number
	{
		return _rows;
	}
	
	/**
	* set number of rows
	* @return
	*/
	public function set rows(val:Number):Void
	{
		_rows = Math.max(0,Math.round(val));	
		redraw();
	}
	
	/**
	* returns number of columns
	* @return
	*/
	public function get columns():Number
	{
		return _columns;
	}
	
	/**
	* set number of columns
	* @return
	*/
	public function set columns(val:Number):Void
	{
		_columns = Math.max(0,Math.round(val));	
		redraw();
	}
		
	/**
	* returns current height
	* @return
	*/
	public function get height():Number
	{
		return mHeight;
	}
	
	/**
	* sets height by calling setSize 
	* @param	val
	*/
	public function set height( val:Number ):Void
	{
		setSize( mWidth, val );
		
	}
	
	/**
	* returns current width
	* @return
	*/
	public function get width():Number
	{
		return mWidth;
	}
	
	/**
	* sets width by calling setSize
	* @param	val
	*/
	public function set width( val:Number ):Void
	{
		setSize( val, mHeight );		
	}
	
	/**
	* column width
	* @return
	*/
	public function get columnWidth():Number
	{
		return _columnWidth;
	}
	
	/**
	* column width
	* @param	val
	*/
	public function set columnWidth( val:Number ):Void
	{
		_columnWidth = val;
		setSize();
	}
	
	/**
	* row height
	* @return
	*/
	public function get rowHeight():Number
	{
		return _rowHeight;
	}
	
	/**
	* row height
	* @param	val
	*/
	public function set rowHeight( val:Number ):Void
	{
		_rowHeight = val;
		setSize();		
	}
	
	/**
	* returns itemsPerPage based on row and column count
	*/
	public function get itemsPerPage() : Number {
		return _rows * _columns;
	}
	
	/**
	* Set the current page number (0-indexed) (triggers redraw)
	* @param	n
	*/
	public function set currentPage (n:Number) {
		
		debug('!set currentPage '+n);
		
		var oldPage:Number = _currentPage;		
		var newPage:Number = Math.max( 0, Math.round( n ));
		
		if(dataProvider.length!=undefined) {
			newPage = Math.max( Math.min( newPage, totalPages-1), 0);
			//debug('! page '+newPage+'/'+totalPages);
		}
		
		if(_currentPage!=newPage) {
			debug('!currentPage changed to '+newPage+' (redrawing)');
			_currentPage = newPage;
			dispatchEvent( new Event( DataGrid.EVENT_PAGE_CHANGED, this, {page:newPage} ) );
			onPageChanged();
			redraw();
		} else {
			debug('!currentPage not changed (requestedPage='+newPage+')');
		}
	}	
	
	/**
	* linkage name of item to attach in each cell
	* @return string linkageID
	*/
	public function get itemLinkage():String
	{
		return _itemLinkage;
	}
	
	/**
	* linkage name of item to attach in each cell
	*/
	public function set itemLinkage( val:String ):Void
	{
		_itemLinkage = val;
		killGrid();
		redraw();
	}
	
	/**
	* top padding, gridholder_mc._y
	* @return
	*/
	public function get paddingTop() : Number 
	{
		return _padding[0];
	}
	
	/**
	* right padding
	* @return
	*/
	public function get paddingRight() : Number 
	{
		return _padding[1]!=null ? _padding[1] : _padding[0];
	}
	
	/**
	* bottom padding
	* @return
	*/
	public function get paddingBottom() : Number 
	{
		return _padding[2]!=null ? _padding[2] : _padding[0];
	}
	
	/**
	* left padding, gridholder_mc._x
	* @return
	*/
	public function get paddingLeft() : Number 
	{
		return _padding[3]!=null ? _padding[3] : ( _padding[1]!=null ? _padding[1] : _padding[0] );
	}
	
	/**
	* Sets padding parameters
	* 
	* @param	top
	* @param	right
	* @param	bottom
	* @param	left
	*/
	public function setPadding (top:Number, right:Number, bottom:Number, left:Number ) : Void 
	{
		_padding[0] = top;
		_padding[1] = right;
		_padding[2] = bottom;
		_padding[3] = left;
		
		setSize();
	}
	
	/**
	* subclass hook - called when page changes
	*/
	function onPageChanged() {

	}
	
	/**
	* returns the current page number (0-indexed)
	*/
	public function get currentPage () : Number {
		return _currentPage;
	}
	
	/**
	* set dataprovider (array of item data, or recordset)
	* @param dataprovider
	*/
	public function set dataProvider ( data ) {
		_dataProvider = data;
		redraw();	
	}
		
	/**
	* Returns the current data provider
	* @return full data provider array
	*/
	public function get dataProvider() {
		return _dataProvider;
	}
	
	/**
	* Returns reference to queued loader for this datagrid
	* @return
	*/
	public function get qloader():QueuedLoader
	{
		return _qloader;
	}	
	
	/**
	* Returns the current page of data
	* 
	* That is, we are returning a slice of the data provider
	* that corresponds to the current page
	* 
	* @return array of data items
	*/
	public function get currentPageData () : Array {				
		var pageNum = Math.min( Math.max( currentPage, 0) , totalPages-1 );		
		// create array of item indexes to pass into grid items
		var start:Number = itemsPerPage*pageNum;
		var end:Number = Math.min( dataProvider.length, start + itemsPerPage);		
		debug('!Current Page Data: pageNum='+pageNum+', itemsPerPage='+itemsPerPage+', dataProvider.length='+dataProvider.length+', startingIndex='+start+', endingIndex='+end);
		return dataProvider.slice(start, end);
	}
	
	/**
	* Returns the total number of pages 
	* 
	* This is calculated using the  current dataprovider and the number of items per page
	* 
	* This is useful for displaying page info in controls and things like that.
	* 
	* @return
	*/
	public function get totalPages () : Number {		
		return Math.ceil( dataProvider.length/itemsPerPage );
	}
	
	/** 
	* Sizes the Grid
	* 
	* Based on the current rowHeight and columnWidth, this updates the column and row count
	* and triggers a redraw if the items per page changes.
	* 
	*/
	public function setSize(w:Number, h:Number) {	
		
		debug('set size '+w+','+h);
		
		var oldItemsPerPage = itemsPerPage;
		
		mWidth = Math.round( w==null ? width : w );
		mHeight = Math.round( h==null ? height : h );
		
		if(rowHeight!=null && rowHeight>0) {
		    _rows = Math.floor( (height - paddingTop - paddingBottom) / rowHeight ); 	
		} else {
			_rows = 1;
		}
		
		if(columnWidth!=null && columnWidth>0) {
		    _columns = Math.floor( (width - paddingLeft - paddingRight) / columnWidth );	
		} else { 
			_columns = 1;
		}
		
		// use gridLayout to broadcast a message to all the row item clips
		gridLayout.broadcastMessage( 'setWidth', width );
		
		if(oldItemsPerPage != itemsPerPage) redraw();
	}
	
	/**
	* removes grid clips, destorys the gridLayout instance, and re-creates the grid holder
	*/
	public function killGrid() 
	{
		debug('killGrid');
		
		clearInterval(_redrawInt);	
		
		// destroy the grid layout instance
		gridLayout.removeAllListeners();
		gridLayout.destroy();
		
		// re-create grid holder
		createEmptyMovieClip( 'gridholder_mc', 1);
		gridLayout = new GridLayout( gridholder_mc, _itemLinkage);	
		gridLayout.addEventListener( GridLayout.EVENT_LAYOUT_COMPLETE, Delegate.create( this, _gridLayoutComplete) );
	}
	

	/**
	* Trigger redrawing of grid 
	* 
	* 
	*/
	public function redraw() {
				
		if (killGridOnRedraw) killGrid();
		
		if(sleeping) {
			debug('redraw called while sleeping');
			redrawWhenAwake = true;
			return;
		}
		redrawWhenAwake = false;
		
		debug( 'redraw triggered');
		clearInterval(_redrawInt);		
		_redrawInt = setInterval(this, 'doRedraw', _redrawDelay);
	}
	
	
	/**
	* hibernate
	*/
	public function sleep() {
		sleeping = true;
		_visible = false;
	}
	
	/**
	* come back to life
	*/
	public function wake() {		
		sleeping = false;
		_visible = true;
		if(redrawWhenAwake) redraw();		
	}
		
	/**
	* Redraw function called after an interval by the 'redraw' function
	*/
	private function doRedraw() {		

		clearInterval(_redrawInt);
		
		if(dataProvider.length==undefined) {
			// invalid dataprovider, or no data loaded
			debug('undefined dataProvider during attempted redraw');
			killGrid();
			return;
		}
		
		if(dataProvider.length==0) {
			// no results
			showNoResults();
			dispatchEvent( new Event( DataGrid.EVENT_REDRAW, this ) );
			killGrid();
			return;
		}
		
		debug('doRedraw');
		_visible = true;
			
		gridholder_mc._y = paddingTop;
		gridholder_mc._x = paddingLeft;
		
		gridLayout.columns = _columns;
		gridLayout.rows = _rows;		
		gridLayout.rowHeight = rowHeight;
		gridLayout.columnWidth = columnWidth;
		gridLayout.offset = itemsPerPage*currentPage;
		gridLayout.dataProvider = currentPageData;	
		
		dispatchEvent( new Event( DataGrid.EVENT_REDRAW, this ) );
		onRedraw();
		
		
	}
	
	private function _gridLayoutComplete() 
	{		
		onGridLayoutComplete();		
		dispatchEvent( new Event( DataGrid.EVENT_GRIDLAYOUT_COMPLETE, this ) );
	}
	
	/**
	* Subclass hook - called just after new dataprovider is sent to gridLayout
	*/
	private function onRedraw() 
	{
		// update controls and/or other display here
	}
	
	/**
	* subclass hook - grid layout complete 
	*/
	private function onGridLayoutComplete() 
	{
		debug('Grid layout complete');
	}
	
	
	/**
	* subclass hook - implement 'no result' display here
	*/
	private function showNoResults() {
		debug('no results');
	}
	
	/**
	* subclass hook - show loading indicator here
	*/
	private function showLoading() {
		debug('Loading...');
	}
	
	/**
	* go to next page
	*/
	function pageNext() {
		currentPage++;
	}
	
	/**
	* go to previous page
	*/
	function pagePrevious() {
		currentPage--;
	}
}