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

import pegas.draw.Corner;
import pegas.draw.CornerRectanglePen;
import pegas.geom.Rectangle;

/**
 * This pen is the basic tool to draw a rectangle with rounded corners in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.RoundedRectanglePen extends CornerRectanglePen 
{

	/**
	 * Creates a new RoundedRectanglePen instance.
	 */
	public function RoundedRectanglePen(target:MovieClip, isNew:Boolean) 
	{
		initialize(target, isNew) ;
	}

	/**
	 * (read-write) Returns the round value of the rounded corner of this rectangle pen.
	 * @return the round value of the rounded corner of this rectangle pen.
	 */
	public function get round():Number 
	{
		return getRound() ;	
	}
	
	/**
	 * Sets the round value of the rounded corner of this rectangle pen.
	 */
	public function set round(n:Number):Void 
	{
		setRound(n) ;	
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var rec:RoundedRectanglePen = new RoundedRectanglePen(_target) ;
		rec.setRectangle(w, h, x, y, getAlign(), getRound()) ;
		return rec ;
	}

	/**
	 * Draws the shape in the movieclip reference of this pen.
	 */
	public function draw(p_w:Number, p_h:Number, p_x:Number, p_y:Number, p_align:Number, p_round:Number, corner:Corner):Void 
	{
		
		if (arguments.length > 0) setRectangle.apply(this, arguments) ;
		
		if (_round > 0) 
		{
			
			var r:Rectangle = getRectangle() ;
			var nX:Number = r.x ;
			var nY:Number = r.y ;
			var nW:Number = nX + r.width ;
			var nH:Number = nY + r.height ;
			var c:Corner = getCorner() ;
			var tr:Boolean = c.getTr() ;
			var br:Boolean = c.getBr() ;
			var bl:Boolean = c.getBl() ;
			var tl:Boolean = c.getTl() ;
			
			_currentRadius  = (_round > (Math.min (w, h) / 2) ) ? (Math.max (w, h) / 2) : _round  ;

			moveTo( nX + _currentRadius, nY);
			lineTo( nW - _currentRadius , nY) ;
			if (tr) 
			{
				drawCorner (nW - _currentRadius , nY + _currentRadius) ;
			}
			else 
			{
				lineTo( nW , nY ) ;
				lineTo( nW , nY + _currentRadius) ;
				simulateCorner () ;
			}
			lineTo ( nW , nH - _currentRadius ) ;
			if (br) 
			{
				drawCorner ( nW - _currentRadius, nH - _currentRadius) ;
			}
			else 
			{
				lineTo ( nW , nH ) ;
				lineTo ( nW - _currentRadius , nH ) ;
				simulateCorner () ;	
			}
			lineTo( nX  + _currentRadius , nH ) ;
			if (bl) 
			{
				drawCorner ( nX + _currentRadius , nH - _currentRadius) ;
			}
			else 
			{
				lineTo( nX , nH ) ;
				lineTo( nX  , nH - _currentRadius ) ;
				simulateCorner () ;	
			}
			lineTo( nX, nY + _currentRadius) ;
			if (tl) 
			{
				drawCorner( nX + _currentRadius, nY + _currentRadius) ;
			}
			else 
			{
				lineTo( nX , nY ) ;
			}
			if (isEndFill) endFill() ;	
			_angle = null ;
			
		} 
		else 
		{
			super.draw.apply(this) ;
		}

	}
	
	/**
	 * This internal method draw a corner in a specific position with the specified coordinates.
	 * @param x the horizontal coordinate.
	 * @param y the vertical coordinate.
	 */
	public function drawCorner (x:Number, y:Number):Void
	{ 
		curve (x,y) ; 
		curve (x,y) ;
	}
	
	/**
	 * Draw a curve to draw the rounded corners of this rectangle.
	 */
	public function curve(x:Number , y:Number ):Void 
	{
		var cx, cy, px, py :Number  ;
		_angle = ( isNaN(_angle)) ? (- Math.PI / 2) : (_angle + _theta) ;
		cx =  x + ( Math.cos ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos ( _theta / 2 ) );
		cy = y +  ( Math.sin ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos( _theta / 2 ) ) ;
		px = x  + ( Math.cos (_angle + _theta) * _currentRadius ) ;
		py = y  + ( Math.sin ( _angle + _theta ) * _currentRadius ) ;
		curveTo (cx, cy, px, py);
	}

	/**
	 * Returns the round value of the rounded corner of this rectangle pen.
	 * @return  the round value of the rounded corner of this rectangle pen.
	 */
	public function getRound():Number 
	{
		return _round ;
	}

	/**
	 * Sets the rectangle options to draw the shape.
	 */
	public function setRectangle(p_w:Number, p_h:Number, p_x:Number, p_y:Number, p_align:Number, p_rnd:Number, p_corner:Corner):Void 
	{
		super.setRectangle(p_w, p_h, p_x, p_y, p_align) ;
		if (!isNaN(p_rnd)) setRound(p_rnd, true) ;
		if (p_corner) setCorner(p_corner, true) ;
	}

	/**
	 * Sets the round value of the rounded corner of this rectangle pen.
	 */
	public function setRound(n:Number, noDraw:Boolean):Void 
	{
		_round = isNaN(n) ? 0 : n ;
		if (!noDraw) draw() ;
	}

	/**
	 * Internal method who simulates the draw of a corner if a corner is disabled with the corner property.
	 */
	public function simulateCorner () 
	{
		_angle = ( ( isNaN(_angle) ) ? (- Math.PI / 2) : (_angle + _theta) ) + _theta ;
	}

	private var _angle:Number ;
	private var _currentRadius:Number ;
	private var _round:Number  ;
	private var _theta:Number = Math.PI/4 ;
	
}