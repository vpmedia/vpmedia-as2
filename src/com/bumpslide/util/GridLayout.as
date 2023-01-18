
import com.bumpslide.events.Dispatcher;
import com.bumpslide.events.Event;
import com.bumpslide.ui.IGridItemRenderer;
import com.bumpslide.util.ArrayUtil;
import com.bumpslide.util.Debug;
import com.bumpslide.util.Delegate;
import com.bumpslide.util.ObjectUtil;
import flash.geom.Point;

//import mx.controls.listclasses.DataProvider;

/**
 *  Grid Layout
 * 
 *  Abstracts out the process of laying down a sequence of clips in a grid.
 *  
 *  As of April 2007, this class has been entirely refactored, and there is now support for paging 
 *  via an offset index.  So, you can use it to manage both paged and scrolling data grids. 
 * 
 *  Also, there is built in support for DataProvider "modelChanged" events, so you can make
 *  use of paged recordsets.  
 * 
 *  Each grid item class receives grid rendering data in it's initObj:
 * 
 *   _gridIndex     : dataProvider index 
 * 	 _gridPosition  : grid position
 *   _gridItemData  : the data == dataProvider.getItemAt( _gridIndex )
 * 	 _gridLayout    : reference to this class instance
 *   
 *  @version 2.0
 *  @author David Knape
 */

class com.bumpslide.util.GridLayout extends Dispatcher
{
	
	//--- Events ---
	static public var EVENT_CHANGED : String = "onGridLayoutChanged";
	static public var EVENT_LAYOUT_COMPLETE : String = "onGridLayoutComplete";
	
	//-- LAYOUT MODES --
	static public var DIRECTION_DOWN_FIRST : Boolean = true;
	static public var DIRECTION_ACROSS_FIRST : Boolean = false;
		
	//--- Debug ---
	public var mDebug = false;
	public var mName = "GridLayout";
	
	//--- Private ---
		
	// target timeline (where holder will be created)
	private var mTimelineMc : MovieClip;
	private var mTimelineOrigY : Number;
	private var mTimelineOrigX : Number;
	
	// empty clip that holds items and is re-created every time we redraw
	private var mItemHolderMc : MovieClip;	
	
	// level in which to create mItemHolderMc
	private var HOLDER_LEVEL = 9799;
	
	// linkage name of clip to attach
	private var mItemLinkageId : String = 'm_box';

	// dataprovider
	private var mDataProvider;
	
	private var mOffset : Number = 0;
	private var mIndexFirst : Number = 0; // == Math.floor( offset )
	private var mIndexLast : Number = 0; // == Math.floor( offset )
	private var mMinOffset : Number  = 0;
	private var mMaxOffset : Number  = 0;
		
	// array of all item clips
	private var mItemClips:Array;
	
	// array of item clips mapped to indexes
	private var mClipMap:Array;
	
	// stack of un-assigned clips (to be recycled)
	private var mSpareClips:Array;
	
	private var isDrawn : Boolean = false;
	private var isDrawing : Boolean = false;
	
	// item attachment timing interval
	private var mAttachDelay = 30;
	private var mAttachInterval = -1;
			
	private var mUpdateRequired : Boolean = false;
	private var mSleeping : Boolean = false;
	
	// config (override in subclass)
	public var rows : Number = 5;
	public var columns : Number = 1;
	public var rowHeight : Number = 100;
	public var columnWidth : Number = 100;
	public var direction : Boolean = false;	
	
	// GridLayout is an old-fashioned AsBroadcaster as well as an EventDispatcher
	// this way, client classes can easily dispatch arbitrary events to child items
	public var broadcastMessage : Function;
	public var addListener : Function;
	public var removeListener : Function;
	
	/**
	* Create a new grid layout
	* 
	* @param	targetTimeline_mc
	* @param	mItemLinkageIdIdString
	*/
	function GridLayout( inTimeline:MovieClip, inItemLinkage:String) 
	{
		AsBroadcaster.initialize( this );
		mTimelineMc = inTimeline;
		mTimelineOrigY = mTimelineMc._y;
		mTimelineOrigX = mTimelineMc._x;
		mItemLinkageId = inItemLinkage;		
		
		reset();
		//DataProvider.Initialize( Array );
	}
	
	/**
	* get the movie clip attached at index i
	* 
	* @param	i
	* @return item movieclip
	*/
	public function getItem ( i:Number ) : MovieClip {
		return item(i);
	}
	
	/**
	* array of references to all the grid item movieclips in the current view
	*/
	public function get itemClips () : Array {
		return mItemClips;
	}

	
	/**
	* A recordset or an array
	* 
	* @return array of item data
	*/
	public function get dataProvider () {
		return mDataProvider;
	}

	/**
	* A recordset or an array
	* 
	* @param	data array
	*/
	public function set dataProvider ( dp ) {
		mDataProvider = dp;
		
		debug('setting dataProvider length='+dataProvider.length);
		
		mMinOffset = 0;
		mMaxOffset = dataProvider.length-itemsPerPage+1;
		
		mDataProvider.addEventListener( 'modelChanged', this );
		reset();
		onEnterFrameCall( update );	
	}

	/**
	* returns length of the dataprovider (total number of items in grid)
	* @return
	*/
	public function get length() : Number  {
		return dataProvider.length;
	}
	
	/**
	* returns reference to timeline
	* @return
	*/
	public function get timeline () : MovieClip {
		return mTimelineMc;
	}
	
	/**
	* offset in dataprovider (index of first item in the grid)
	* 
	* @param	n
	*/
	public function get offset () : Number  {
		return mOffset;
	}
	
	/**
	* offset in dataprovider (index of first item in the grid)
	* 
	* @param	n
	*/
	public function set offset ( inOffset ) {
			
		// constrain offset
		mOffset = Math.max( mMinOffset, Math.min( mMaxOffset, inOffset ) );
		
		debug( 'offset = ' + mOffset );
		
		// offset main holder to simulate "scrolling"
		if(rows==1)	timeline._x = Math.round( mTimelineOrigX - columnWidth * (mOffset-Math.floor(mOffset))); 
		if(columns==1) timeline._y = Math.round( mTimelineOrigY - rowHeight * (mOffset-Math.floor(mOffset)));
			
		mIndexFirst = Math.floor( mOffset );
		mIndexLast = Math.min( mIndexFirst + itemsPerPage, length);
		
		debug(mIndexFirst + ' - ' + mIndexLast );
		update();
	}
	
	/**
	* Items per page
	*/
	public function get itemsPerPage () : Number {
		return rows * columns;
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
		return Math.ceil( length/itemsPerPage );
	}
	
	
	/**
	* delay time between attaching clips in MS
	*/
	public function set attachDelay( val:Number ):Void
	{
		mAttachDelay = val;		
	}
	
	
	/**
	 * Minimum scroll offset
	 */
	public function get minOffset () : Number {		
		return mMinOffset;
	}
	
	/**
	* Minimum scroll offset
	*/
	
	public function set minOffset( val:Number ):Void
	{
		mMinOffset = val;		
	}
	
	/**
	 * Maximum scroll offset
	 */
	public function get maxOffset () : Number {		
		return mMaxOffset;
	}
	
	/**
	* Maximum scroll offset
	*/
	public function set maxOffset( val:Number ):Void
	{
		mMaxOffset = val;		
	}
	
	
	/**
	* Update the grid - non-destructive
	*/
	public function update( fromModelChange:Boolean ) 
	{		
		if(mSleeping) {
			debug('updated while sleeping , waiting to wake');
			mUpdateRequired = true;
			return;
		}
	
		cancelEnterFrameCall();
		doUpdate(fromModelChange);
		mUpdateRequired = false;
	}
	
	/**
	* hibernation, grid won't respond to changes until awakened
	*/
	public function sleep() {
		debug('sleep');
		mSleeping = true;
	}
	
	/**
	* brings grid back to life, updates it if something has changed while we were sleeping
	*/
	public function wake() {	
		debug('wake');
		mSleeping = false;
		if(mUpdateRequired) update();
	}
	
	/**
	* Zero-index page number based on current mOffset
	*/
	public function get page () {
		return Math.floor( mOffset / itemsPerPage );
	}
	
	/**
	* sets the page number (0 is first page)
	* @param	num
	*/
	public function set page ( num:Number ) {		
		offset = itemsPerPage * num;		
	}
	
	/**
	* go to the next page
	*/
	public function pageNext() {
		offset+=itemsPerPage;
	}
	
	/**
	* go to the previous page
	*/
	public function pagePrevious() {
		offset-=itemsPerPage;
	}
		
	private function modelChanged() {
		debug('model changed');
		update( true );
	}
	
	// startIndex (offset) the last time we did an update
	private var oldStartIndex:Number = null;
	
	/**
	* Updates the grid
	*/
	private function doUpdate (fromModelChange:Boolean) {
		
		
		// recycle old clips if necessary
		ArrayUtil.each( itemClips, Delegate.create( this, recycleIfNecessary )  );
		var mc;
		
		for( var n=mIndexFirst; n<mIndexLast; n++ ) {
			
			//debug( 'Update ' + n );
			
			// look for MC already assigned to this index and update its position
			mc = mClipMap[n];
			
			debug( 'update ' + n + ' ' + mc._name );
			
			if(mc==null) {
				mc = assignClipToIndex( n );
			} else {		
				
				if(fromModelChange===true) {
					// update clips that have changed data
					var item_data = dataProvider.getItemAt!=undefined ? dataProvider.getItemAt(n) : dataProvider[n];
					if(mc._gridItemData != item_data) {					
						debug('updating exisiting clip ' + mc._gridIndex + ' to be ' + n );
						mc._gridItemData = item_data;
						mc._gridIndex = n;
						mc.update();
						mc._visible = true;
					}	
				}
				
				// update clip position
				var pos:Point = calculateItemPosition( n );
				mc._x = pos.x;
				mc._y = pos.y;
			}			
		}		
		
		if(isDrawn) {
			dispatchEvent( new Event( EVENT_CHANGED, this ) );
		} else {
			isDrawn = true;
			onEnterFrameCall( notifyComplete );
		}
	}	
	
	
	
	function recycleIfNecessary( mc:MovieClip) {
		if(mc._gridIndex!=undefined && ( mc._gridIndex<mIndexFirst || mc._gridIndex>=mIndexLast ) ) {
			debug('recycling clip ' + mc._gridIndex );
			mClipMap[mc._gridIndex] = null;
			mc._gridIndex = undefined;
			mc.destroy();
			mc._visible = false;
			mSpareClips.push( mc );
		}
	}
	
	function assignClipToIndex( idx:Number ) : MovieClip {	
		var mc:MovieClip;
		
		//debug('assign clip ' + idx );
		
		// If we have some spare, unused clips, 
		if(!mSpareClips.length) {
			mc = createItemClip( idx );
		} else {
			
			mc = MovieClip( mSpareClips.shift() );	
			//debug('re-using old clip for index' + idx );
			mc._gridIndex = idx;
			mc._gridItemData = dataProvider.getItemAt!=undefined ? dataProvider.getItemAt(idx) : dataProvider[idx];
			mc.update();
			mc._visible = true;
			
			// update clip position
			var pos:Point = calculateItemPosition( idx );
			mc._x = pos.x;
			mc._y = pos.y;
		}
		mClipMap[idx] = mc;
		return mc;
	}
	
	/**
	* creates item clip and gives it data for index (idx)
	*/
	private function createItemClip( idx:Number ) : MovieClip  {	
		
		var pos:Point = calculateItemPosition( idx );
		
		debug( 'Creating clip ' + idx );
		
		var level:Number = mItemHolderMc.getNextHighestDepth();
		
		var initObj = {
			_gridPosition: level,
			_gridItemData: dataProvider.getItemAt!=undefined ? dataProvider.getItemAt(idx) : dataProvider[idx],
			_gridIndex: idx,
			_x: pos.x,
			_y: pos.y
		}
		// attach the movie clip
		
		var clip:MovieClip = mItemHolderMc.attachMovie( mItemLinkageId, 'item'+level, level, initObj );
		
		mItemClips.push( clip );
		
		// make clip listen to grid events
		addListener( clip );
		
		if(clip==undefined) {
			debug('!Attached clip is undefined, possibly a bad linkage ID? ('+mItemLinkageId+')');
		}
		// done
		return clip;
	}
	
	private function notifyComplete() {		
		dispatchEvent( new Event( EVENT_LAYOUT_COMPLETE, this) );
		dispatchEvent( new Event( EVENT_CHANGED, this ) );
	}
	
	
	/** 
	* Sizes the Grid
	* 
	* Based on the current rowHeight and columnWidth, this updates the column and row count
	* and triggers a redraw if the items per page changes.
	* 
	*/
	public function setSize(w:Number, h:Number) 
	{		
		debug('set size '+w+','+h);
		
		var oldItemsPerPage = rows * columns;
		
		rows = 1;
		columns = 1;
		
		if(rowHeight!=null && rowHeight>0) {
		    rows = Math.max( 1, Math.floor( h/rowHeight )); 	
		}
		
		if(columnWidth!=null && columnWidth>0) {
		    columns = Math.max( 1, Math.floor( w/columnWidth ) );	
		}
		
		debug('rows = '+rows+', cols='+columns );
		
		// constrain offset by settting it to itself
		offset = mOffset;
		
		if(oldItemsPerPage != rows * columns) update();
	}
	
	public function reset() 
	{
		offset = 0;
		cancelEnterFrameCall();
		//clearInterval(mAttachInterval);
		broadcastMessage('destroy');
		
		mSleeping = false;
		mUpdateRequired = false;
		isDrawn = false;
		mItemHolderMc = mTimelineMc.createEmptyMovieClip('mItemHolderMc', HOLDER_LEVEL);	
		mItemClips = new Array();
		mSpareClips = new Array();
		mClipMap = new Array();
		
	}
	
	public function destroy() 
	{
		reset();
		
		// remove all dispatcher listeners
		removeAllListeners( EVENT_CHANGED );
	}
	
	private function updateItemPosition( i:Number ) {
		var loc:Point = calculateItemPosition( i );		
		item(i)._x = loc.x;
		item(i)._y = loc.y;
	}
	
	/**
	 * Calculated the x and y pos for the grid item at index n
	 * 
	 * @param	i
	 * @return x,y location as point
	 */
	public function calculateItemPosition( n:Number ) : Point 
	{		
		
		var i = n - mIndexFirst;
		
		var column, row : Number;		
		
		// If columns count is valid...
		if(columns!=undefined && columns>0) 
		{
			// calculate grid index (column and row)
			if(direction==DIRECTION_DOWN_FIRST) 
			{
				row 	= i%rows;
				column = Math.floor(i/rows);		
			} 
			else
			{
				column = i%columns;
				row    = Math.floor(i/columns);		
			}			
		} 
		else 
		{		
			// assume an endless row, so column is simply n, 
			// and the row is always 0 (the first row)
			column = i;
			row = 0;				
		}
		
		return new Point( Math.round( columnWidth*column ), Math.round( rowHeight*row ) );
	}
	
	/**
	* get the movie clip attached at index n
	* @param	n
	* @return item movieclip
	*/
	private function item(n:Number) : MovieClip {
		return mItemHolderMc['item'+(n)];
	}
	
	/*
	private function debug(s) {
		if(mDebug) Debug.info( '[GridLayout] '+s);
	}*/	
	
	
	
	
}
