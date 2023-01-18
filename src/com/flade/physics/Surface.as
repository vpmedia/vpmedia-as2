/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Surface class
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
import com.flade.physics.ISurface;

/**
 * 	Surface
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 * 	
 * 	@see {ISurface}
 */
class com.flade.physics.Surface implements ISurface
{

	private var p1:Vector;
	private var p2:Vector;
		
	private var isOrientH:Boolean;
	private var normal:Vector;
			
	// some precalculations
	private var rise:Number;
	private var run:Number;
		
	private var invRun:Number;
	private var slope:Number;
	private var invB:Number;
		
	private var dmc:MovieClip;
	private var timeline:MovieClip
	private static var depth:Number = 2000;
	
	
	
	public function Surface (p1:Vector, p2:Vector,ntimeline:MovieClip) 
	{	
		this.p1 = p1;
		this.p2 = p2;
		
		timeline = ntimeline
		isOrientH = true;
		normal = new Vector(0,0);
		calcNormal();
		
		// some precalculations
		rise = p2.y - p1.y;
		run = p2.x - p1.x;
		
		invRun = 1 / run;
		slope = rise / run;
		invB = 1 / (run * run + rise * rise);
	}
	
	private function initMc()
	{
		var drawClipName:String = "surfdrawclip_" + depth;
		dmc = timeline.createEmptyMovieClip (drawClipName, depth);
		dmc.lineStyle(0, 0x222288, 100);
		depth++;
	}
	
	public function setTimeline(t:MovieClip):Void
	{
		timeline = t;
		initMc()
	}
	
	public function setIsOrientH(isOrientH:Boolean) :Void
	{
		this.isOrientH = isOrientH;
	}
	
	
	private function calcNormal():Void
	{
		
		// find normal
		var dx:Number = p2.x - p1.x;
		var dy:Number = p2.y - p1.y;
		
		normal.x = dy 
		normal.y = -dx;
		
		// normalize
		var mag:Number = Math.sqrt (
				(normal.x * normal.x) + 
				(normal.y * normal.y));
				
		normal.x /= mag;
		normal.y /= mag;
	}
	
	public function paint():Void
	{	
		Graphics.paintLine(dmc, p1.x, p1.y, p2.x, p2.y);
	}
	
	
	public function resolveWheelCollision(w:Wheel, sysObj:ParticleSystem) :Void
	{
	
		if (bounds(w.wp.curr, w.contactRadius)) {
			
			// get the closest point on the surface
			getClosestPoint(w.wp.curr,w);

			// get the normal of the circle relative to the location of the closest point
			var circleNormal:Vector = w.closestPoint.minusNew(w.wp.curr);
			circleNormal.normalize();
			
			/*
			 * if the center of the wheel has broken the ground plane
			 * keep the normal from 'flipping' to the opposite direction.
			 * for small wheels, this prevents break-throughs
			 */
			if (inequality(w.wp.curr)) 
			{
				var absCX:Number = Math.abs(circleNormal.x);
				circleNormal.x = (normal.x < 0) ? absCX : -absCX
				circleNormal.y = Math.abs(circleNormal.y);
			}
			
			// get contact point on edge of circle
			var contactPoint:Vector = w.wp.curr.plusNew(circleNormal.mult(w.wr));
	
			if (segmentInequality(contactPoint)) 
			{
	
				// project back
				var dx:Number = contactPoint.x - w.closestPoint.x;
				var dy:Number = contactPoint.y - w.closestPoint.y;
	
				w.wp.curr.x -= dx;
				w.wp.curr.y -= dy;
	
				w.resolve(normal);
			}
		}
	}
	
	
	public function resolveParticleCollision(p:Particle, sysObj:ParticleSystem) :Void
	{
		
		if (boundedSegmentInequality(p.curr)) 
		{
			
			var vel:Vector = p.curr.minusNew(p.prev);
			var sDotV:Number = normal.dot(vel);
	
			if (sDotV < 0) 
			{
				// compute momentum of particle perpendicular to normal
				var velProjection:Vector = vel.minusNew(normal.multNew(sDotV));
				var perpMomentum:Vector = velProjection.multNew(sysObj.coeffFric);
	
				// compute momentum of particle in direction of normal
				var normMomentum:Vector = normal.multNew(sDotV * sysObj.coeffRest);
				var totalMomentum:Vector = normMomentum.plusNew(perpMomentum);
		
				// set new velocity w/ total momentum
				var newVel:Vector = vel.minusNew(totalMomentum);
				
				// project out of collision
				var mirrorPos:Number = normal.dot(p.curr.minusNew(p1)) * sysObj.coeffRest;
				p.curr.minus(normal.multNew(mirrorPos));
	
				// apply new velocity
				p.prev = p.curr.minusNew(newVel);
			}
		}
	}
	
	
	private function segmentInequality(toPoint:Vector) :Boolean
	{
		var u:Number = findU(toPoint);
		var isUnder:Boolean = inequality(toPoint);
		return (u >= 0 && u <= 1 && isUnder);
	}
	
	private function boundedSegmentInequality(toPoint:Vector) :Boolean
	{
		
		var isBound:Boolean;
		if (isOrientH) 
		{
			isBound = ((toPoint.x >= p1.x) && (toPoint.x <= p2.x));
		} else if (p1.y < p2.y) 
		{
			isBound = ((toPoint.y >= p1.y) && (toPoint.y <= p2.y));
		} else 
		{
			isBound = ((toPoint.y <= p1.y) && (toPoint.y >= p2.y));
		}
		
		if (isBound) 
		{
			return inequality(toPoint);
		}
		return false;	
	}
	
	private function inequality (toPoint:Vector) :Boolean
	{	
		// equation of a line
		var line:Number = slope * (toPoint.x - p1.x) + (p1.y - toPoint.y);
		return (line <= 0);
	}
	

	private function bounds(toPoint:Vector, r:Number) :Boolean
	{	
		return ((toPoint.x >= p1.x - r) && (toPoint.x <= p2.x + r));
	}
	
	
	private function getClosestPoint (toPoint:Vector,w:Wheel):Vector
	{
		
		var u:Number = findU(toPoint);
		if (u <= 0) return p1;
		if (u >= 1) return p2;
		
		var x:Number = p1.x + u * (p2.x - p1.x);
		var y:Number = p1.y + u * (p2.y - p1.y);
		
		w.closestPoint.x = x;
		w.closestPoint.y = y;
	}
	
	private function findU (p:Vector):Number 
	{
		var a:Number = (p.x - p1.x) * run + (p.y - p1.y) * rise;
		return a * invB;
	}
}


