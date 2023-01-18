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

// Classes from Wilberforce
import wilberforce.layout.AbstractLayoutItem;
import wilberforce.layout.abstractLayout;
import wilberforce.container.IPagingContent;

// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;
import com.bourre.log.Logger;

/** 
* Used to render a fixed grid of items. Used as an abstract class to be extended in order to modify behaviours
* such as pagination animation.
* 
* Items can be added that are derived from AbstractLayoutItem, which determine behaviour.
* 
* In this case, variable size items are not permitted, as this removes the ability to predict number of items per page, and breaks
* the ability to scroll row by row.
* 
*/
class wilberforce.layout.gridLayoutFixed extends abstractLayout implements IPagingContent
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
		
	private var _remainingHSpace:Number;
	private var _remainingVSpace:Number;
	
	public var canJumpToPage:Boolean;
	
	private static var LAYOUT_DIMENSIONS_CHANGED : EventType =  new EventType( "onLayoutDimensionsChanged" );
	
	function gridLayoutFixed(container:MovieClip,widthValue:Number,heightValue:Number,itemHSpacing:Number,itemVSpacing:Number,fixedItemWidth:Number,fixedItemHeight:Number)
	{
		super(container,widthValue,heightValue);
		//trace("Fixed size "+fixedItemWidth+","+fixedItemHeight);
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
		//trace("-- UPDATE DIMENSIONS CALLED!")
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
			
			//trace("Columns set to "+_columns+","+_rows);
			
			_remainingHSpace=(_width-(_itemHSpacing*2))-(_columns*_fixedItemWidth+(_columns-1)*_itemHSpacing);
			_remainingVSpace=(_height-(_itemVSpacing*2))-(_rows*_fixedItemHeight+(_rows-1)*_itemHSpacing);
			
			// Need to update the row so that it
			// TODO - Reset the offset to valid value for that size (ie if there are three columns, it needs to be 0, 3 etc)
			
			if (_rows!=_oldRows || _columns!=_oldColumns)
			{
				if (_columns==0) _rowOffset=0;
				else _rowOffset=Math.floor(_startItemIndex/_columns);
				_startItemIndex=_rowOffset*_columns;
				//Logger.LOG("StartitemIndex "+_startItemIndex);
			
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
		//trace("Setting row as "+row);
		//if (isNaN(row)) row=0;
		_rowOffset=row;
		_startItemIndex=row*_columns;
		render();
	}
		
	public function get rowOffset():Number
	{
		return _rowOffset
	}
	public function get totalHeight():Number
	{
		return (_itemVSpacing+_totalRows*(_fixedItemHeight+_itemVSpacing));
	}
	
	private function render(Void):Void
	{
		//updateDimensionsStatistics();
		//Logger.LOG("Start index "+_startItemIndex);
		if (_columns==0 || _rows==0) 
		{
			for (var i=0;i<_renderItems.length;i++)	_renderItems[i].remove();								
			
			_renderItems=[];
			return;
		}
		//updateDimensionsStatistics();
		
		// TODO - Currently only supports fixed width columns with variable height rows.
		// TODO - Cut off overlapping items from the bottom
		// Clear all render objects
		//clearRenderItems();
		
		var _newRenderItems:Array=new Array();
		
		var _itemIndex:Number=_startItemIndex;
		var renderAreaFull:Boolean=false;
		
		//var tx:Number=_itemHSpacing;
		//var ty:Number=_itemVSpacing;
		
		var _currentRowHeight:Number=0;
		//var _currentRowRenderItems:Array=new Array();
		//var _rowsArray:Array=new Array();;
		
		var _currentRow:Number=0;
		var _currentColumn:Number=0;
		
		// Spacing to sort out alignment
		var _fixedRemainderHSpacing:Number=0.5*_remainingHSpace/_columns;
		var _fixedRemainderVSpacing:Number=0.5*_remainingVSpace/_rows;
		var _variableRemainderHSpacing:Number=_remainingHSpace/(_columns+1);
		var _variableRemainderVSpacing:Number=_remainingVSpace/(_rows+1);
		
		while (!renderAreaFull && _itemIndex<_items.length)
		{
			//Logger.LOG("Doing item "+_itemIndex);
			//trace("Doing item "+_itemIndex);
			
			var _item:AbstractLayoutItem=_items[_itemIndex];
			if (!_item.hasContainer())
			{
				var _itemContainer:MovieClip=_container.createEmptyMovieClip("item"+_itemIndex,_itemIndex);
				_item.setContainer(_itemContainer);
			}
			//_item.render(_itemContainer,_fixedItemWidth,_fixedItemHeight);
			var tx:Number=_itemHSpacing+_currentColumn*(_itemHSpacing+_fixedItemWidth);
			var ty:Number=_itemVSpacing+_currentRow*(_itemVSpacing+_fixedItemHeight);
			
			// Additional spacing for alignment
			tx+=_fixedRemainderHSpacing+_currentColumn*_variableRemainderHSpacing;
			ty+=_fixedRemainderVSpacing+_currentRow*_variableRemainderVSpacing;
			_item.display(tx,ty,_fixedItemWidth,_fixedItemHeight)
			
			// Is it already visible?
			var _itemCurrentlyVisible=isWithinArray(_item,_renderItems);
			
			_newRenderItems.push(_item);
			_endItemIndex=_itemIndex;
			
			_currentColumn++;
			if (_currentColumn>=_columns)
			{
				_currentColumn=0;
				_currentRow++;
				if (_currentRow>=_rows) {
					//trace("Render area full - rows "+_rows+",columns "+_columns);
					renderAreaFull=true;
				}
			}
			
			_itemIndex++;			
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
