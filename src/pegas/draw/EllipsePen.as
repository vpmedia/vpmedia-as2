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

import pegas.draw.Align;
import pegas.draw.EasyPen;

/**
 * This pen draw an ellipse shape in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.EllipsePen extends EasyPen 
{
	
	/**
	 * Creates a new EllipsePen instance.
	 */
	public function EllipsePen(target : MovieClip, isNew : Boolean) 
	{
		super(target, isNew);
	}
	
	/**
	 * This constant defines the theta value used in internal in all method of this pen.
	 */
	static public var THETA:Number = Math.PI/4;
	
	/**
	 * Defines the height of this shape.
	 */
	public var h:Number ;

	/**
	 * Defines the width of this shape.
	 */
	public var w:Number ;

	/**
	 * Defines the x origin coordinate of this shape.
	 */
	public var x:Number ;

	/**
	 * Defines the y origin coordinate of this shape.
	 */
	public var y:Number ;
	
	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone()
	{
		var pen:EllipsePen = new EllipsePen(getTarget()) ;
		pen.setPen(x, y, w, h) ;
		return pen ;
	}

	/**
	 * Draws the shape in the movieclip reference of this pen.
	 */
	public function draw( nX:Number, nY:Number, nWidth:Number, nHeight:Number, nAlign:Number):Void
	{
		if (arguments.length > 0) 
		{
			setPen(nX, nY, nWidth, nHeight, nAlign) ;
		}
		
		var radius:Number = w / 2 ;
		var yradius:Number = (h == null) ? radius : (h/2) ;
		
		var xrCtrl:Number = radius / Math.cos( THETA / 2 );
		var yrCtrl:Number = yradius /Math.cos( THETA / 2 );
		
		var angle:Number = 0 ;
		var angleMid:Number ;
		
		var cx:Number ;
		var cy:Number ;
		var px:Number ;
		var py:Number ;
		
		moveTo( x + radius , y ) ;
		
		for (var i:Number = 0; i<8; i++) 
		{
			// increment our angles
			angle += THETA ;
			angleMid = angle - ( THETA / 2 );
			// calculate our control point
			cx = x + Math.cos(angleMid) * xrCtrl;
			cy = y + Math.sin(angleMid) * yrCtrl;
			
			px = x + Math.cos(angle) * radius ;
			py = y + Math.sin(angle) * yradius ;
			
			curveTo(cx, cy, px, py) ;
		}
		if (isEndFill) endFill() ;	
		
	}

	/**
	 * Sets the ellipse options to defined all values to draw the ellipse shape in the movieclip reference of this pen.
	 */
	public function setPen(nX:Number, nY:Number, nWidth:Number, nHeight:Number, nAlign:Number):Void
	{
		
		if (!isNaN(nAlign)) setAlign(nAlign, true) ;
		
		x = isNaN(nX) ? 0 : nX ;
		y = isNaN(nY) ? 0 : nY ;
		
		w = isNaN(nWidth) ? 0 : nWidth ;
		h = isNaN(nHeight) ? null : nHeight ;

		var a:Number = getAlign() ;

		if (a == Align.CENTER) 
		{
			
		}
		else if (a == Align.BOTTOM) 
		{
			this.y -= h / 2 ;
		}
		else if (a == Align.BOTTOM_LEFT) 
		{
			this.x += w / 2 ;
			this.y -= h / 2 ;
		}
		else if (a == Align.BOTTOM_RIGHT) 
		{
			this.x -= w / 2 ;
			this.y -= h / 2 ;
		}
		else if (a == Align.LEFT) 
		{
			this.x += w / 2 ;
		}
		else if (a ==  Align.RIGHT) 
		{
			this.x -= w / 2 ;
		}
		else if (a == Align.TOP) 
		{
			this.y += h / 2 ;
		}
		else if (a == Align.TOP_RIGHT) 
		{
			this.x -= w / 2 ;
			this.y += h / 2 ;
		}
		else // TOP_LEFT
		{
			this.x += w / 2 ;
			this.y += h / 2 ;
		}
		
	}

}