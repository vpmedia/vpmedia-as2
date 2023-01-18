/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Vector class
 * Copyright 2004, 2005 Alec Cove
 * 
 * This file is part of Flade. The Flash Dynamics Engine. 
 *	
 * Flade is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Flade is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Flade; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Flash is a registered trademark of Macromedia
 */

/**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.geom.Vector
{
 
	public var x:Number;
	public var y:Number;
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	x	
	 *	@param	y	
	 *	@return	
	 */
	public function Vector(x:Number,y:Number) 
	{
		this.x = x;
		this.y = y;
	}

	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function dot(v:Vector) :Number
	{
		return x * v.x + y * v.y;
	}

	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function cross(v:Vector) :Number
	{
		return x * v.y - y * v.x;
	}

	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function plus(v:Vector) :Vector
	{
		this.x += v.x;
		this.y += v.y;
		return this;
	}

	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function plusNew(v:Vector) :Vector
	{
		return new Vector(x + v.x, y + v.y); 
	}

	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function minus(v:Vector) :Vector
	{
		x -= v.x;
		y -= v.y;
		return this;
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	v	
	 *	@return	
	 */
	public function minusNew(v:Vector) :Vector
	{
		return new Vector(x - v.x, y - v.y);    
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	s	
	 *	@return	
	 */
	public function mult(s:Number) :Vector
	{
		x *= s;
		y *= s;
		return this;
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	s	
	 *	@return	
	 */
	public function multNew(s:Number) :Vector
	{
		return new Vector (x * s, y * s);
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	p	
	 *	@return	
	 */
	public function distance(p:Vector) :Number
	{
	    var dx:Number = x - p.x;
	    var dy:Number = y - p.y;
	    return Math.sqrt(dx * dx + dy * dy);
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@return	
	 */
	public function normalize():Vector
	{
	   var mag:Number = Math.sqrt(x * x + y * y);
	   x /= mag;
	   y /= mag;
	   return this;
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@return	
	 */
	public function toString():String
	{
		return "{ "+x+" : "+y+" }"
	}
}