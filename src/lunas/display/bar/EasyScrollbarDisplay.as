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

import asgard.display.CapStyle;
import asgard.display.Direction;
import asgard.display.JoinStyle;
import asgard.display.LineScaleMode;

import lunas.display.abstract.AbstractScrollbarDisplay;

import pegas.draw.RectanglePen;

import vegas.events.Delegate;

/**
 * This class implements an easy representation of the IScrollbar interface.
 * @author
 */
class lunas.display.bar.EasyScrollbarDisplay extends AbstractScrollbarDisplay 
{

	/**
	 * Creates a new EasyScrollbarDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	public function EasyScrollbarDisplay( sName:String, target:MovieClip ) 
	{ 
		
		super ( sName, target ) ;

		bar   = view.createEmptyMovieClip( "bar"   , 0 ) ;
		thumb = view.createEmptyMovieClip( "thumb" , 1 ) ;
		
		_barPen   = new RectanglePen(bar) ;
		_thumbPen = new RectanglePen( thumb ) ;
		
		bar.onPress = Delegate.create(this, dragging) ;
		bar.useHandCursor = false ;
		
		thumb.onPress = Delegate.create(this, startDragging) ;
		thumb.onRelease = Delegate.create(this, stopDragging) ;
		thumb.onReleaseOutside = thumb.onRelease ;

		direction = Direction.VERTICAL ; 

		setSize(10, 200) ;

	}
	
	/**
	 * The bar reference of this scrollbar.
	 */
	public var bar:MovieClip ;

	/**
	 * The thumb reference of this scrollbar.
	 */
	public var thumb:MovieClip ;

	/**
	 * Draw the component.
	 */	
	public function draw():Void 
	{

		_barPen.clear() ;
		_barPen.lineStyle( 1, 0xFFFFFF, 100, true, LineScaleMode.NONE, CapStyle.SQUARE , JoinStyle.MITER ) ;
		_barPen.beginFill( 0xFF0000 , 100 ) ;
		_barPen.draw(_w, _h) ;		

		var __w:Number = (direction == Direction.HORIZONTAL) ? 20 : _w  ;
		var __h:Number = (direction == Direction.HORIZONTAL) ? _h : 20  ;

		_thumbPen.clear() ;
		_thumbPen.lineStyle( 1, 0x000000, 100, true, LineScaleMode.NONE, CapStyle.SQUARE , JoinStyle.MITER ) ;
		_thumbPen.beginFill( 0x000000 , 100 ) ;
		_thumbPen.draw(__w, __h) ;		

	}
	
	/**
	 * Returns the bar reference of this scrollbar display.
	 * @return the bar reference of this scrollbar display.
	 */
	public function getBar():MovieClip 
	{
		return bar ;
	}

	/**
	 * Returns the thumb reference of this scrollbar display.
	 * @return the thumb reference of this scrollbar display.
	 */
	public function getThumb():MovieClip 
	{
		return thumb ;
	}

	/**
	 * Invoqued when the enabled property of this display is changed.
	 */
	public function viewEnabled():Void  
	{
		bar.enabled = enabled ;
		bar._alpha = enabled ? 100 : 50 ;
		thumb.enabled = enabled ;
		thumb._alpha = enabled ? 100 : 50 ;
	}
	
	private var _barPen:RectanglePen ;

	private var _thumbPen:RectanglePen ;
	
}