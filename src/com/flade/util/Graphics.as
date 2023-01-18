/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Graphics class
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
class com.flade.util.Graphics
{
	
	public static function paintLine(dmc:MovieClip, x0:Number, y0:Number, x1:Number, y1:Number) :Void
	{
		dmc.moveTo(x0, y0);
		dmc.lineTo(x1, y1);
	}
	
	
	public static function paintCircle (dmc:MovieClip, x:Number, y:Number, r:Number) 
	{
		
		var mtp8r:Number = Math.tan(Math.PI/8) * r;
		var msp4r:Number = Math.sin(Math.PI/4) * r;
		
		dmc.moveTo(x + r, y);
		dmc.curveTo(r + x, mtp8r + y, msp4r + x, msp4r + y);
		dmc.curveTo(mtp8r + x, r + y, x, r + y);
		dmc.curveTo(-mtp8r + x, r + y, -msp4r + x, msp4r + y);
		dmc.curveTo(-r + x, mtp8r + y, -r + x, y);
		dmc.curveTo(-r + x, -mtp8r + y, -msp4r + x, -msp4r + y);
		dmc.curveTo(-mtp8r + x, -r + y, x, -r + y);
		dmc.curveTo(mtp8r + x, -r + y, msp4r + x, -msp4r + y);
		dmc.curveTo(r + x, -mtp8r + y, r + x, y);
	}
}