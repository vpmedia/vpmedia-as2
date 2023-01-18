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
import wilberforce.geom.rect;
import wilberforce.layout.AbstractLayoutItem;

// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;
import wilberforce.container.IVisualContainer;

/**
* Base class for implementing layouts of AbstractLayoutItem. This could be a spiral, a grid, a list, a tsunami.....
*/
class wilberforce.layout.abstractLayout implements IVisualContainer
{
	var _container:MovieClip;
	var _width:Number;
	var _height:Number;
	var _items:Array;
	var _renderItems:Array;
	
	private var _startItemIndex:Number;
	private var _endItemIndex:Number;
	
	private var _previousPage:MovieClip;
	private var _currentPage:MovieClip;
	
	private var _oEB:EventBroadcaster;
	
	private static var LAYOUT_ITEM_SELECTED:EventType=new EventType("onLayoutItemSelected");
	private static var LAYOUT_ITEM_ROLLOVER_EVENT:EventType=new EventType("onLayoutItemRollOver");
	private static var LAYOUT_ITEM_ROLLOUT_EVENT:EventType=new EventType("onLayoutItemRollOut");
	
	function abstractLayout(container:MovieClip,widthValue:Number,heightValue:Number)
	{
		_container=container;
		_width=widthValue;
		_height=heightValue;
		_startItemIndex=0;
		_items=new Array();
		_renderItems=new Array();
		
		_oEB = new EventBroadcaster( this );
		
	}
	// To be overwritten
	function render()
	{
		
	}
	
	function isWithinArray(tItem:AbstractLayoutItem,tArray:Array)
	{		
		var tFound=false;		
		for (var j=0;j<tArray.length;j++)
		{
			if (tItem==tArray[j]) return true;			
		}
		return false
	}
	
	function setRect(renderArea:rect):Void
	{
		_container._x=renderArea.left;
		_container._y=renderArea.top;
		_width=renderArea.width;
		_height=renderArea.height;
		
		_update();
	}
	/**
	* Updates the dimensions to all listening clips (useful for scrollbars etc)
	*/
	function updateDimensionsStatistics(Void):Void
	{
		
	}
		
	public function get width():Number
	{
		return _width;
	}
	public function set width(value:Number):Void
	{
		_width=value;
	}
	public function get height():Number
	{
		return _height;
	}
	public function set height(value:Number):Void
	{
		_height=value;
	}
	
	public function addItem(item:AbstractLayoutItem)
	{
		_items.push(item);
		item.ownerLayoutObject=this;
		_update(_items.length-1);
	}
	public function setItems(itemArray:Array)
	{
		_items=itemArray;
		for (var i in _items) _items[i].ownerLayoutObject=this;
//		trace("Item length "+_items.length);
		_update();
	}
	public function toRect(Void):rect
	{
		return new rect(_container._x,_container._y,_container.x+_width,_container.y+_height);
	}
	private function _update(updatedIndex:Number)
	{
		
	}
	
	public function itemSelected(item:AbstractLayoutItem)
	{
		_oEB.broadcastEvent(new BasicEvent(LAYOUT_ITEM_SELECTED,item));
	}
	
	public function itemRolledOver(item:AbstractLayoutItem)
	{
		_oEB.broadcastEvent(new BasicEvent(LAYOUT_ITEM_ROLLOVER_EVENT,item));
	}
	
	public function itemRolledOut(item:AbstractLayoutItem)
	{
		_oEB.broadcastEvent(new BasicEvent(LAYOUT_ITEM_ROLLOUT_EVENT,item));
	}
	
	
	public function addListener(listeningObject)
	{
		_oEB.addListener(listeningObject);
	}
	
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
	
	public function get _visible():Boolean
	{
		return _container._visible
	}
	public function set _visible(value:Boolean)
	{
		_container._visible=value;
	}
	
}