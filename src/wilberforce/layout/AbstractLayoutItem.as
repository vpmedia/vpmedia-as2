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

import wilberforce.layout.abstractLayout;
 
// Classes from pixlib
import com.bourre.log.Logger;
import com.bourre.commands.Delegate;


/**
* Base class for items to be added to a layout system. Implements basic elements, such as location
* The idea is to extend this class to provide functionality for the specific item (rendering, animation, rollover etc)
*/
class wilberforce.layout.AbstractLayoutItem
{
	private var _width:Number;
	private var _height:Number;
	public var itemState:String;
	
	var CREATED_INVISIBLE:String="CREATED_INVISIBLE";
	var CREATED_VISIBLE:String="CREATED_VISIBLE";
	var NOT_CREATED:String="NOT_CREATED";
	
	var _container:MovieClip;
	
	public var ownerLayoutObject:abstractLayout;
	
	public function AbstractLayoutItem()
	{
		itemState=NOT_CREATED;
		
	}
	
	private function render(fixedItemWidth:Number,fixedItemHeight:Number):Void
	{
		
	}
	
	/** Implement animation in your derived class if required */	
	public function moveTo(x:Number,y:Number,instant:Boolean):Void
	{
		_container._x=x;
		_container._y=y;
	}
	
	public function moveBy(x:Number,y:Number):Void
	{
		_container._x+=x;
		_container._y+=y;
	}
	
	/** Implement animation in your derived class if required */
	public function hide():Void
	{
		_container._visible=false;		
	}
	public function show():Void
	{
		_container._visible=true;		
	}
	
	/*****************************************************
	* Core functions. Over-riding is not recommended 
	*****************************************************/
	
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
	
	
	public function setContainer(container:MovieClip):Void
	{
		_container=container;
		setupPressFunction();
	}
	
	public function setupPressFunction()
	{
		_container.onPress=Delegate.create(this,select);
		_container.onRollOver=Delegate.create(this,onRollOver);
		_container.onRollOut=Delegate.create(this,onRollOut);
		_container.onReleaseOutside=Delegate.create(this,onReleaseOutside);
		
	}
	
	public function select()
	{
		ownerLayoutObject.itemSelected(this);
	}
	
	public function onRollOver()
	{
		ownerLayoutObject.itemRolledOver(this);
	}
	
	public function onRollOut()
	{
		ownerLayoutObject.itemRolledOut(this);
	}
	public function onReleaseOutside()
	{
		
	}
	
	
	public function display(x:Number,y:Number,fixedItemWidth:Number,fixedItemHeight:Number):Void
	{
		//Logger.LOG("Display "+itemState);
		switch (itemState)
		{
			case CREATED_VISIBLE:
				// Just move to the new location
				moveTo(x,y);
				break;
			case CREATED_INVISIBLE:
				_container._x=x;
				_container._y=y;
				show();
			case NOT_CREATED:
				_container._x=x;
				_container._y=y;
				render(fixedItemWidth,fixedItemHeight);
				break;
		}
		itemState=CREATED_VISIBLE;
	}
	
	public function remove():Void
	{
		hide();
		itemState=CREATED_INVISIBLE;
	}
	
	public function hasContainer():Boolean
	{
		if (_container) return true;
		return false;
	}
}