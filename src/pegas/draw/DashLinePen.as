/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.draw.LinePen;
import pegas.geom.Point;

/**
 * This pen is the basic tool to draw a dash line in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.DashLinePen extends LinePen 
{

	/**
	 * Creates a new DashLinePen instance.
	 */
	public function DashLinePen(target:MovieClip, isNew:Boolean) 
	{
		super(target, isNew) ;
	}

	public var default_length:Number = 2 ;
	
	public var default_spacing:Number = 2 ;

	public function get length():Number {
		return getLength() ;	
	}
	
	public function set length(n:Number):Void {
		setLength(n) ;	
	}

	public function get spacing():Number {
		return getSpacing() ;	
	}
	
	public function set spacing(n:Number):Void {
		setSpacing(n) ;	
	}
	

	public function clone() 
	{
		var p:DashLinePen = new DashLinePen(_target) ;
		p.setLine(getStart(), getEnd(), getThickness(), getColor(), getAlpha(), getLength(), getSpacing()) ;
		return p ;
	}
	
	public function draw
	(
	
		p_start:Point, p_end:Point, 
		p_thickness:Number, p_color:Number,
		p_alpha:Number, p_length:Number, p_spacing:Number
	
	):Void 
	{
		
		if (arguments.length > 0) setLine.apply(this, arguments) ;
		
		var s:Point = _pStart ;
		var e:Point = _pEnd ;
		var segl:Number = getLength() + getSpacing() ;
		if (isNaN(segl)) segl = 0 ;
		var dx:Number = e.x - s.x ;
		var dy:Number = e.y - s.y ;
		var delta = Math.sqrt((dx * dx) + (dy * dy));
		var nbSegs:Number = Math.floor(Math.abs(delta / segl)) ;
		__radians = Math.atan2 ( dy, dx ) ;
		__x = s.x;
		__y = s.y;
		dx = Math.cos(__radians)* segl ;
		dy = Math.sin(__radians)* segl ;
		if (_autoClear) clear () ;
		lineStyle (t, lc, la) ;
		for (var i:Number = 0; i < nbSegs; i++) {
			moveTo( __x, __y ) ;
			_lineRadiansTo ( _length ) ;
			__x += dx ;
			__y += dy ;
		}
		moveTo(__x, __y) ; 
		delta = Math.sqrt((e.x - __x)*(e.x - __x)+ (e.y - __y)* (e.y - __y)) ;
		if(delta>_length) _lineRadiansTo ( _length ) ;
		else if (delta > 0) _lineRadiansTo ( delta ) ;
		moveTo(e.x, e.y);
	}

	public function getLength():Number
	{ 
		return _length ;
	}

	public function getSpacing():Number 
	{ 
		return _spacing ;
	}

	public function setLength(n:Number, noDraw:Boolean):Void 
	{
		_length = isNaN(n) ? default_length : n ; 
		if (!noDraw) draw() ;	
	}

	public function setLine
	(
		p_start:Point, p_end:Point, 
		p_thickness:Number, p_color:Number, p_alpha:Number, 
		p_length:Number, p_spacing:Number 
	):Void 
	{
		super.setLine(p_start, p_end, p_thickness, p_color, p_alpha) ;
		if (!isNaN(p_length)) setLength(p_length, true) ;
		if (!isNaN(p_spacing)) setSpacing(p_spacing, true) ;
	}

	public function setSpacing(n:Number, noDraw:Boolean):Void { 
		_spacing = isNaN(n) ? default_spacing : n ; 
		if (!noDraw) draw() ;	
	}

	private var _length:Number = 2 ;
	private var __radians:Number ; 
	private var _spacing:Number = 2 ;
	private var __x:Number ;
	private var __y:Number ;
	
	private function _lineRadiansTo ( n:Number ) : Void 
	{
		lineTo ( __x + Math.cos(__radians) * n ,  __y + Math.sin(__radians) * n ) ;
	}
}
