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

import lunas.display.abstract.AbstractProgressbarDisplay;

import pegas.draw.RectanglePen;

/**
 * The EasyProgressbarDisplay component display.
 * @author eKameleon
 */
class lunas.display.bar.EasyProgressbarDisplay extends AbstractProgressbarDisplay 
{

	/**
	 * Creates a new EasyProgressbarDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	public function EasyProgressbarDisplay(sName:String, target:MovieClip ) 
	{ 
		
		super ( sName, target ) ;
		
		background = view.createEmptyMovieClip( "background", 0 ) ;
		bar        = view.createEmptyMovieClip( "bar", 1 ) ;
		
		_backgroundPen = new RectanglePen(background) ;
		_barPen        = new RectanglePen(bar) ;
		
		setSize(150, 6) ;
		
	}

	/**
	 * The background reference of this bar
	 */
	public var background:MovieClip ;

	/**
	 * The thumb reference of this bar.
	 */
	public var bar:MovieClip ;

	/**
	 * The border thickness of this bar.
	 */
	public var border:Number = 0 ;

	/**
	 * Resize the bar.
	 */
	public function resize():Void 
	{
		
		bar._x = border ;
		bar._y = border ;
		
		var nB:Number = 2 * border ;
		var nD:Number = getDirection() ;
		
		var max:Number = (nD == Direction.VERTICAL) ? getH() : getW() ;
		var size:Number =  Math.floor(getPosition() * (max - nB) / 100) ;
		
		var __w:Number = (nD == Direction.VERTICAL) ? ( _w - nB ) : size  ;
		var __h:Number = (nD == Direction.VERTICAL) ? size : (_h - nB) ;
	
		_barPen.clear() ;
		_barPen.lineStyle( 1, 0xFFFFFF, 100, true, LineScaleMode.NONE, CapStyle.SQUARE , JoinStyle.MITER ) ;
		_barPen.beginFill( 0xEEED55 , 100 ) ;
		_barPen.draw(__w, __h) ;
		
	}

	/**
	 * Invoqued when the component is changed.
	 */
	public function viewChanged():Void 
	{
		
		_backgroundPen.clear() ;
		_backgroundPen.lineStyle( 1 , 0xFFFFFF , 100,  true, LineScaleMode.NONE, CapStyle.SQUARE , JoinStyle.MITER) ;
		_backgroundPen.beginFill( 0xD0330D , 100 ) ;
		_backgroundPen.draw(_w, _h) ;

		resize() ;
		
	}
	
	/**
	 * Invoqued when the position of the bar is changed.
	 */
	public function viewPositionChanged():Void 
	{
		resize() ;
	}
	
	private var _backgroundPen:RectanglePen ;
	
	private var _barPen:RectanglePen ;

}