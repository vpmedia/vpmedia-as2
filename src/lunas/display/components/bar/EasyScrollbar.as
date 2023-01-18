/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**	EasyScrollbar

	AUTHOR
	
		Name : EasyScrollbar
		Package : lunas.display.components.bar
		Version : 1.0.0.0
		Date :  2006-02-14
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	PROPERTY SUMMARY
	
		- autoResetPosition:Boolean
	
		- direction:Number [R/W]
		
		- position:Number [R/W]
	
	METHOD SUMMARY
		
		- dragging():Void
		
		- getBar():MovieClip
		
		- getDirection():Number
		
		- getPosition():Number
		
		- getThumb():MovieClip
		
		- setDirection(n:Number):Void
		
		- setPosition(pos:Number, noEvent:Boolean):Void
		
		- startDragging():Void
		
		- stopDragging():Void
	
	EVENT TYPE SUMMARY
	
		- DRAG:EventType
		
		- CHANGE:EventType
	
*/

import asgard.display.Direction;

import lunas.display.components.bar.AbstractScrollbar;
import lunas.display.components.shape.RectangleComponent;

import vegas.events.Delegate;

class lunas.display.components.bar.EasyScrollbar extends AbstractScrollbar 
{

	// ----o Constructor
	
	public function EasyScrollbar() 
	{
		super() ;
		_createBar() ;
		_createThumb() ;
		setSize(10, 200) ;
	}

	// ----o Constant
	
	static public var BAR_RENDERER:Function = RectangleComponent ;
	static public var THUMB_RENDERER:Function = RectangleComponent ;

	// ----o Public Properties

	public var bar:MovieClip ;
	public var thumb:MovieClip ;

	// ----o Public Methods		

	public function draw():Void 
	{
		_refreshBar() ;
		_refreshThumb() ;
	}
	
	public function getBar():MovieClip 
	{
		return bar ;
	}

	public function getThumb():MovieClip 
	{
		return thumb ;
	}

	public function viewEnabled():Void  
	{
		bar.enabled = enabled ;
		bar._alpha = enabled ? 100 : 50 ;
		thumb.enabled = enabled ;
		thumb._alpha = enabled ? 100 : 50 ;
	}

	// ----o Private Properties

	private var _nDirection:Number = Direction.VERTICAL ; 

	// ----o Private Methods
	
	private function _createBar():Void 
	{
		createChild(BAR_RENDERER, "bar", 0) ;
		bar.onPress = Delegate.create(this, dragging) ;
		bar.useHandCursor = false ;
	}

	private function _createThumb():Void 
	{
		createChild(THUMB_RENDERER, "thumb", 1) ;
		thumb.onPress = Delegate.create(this, startDragging) ;
		thumb.onRelease = Delegate.create(this, stopDragging) ;
		thumb.onReleaseOutside = thumb.onRelease ;
		thumb.useHandCursor = false ;
	}

	private function _refreshBar():Void 
	{
		bar.refresh( {
			t : 1 , la : 100 , lc : 0xFFFFFF ,
			fc : 0xFF0000 , fa : 100
		} ) ;
		bar.setSize(_w, _h) ;

	}
	
	private function _refreshThumb():Void 
	{
		thumb.refresh( {
			t : 0 , la : 100 , lc : 0x000000 ,
			fc : 0x000000 , fa : 100
		} ) ;
		var __w:Number = (direction == Direction.HORIZONTAL) ? 20 : _w  ;
		var __h:Number = (direction == Direction.HORIZONTAL) ? _h : 20  ;
		thumb.setSize(__w, __h) ;
	}
	
}