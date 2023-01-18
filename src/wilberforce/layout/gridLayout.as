/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Simon Oliver
 * @version 1.0
 */

import wilberforce.layout.AbstractLayoutItem;
import wilberforce.layout.abstractLayout;
import wilberforce.container.IPagingContent;

// From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;
import com.bourre.log.Logger;

/** Grid layout supporting irregular sized objects.
* TODO - Strip out fixed grid elements
*/
class wilberforce.layout.gridLayout extends abstractLayout implements IPagingContent
{
	
	private var _itemHSpacing:Number;
	private var _itemVSpacing:Number;
	
	private var _page:Number;
	private var _itemsPerPage:Number;
	private var _totalPages:Number;
	private var _storedPageIndices:Array;
		
	private var _fixedItemWidth:Number;
	private var _fixedItemHeight:Number;
	
	private var _columns:Number;
	private var _rows:Number;
	private var _totalRows:Number;
	private var _rowOffset:Number;
	
	public var canJumpToPage:Boolean;
	
	private static var LAYOUT_DIMENSIONS_CHANGED : EventType =  new EventType( "onLayoutDimensionsChanged" );
	
	function gridLayout(container:MovieClip,widthValue:Number,heightValue:Number,itemHSpacing:Number,itemVSpacing:Number,fixedItemWidth:Number,fixedItemHeight:Number)
	{
		super(container,widthValue,heightValue);
		_page=0;
		_fixedItemWidth=fixedItemWidth;
		_fixedItemHeight=fixedItemHeight;
				
		if (itemHSpacing) _itemHSpacing=itemHSpacing;
		else _itemHSpacing=0;
		if (itemVSpacing) _itemVSpacing=itemVSpacing;
		else _itemVSpacing=0;
		
		_storedPageIndices=new Array();		
	}
	
	public function updateDimensionsStatistics(Void):Void
	{
		// If we are using a fixed size, we can calculate the number of pages available
		if (_fixedItemWidth && _fixedItemHeight)
		{
			var _oldColumns=_columns;
			var _oldRows=_rows;
			
			canJumpToPage=true;
			_columns=Math.floor((_width-_itemHSpacing)/(_fixedItemWidth+_itemHSpacing));
			_rows=Math.floor((_height-_itemVSpacing)/(_fixedItemHeight+_itemVSpacing));
			_totalRows=Math.ceil(_items.length/_columns);
			_itemsPerPage=_columns*_rows;
			_totalPages=Math.ceil(_items.length/_itemsPerPage);
			
			// Need to update the row so that it
			// TODO - Reset the offset to valid value for that size (ie if there are three columns, it needs to be 0, 3 etc)
			
			if (_rows!=_oldRows || _columns!=_oldColumns)
			{
				_rowOffset=Math.floor(_startItemIndex/_columns);
				_startItemIndex=_rowOffset*_columns;
			
				// Broadcast an update message
				var tDimensions=new Object();
				tDimensions.rows=_rows;
				tDimensions.columns=_columns
				tDimensions.totalRows=_totalRows;
				_oEB.broadcastEvent( new BasicEvent( LAYOUT_DIMENSIONS_CHANGED,tDimensions ) );
	
			}
		}
		else canJumpToPage=false;
	}
	
	/** Used to implement scrolling */
	public function set rowOffset(row:Number):Void
	{
		_rowOffset=row;
		_startItemIndex=row*_columns;
		render();
	}
		
	public function get rowOffset():Number
	{
		return _rowOffset
	}
	
	private function render(Void):Void
	{
		
		//updateDimensionsStatistics();
		
		// TODO - Currently only supports fixed width columns with variable height rows.
		// TODO - Cut off overlapping items from the bottom
		// Clear all render objects
		//clearRenderItems();
		
		var _newRenderItems:Array=new Array();
		
		var _itemIndex:Number=_startItemIndex;
		var renderAreaFull:Boolean=false;
		
		var tx:Number=_itemHSpacing;
		var ty:Number=_itemVSpacing;
		
		var _currentRowHeight:Number=0;
		//var _currentRowRenderItems:Array=new Array();
		var _rowsArray:Array=new Array();;
		
		var _currentRow:Number=0;
		_rowsArray[_currentRow]=new Array();
		while (!renderAreaFull && _itemIndex<_items.length)
		{
			
			var _item:AbstractLayoutItem=_items[_itemIndex];
			if (!_item.hasContainer())
			{
				var _itemContainer:MovieClip=_container.createEmptyMovieClip("item"+_itemIndex,_itemIndex);
				_item.setContainer(_itemContainer);
			}
			//_item.render(_itemContainer,_fixedItemWidth,_fixedItemHeight);
			_item.display(tx,ty,_fixedItemWidth,_fixedItemHeight)
			
			// Is it already visible?
			var _itemCurrentlyVisible=isWithinArray(_item,_renderItems);
			
			var _itemWidth=_item.width;
			var _itemHeight=_item.height;
			
			if (_fixedItemWidth) _itemWidth=_fixedItemWidth;
			if (_fixedItemHeight) _itemHeight=_fixedItemHeight;
						
			tx+=_itemWidth+_itemHSpacing;
			// End of the column reached
			if (tx>(_width-_itemHSpacing))
			{	
				// If we've not even placed one item, the area is too small for anything
				if (_rowsArray[_currentRow]==0) {_item.remove();renderAreaFull=true; return;}
				var _rowWidth=(tx-(_itemWidth+_itemHSpacing));
				_alignClipsHorizontally(_rowsArray[_currentRow],_width-_rowWidth);
				
				tx=_itemHSpacing;
				ty+=_currentRowHeight+_itemVSpacing;
				_currentRowHeight=_itemHeight;
				
				
				
				if ((ty+_itemHeight)>(_height-_itemVSpacing))
				{
					renderAreaFull=true;
					_item.remove();
					
					// Align the clips vertically
					var usedHeight=(ty);//-(_currentRowHeight+_itemVSpacing));
					var remainingVSpace=_height-usedHeight;
					_alignClipsVertically(_rowsArray,remainingVSpace);
				}
				else {
					// Reposition the current item and prepare for the next row
					
					//_currentRowRenderItems=[];
					
					
					// Force an instant move if not currently visible
					_item.moveTo(tx,ty,!_itemCurrentlyVisible);
					
					tx+=_itemWidth+_itemHSpacing;
					_currentRow++;
					_rowsArray[_currentRow]=new Array();
										
				}
			}
			else {
				_currentRowHeight=Math.max(_currentRowHeight,_itemHeight);
			}
			
			if (!renderAreaFull)
			{
				//Logger.LOG("Rendering item "+_itemIndex+" pos "+tx+","+ty+" size "+_itemWidth+"x"+_itemHeight);				
				_newRenderItems.push(_item);				
				_rowsArray[_currentRow].push(_item);
				_endItemIndex=_itemIndex;
			}
			_itemIndex++;
			
			
			// This is only necessary for non fixed width work. Commenting out for now
			/*
			// If we've reached the end, do all the aligning work
			if (_itemIndex==_items.length)
			{
				// If we have more than one row, align to the clips in the row above
				if (_rowsArray.length>1) {
					for (var i=0;i<_rowsArray[_currentRow].length;i++)
					{
						_rowsArray[_currentRow][i]._x=_rowsArray[_currentRow-1][i]._x;
					}
				}
			}
			*/
		}
		
		// Find which items need to be removed
		
		for (var i=0;i<_renderItems.length;i++)
		{
			if (!isWithinArray(_renderItems[i],_newRenderItems))
			{			
				_renderItems[i].remove();				
				//Logger.LOG("removing "+_renderItems[i]._title);
			}
		}
		_renderItems=_newRenderItems;
		
		_storedPageIndices[_page]=_startItemIndex;
	}
	
	private function _alignClipsVertically(rowsArray:Array,remainingVSpace:Number){
		var justify=false;
		if (justify)
		{
			var tIncrease=remainingVSpace/(rowsArray.length-1);		
			for (var i=0;i<rowsArray.length;i++)
			{
				for (var j in rowsArray[i]) rowsArray[i][j].moveBy(0,tIncrease*i);				
			}
		}
		else {
			var tRelativeIncrease=remainingVSpace/(rowsArray.length);
			var constantIncrease=0.5*remainingVSpace/rowsArray.length;
			for (var i=0;i<rowsArray.length;i++)
			{
				for (var j in rowsArray[i]) rowsArray[i][j].moveBy(0,constantIncrease+tRelativeIncrease*i);
			}
		}
	}
	private function _alignClipsHorizontally(clipsArray:Array,remainingHSpace:Number){
		var justify=false;
		if (justify)
		{
			var tIncrease=remainingHSpace/(clipsArray.length-1);		
			for (var i=0;i<clipsArray.length;i++)
			{
				//clipsArray[i]._x+=tIncrease*i;
				clipsArray[i].moveBy(tIncrease*i,0);
			}
		}
		else {
			var tRelativeIncrease=remainingHSpace/(clipsArray.length);
			var constantIncrease=0.5*remainingHSpace/clipsArray.length;
			for (var i=0;i<clipsArray.length;i++)
			{
				//clipsArray[i]._x+=constantIncrease+tRelativeIncrease*i;
				clipsArray[i].moveBy(constantIncrease+tRelativeIncrease*i,0);
			}
		}
	}
	
	public function nextPage(Void):Void
	{		
		if (_endItemIndex>=(_items.length-1)) return;
		_page++;
		_startItemIndex=_endItemIndex+1;
		render();
	}
	
	public function previousPage(Void):Void
	{	
		if (_page<=0) return;
		_page--;
		_startItemIndex=_storedPageIndices[_page];
		render();
	}
	
	
	
	public function jumpToPage(index:Number):Void
	{
		if (!canJumpToPage) return;
	}
	
	private function _update(updatedIndex:Number)
	{
		updateDimensionsStatistics();
		render();
	}
}
