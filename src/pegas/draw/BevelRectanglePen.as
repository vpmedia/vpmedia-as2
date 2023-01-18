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
 * This pen is the basic tool to draw a rectangle with bevel corners in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.BevelRectanglePen extends CornerRectanglePen 
{

	/**
	 * Creates a new BevelRectanglePen instance.
	 */
	public function BevelRectanglePen(target:MovieClip, isNew:Boolean) 
	{
		initialize(target, isNew) ;
	}

	/**
	 * (read-write) Returns the hBevel value who defined the horizontal bevel level of all corners in this BevelRectangle pen.
	 * @return the hBevel value who defined the bevel horizontal bevel level of all corners in this BevelRectangle pen.
	 */
	public function get hBevel():Number 
	{
		return getHBevel() ;	
	}

	/**
	 * (read-write) Sets the hBevel value who defined the horizontal bevel level of all corners in this BevelRectangle pen.
	 */
	public function set hBevel(n:Number):Void 
	{
		setHBevel(n) ;	
	}

	/**
	 * (read-write) Returns the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 * @return the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 */
	public function get vBevel():Number 
	{
		return getVBevel() ;	
	}

	/**
	 * (read-write) Sets the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 */
	public function set vBevel(n:Number):Void 
	{
		setVBevel(n) ;	
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var rec:BevelRectanglePen = new BevelRectanglePen(_target) ;
		rec.setRectangle(w, h, x, y, getAlign(), getHBevel(), getVBevel()) ;
		return rec ;
	}

	/**
	 * Draws the shape in the movieclip reference of this pen.
	 */
	public function draw(p_w:Number, p_h:Number, p_x:Number, p_y:Number, p_align:Number, p_hBevel:Number, p_vBevel:Number, corner:Corner):Void 
	{
		
		if (arguments.length > 0) setRectangle.apply(this, arguments) ;
		
		var hb:Number = getHBevel() ;
		var vb:Number = getVBevel() ;
		
		if (hb > 0 && vb > 0) {
			
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
			
			moveTo ( nX + hb , nY) ;
			if (tr) 
			{
				lineTo( nW - hb , nY) ;
				lineTo( nW , nY + vb ) ;
			}
			else 
			{
				lineTo( nW , nY ) ;
			}
			if (br) 
			{
				lineTo( nW , nH - vb ) ;
				lineTo( nW - hb , nH) ;		
			}
			else 
			{
				lineTo( nW , nH ) ;
			}
			if (bl) 
			{
				lineTo( nX  + hb, nH ) ;
				lineTo( nX  ,  nH - vb ) ;
			}
			else 
			{
				lineTo( nX , nH ) ;
			}
			if (tl) 
			{
				lineTo( nX , nY + vb) ;
				lineTo( nX + hb, nY);
			}
			else 
			{
				lineTo( nX , nY ) ;
			}
			if (isEndFill) 
			{
				endFill() ;
			}	
		} 
		else 
		{
			super.draw.apply(this) ;
		}

	}

	/**
	 * Returns the hBevel value who defined the horizontal bevel level of all corners in this BevelRectangle pen.
	 * @return the hBevel value who defined the bevel horizontal bevel level of all corners in this BevelRectangle pen.
	 */
	public function getHBevel():Number 
	{
		return (_hBevel <= w ) ? _hBevel : 0 ;
	}

	/**
	 * Returns the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 * @return the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 */
	public function getVBevel():Number 
	{
		return (_vBevel <= h ) ? _vBevel : 0 ;
	}

	/**
	 * Sets the hBevel value who defined the horizontal bevel level of all corners in this BevelRectangle pen.
	 */
	public function setHBevel(n:Number, noDraw:Boolean):Void 
	{
		_hBevel = ( n>0 ) ? n : 0 ; 
		if (!noDraw) draw();
	}
	
	/**
	 * Sets the rectangle options to draw the shape.
	 */
	public function setRectangle(p_w:Number, p_h:Number, p_x:Number, p_y:Number, p_align:Number, p_hBevel:Number, p_vBevel:Number, p_corner:Corner):Void 
	{
		super.setRectangle(p_w, p_h, p_x, p_y, p_align) ;
		if (!isNaN(p_hBevel)) 
		{
			setHBevel(p_hBevel, true) ;
		}
		if (!isNaN(p_vBevel)) 
		{
			setHBevel(p_vBevel, true) ;
		}
		if (p_corner) 
		{
			setCorner(p_corner, true) ;
		}
	}

	/**
	 * Sets the vBevel value who defined the vertical bevel level of all corners in this BevelRectangle pen.
	 */
	public function setVBevel(n:Number, noDraw:Boolean):Void 
	{
		_vBevel = (n>0) ? n : 0 ; 
		if (!noDraw) draw();
	}	
	

	private var _hBevel:Number = 10 ;
	
	private var _vBevel:Number = 15 ;
	
}