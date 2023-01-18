/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Point class
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
 
import com.flade.geom.Vector


 /**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.geom.Point extends Vector
{
	
	public var pn:Vector;
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	x	
	 *	@param	y	
	 *	@return	
	 */
	public function Point(x:Number,y:Number) 
	{
		super(x,y);
		pn = new Vector(0,0);//??
	}
	
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	that	
	 *	@return	
	 */
	public function distance (that:Vector):Number 
	{
	    var dx:Number = x - that.x;
	    var dy:Number = y - that.y;
	    return Math.sqrt(dx * dx + dy * dy);
	}
}