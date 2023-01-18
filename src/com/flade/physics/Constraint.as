/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Constraint class
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
 
import com.flade.physics.Particle;
import com.flade.util.Graphics;
import com.flade.geom.Vector;
import com.flade.physics.IConstraint;
/**
 * 	Constaint
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 */
class com.flade.physics.Constraint implements IConstraint
{
	private var p1:Particle;
	private var p2:Particle;
	
	private var restLength:Number;
	
	private var dmc:MovieClip;
	private var timeline:MovieClip
	private static var depth:Number = 3000;
	
	public function Constraint(p1:Particle, p2:Particle,ntimeline:MovieClip) 
	{
		this.p1 = p1;
		this.p2 = p2;
		restLength = p1.curr.distance(p2.curr);
		
		timeline = ntimeline;
		var drawClipName:String = "constdrawclip_" + depth;
		dmc = timeline.createEmptyMovieClip (drawClipName, depth);
		
		depth++;
		//trace(this)
	}
	
	public function resolve() :Void
	{
		var delta:Vector = p1.curr.minusNew(p2.curr);
		var deltaLength:Number = p1.curr.distance(p2.curr);
		
		var diff:Number = (deltaLength - restLength) / deltaLength;
		var dmd:Vector = delta.mult(diff * 0.5);
				
		p1.curr.minus(dmd);
		p2.curr.plus(dmd);
	}
	
	
	public function setRestLength(r:Number) 
	{
		restLength = r;
	}
	
	
	public function paint() :Void
	{
		dmc.clear();
		dmc.lineStyle(0, 0xFF0000, 100);
		
		Graphics.paintLine(dmc, p1.curr.x, p1.curr.y, p2.curr.x, p2.curr.y);
	}
	
	public function toString():String
	{
		return "[Constraint p1 :"+p1+"| p2: "+p2+" ]"
	}
}

