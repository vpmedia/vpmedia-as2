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

import pegas.draw.AbstractPen;
import pegas.geom.Line;
import pegas.geom.Point;

/**
 * This pen is the basic tool to draw a line in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.LinePen extends AbstractPen 
{

	/**
	 * Creates a new LinePen instance.
	 */
	public function LinePen(target:MovieClip, isNew:Boolean) 
	{
		initialize(target, isNew) ;
		_pEnd = new Point(0,0) ;
		_pStart = new Point(0,0) ;
	}

	public function get alpha():Number 
	{
		return getAlpha() ;	
	}
	
	public function set alpha(n:Number):Void 
	{
		setAlpha(n) ;	
	}
	
	public function get color():Number 
	{
		return getColor() ;	
	}
	
	public function set color(n:Number):Void 
	{
		setColor(n) ;	
	}

	public function get end():Point 
	{
		return getEnd() ;	
	}
	
	public function set end(p:Point):Void 
	{
		setEnd(p) ;	
	}
	
	public var la:Number = 100 ;

	public var lc:Number = 0x000000 ;
	
	public function get line():Line 
	{
		return getLine() ;	
	}

	public function get start():Point 
	{
		return getStart() ;	
	}
	
	public function set start(p:Point):Void 
	{
		setStart(p) ;	
	}

	public var t : Number = 1 ;

	public function get thickness():Number 
	{
		return getThickness() ;	
	}
	
	public function set thickness(n:Number):Void 
	{
		setThickness(n) ;	
	}

	public function clone() 
	{
		var p:LinePen = new LinePen(_target) ;
		p.setLine(getStart(), getEnd(), getThickness(), getColor(), getAlpha()) ;
		return p ;
	}
	
	public function draw(p_start:Point, p_end:Point, p_thickness:Number, p_color:Number, p_alpha:Number):Void 
	{
		if (arguments.length > 0) 
		{
			setLine.apply(this, arguments) ;
		}
		if (_autoClear) clear () ;
		lineStyle (t, lc, la) ;
		moveTo(_pStart.x, _pStart.y) ;
		lineTo(_pEnd.x, _pEnd.y) ;
	}

	public function getAlpha():Number 
	{ 
		return la ;
	}

	public function getColor():Number 
	{ 
		return lc ;
	}
	
	public function getEnd():Point 
	{
		return _pEnd ;	
	}
	
	public function getLine():Line 
	{
		return Line.getLine(_pStart, _pEnd) ;	
	}

	public function getStart():Point 
	{
		return _pStart ;	
	}

	public function getThickness():Number 
	{
		return t ;	
	}
	
	public function isAutoClear():Boolean 
	{
		return _autoClear ;	
	}

	public function setAlpha(nAlpha:Number, noDraw:Boolean):Void 
	{ 
		la = isNaN(nAlpha) ? default_la : nAlpha ; 
		if (!noDraw) draw() ;	
	}
	
	public function setAutoClear(b:Boolean):Void 
	{
		_autoClear = b ;	
	}
	
	public function setColor(nColor:Number, noDraw:Boolean):Void 
	{ 
		lc = isNaN(nColor) ? default_lc : nColor ; 
		if (!noDraw) draw() ;	
	}

	public function setEnd(p:Point, noDraw:Boolean):Void 
	{
		_pEnd = p ;
		if (!noDraw) draw() ;	
	}
	
	public function setLine(p_start:Point, p_end:Point, p_thickness:Number, p_color:Number, p_alpha:Number):Void 
	{
		if (p_end != null) setEnd(p_end, true) ;
		if (p_start != null) setStart(p_start, true) ;
		if (p_color != null) setColor(p_color, true) ;
		if (p_alpha != null) setAlpha(p_alpha, true) ;
		if (p_thickness != null) setThickness(p_thickness, true) ;
	}

	public function setStart(p:Point, noDraw:Boolean):Void 
	{
		_pStart = p ;
		if (!noDraw) draw() ;	
	}

	public function setThickness(n:Number, noDraw:Boolean):Void 
	{ 
		t = isNaN(n) ? default_t : n ; 
		if (!noDraw) draw() ;	
	}

	private var _autoClear:Boolean ;
	private var _line:Line ;
	private var _pEnd:Point ;
	private var _pStart:Point ;	

}
