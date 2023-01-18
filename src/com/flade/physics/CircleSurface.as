/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * CircleSurface class
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
import com.flade.geom.Vector;
import com.flade.util.Graphics;
import com.flade.physics.Wheel;
import com.flade.core.ParticleSystem;
import com.flade.physics.ISurface

/**
 * 	CircleSurface
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 * 	
 * 	@see {ISurface}
 */
 
class com.flade.physics.CircleSurface implements ISurface
{
	public var cx:Number
	public var cy:Number
	public var r:Number
		
	private var dmc:MovieClip;
	private var timeline:MovieClip;
	private static var depth:Number = 9000;
	
	public function CircleSurface(cx:Number, cy:Number, r:Number) 
	{
		this.cx = cx;
		this.cy = cy;
		this.r = r;
	}


	private function initMc()
	{
		var drawClipName:String = "circsurfdrawclip_" + depth;
		dmc = timeline.createEmptyMovieClip (drawClipName, depth);
		dmc.lineStyle(0, 0x222288, 100);
		depth++;
	}
	
	public function setTimeline(t:MovieClip):Void
	{
		timeline = t;
		initMc()
	}
	
	public function paint() :Void
	{
		Graphics.paintCircle(dmc, cx, cy, r);
	}

	public function resolveWheelCollision(w:Wheel, sysObj:ParticleSystem) :Void
	{
		var dx:Number = cx - w.wp.curr.x;
		var dy:Number = cy - w.wp.curr.y;
		var len:Number = Math.sqrt(dx * dx + dy * dy);
		var pen:Number = (w.wr + r) - len;
		
		if (pen > 0) 
		{
			dx /= len;
			dy /= len;
			w.wp.curr.x -= dx * pen;
			w.wp.curr.y -= dy * pen;
	
			var wheelNormal:Vector = new Vector(-dx, -dy);
			w.resolve(wheelNormal);
		}
	}

	public function resolveParticleCollision(p:Particle, sysObj:ParticleSystem) :Void
	{
		// TBD: move to constructor, and change constructor args
		var circleCenter:Vector = new Vector(cx, cy);
		var dist:Number = circleCenter.distance(p.curr);
		
		// test if point is within circle
		if (dist <= r) 
		{	
			// get the normal of the surface relative to the location of the point
			var surfaceNormal:Vector = (p.curr.minusNew(circleCenter)).normalize();
		
			// project out to surface of circle 
			var surfacePos:Vector = circleCenter.plusNew(surfaceNormal.multNew(r));
			p.curr = surfacePos;
		}
	}
}





