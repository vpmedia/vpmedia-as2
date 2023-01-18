/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Wheel class
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

import com.flade.physics.Particle
import com.flade.physics.RimParticle
import com.flade.geom.Vector
import com.flade.util.Graphics;
import com.flade.core.ParticleSystem;
import com.flade.physics.ISurface;

/**
 * 	Wheel
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 */
class com.flade.physics.Wheel
{
	// wheel radius
	public var wr:Number;					
	
	// wheel particle
	public var wp:Particle; 	
	
	// rim particle (radius, max torque)
	public var rp:RimParticle; 	
		
	/*
	*  	contact radius - for checking if in bounds of surface
	* 	by default its the radius, but for smaller wheels
	* 	its a good idea to set this larger than the radius
	*/
	public var contactRadius:Number;				
	
	// 1 = totally slippery, 0 = full friction		
	public var coeffSlip:Number
			
	public var closestPoint:Vector;
	
	private var dmc:MovieClip;
	private var timeline:MovieClip
	private static var depth:Number = 6000
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@param	x	
	 *	@param	y	
	 *	@param	r	
	 *	@return	
	 */
	public function Wheel(x:Number, y:Number, r:Number,ntimeline:MovieClip) 
	{
		wr = r;						
		wp = new Particle(x, y); 		
		rp = new RimParticle(r, 7); 
		contactRadius = r;	
		coeffSlip = 0.0;				
		closestPoint = new Vector(0,0);
		
		timeline = ntimeline
		var drawClipName:String = "wheeldrawclip_" + depth;
		dmc = timeline.createEmptyMovieClip(drawClipName, depth);
		depth++;
		
		//trace(this);
	}
	
	/**
	 *	
	 *	@usage	
	 *	@param	sysObj	
	 *	@return	
	 */
	public function verlet(sysObj:ParticleSystem):Void 
	{
		rp.verlet(sysObj);
		wp.verlet(sysObj);
	}
		
	public function checkCollision(surface:ISurface, sysObj:ParticleSystem) :Void
	{
		surface.resolveWheelCollision(this);
	}
	
	
	public function paint() 
	{
		// draw wheel circle
		var px:Number = wp.curr.x;
		var py:Number = wp.curr.y;
		var rx:Number = rp.curr.x;
		var ry:Number = rp.curr.y;
		
		dmc.clear();
		dmc.lineStyle(1, 0x222288, 100);
		Graphics.paintCircle(dmc, px, py, wr);
			
		// draw rim cross
		dmc.lineStyle(0, 0x999999, 100);
		Graphics.paintLine(dmc, rx + px, ry + py, px, py);
		Graphics.paintLine(dmc, -rx + px, -ry + py, px, py);
		Graphics.paintLine(dmc, -ry + px, rx + py, px, py);
		Graphics.paintLine(dmc, ry + px, -rx + py, px, py);
	}
	
	/**
	 *	simulates torque/wheel-gound interaction
	 *	@param	n 	the surface normal	
	 */
	public function resolve(n:Vector) 
	{
			
		//var wp_tmp:Particle = wp;
		//var rp_tmp:RimParticle = rp;
		
		// this is the tangent vector at the rim particle
		var rx:Number = -rp.curr.y;
		var ry:Number = rp.curr.x;
		
		// normalize so we can scale by the rotational speed
		var len:Number = Math.sqrt(rx * rx + ry * ry);
		rx /= len;
		ry /= len;
		
		// sx,sy is the velocity of the wheel's surface relative to the wheel
		var sx:Number = rx * rp.speed;
		var sy:Number = ry * rp.speed;
		
		// tx,ty is the velocity of the wheel relative to the world
		var tx:Number = wp.curr.x - wp.prev.x;
		var ty:Number = wp.curr.y - wp.prev.y;
		
		// vx,vy is the velocity of the wheel's surface relative to the ground
		var vx:Number = tx + sx;
		var vy:Number = ty + sy;
		
		// dp is the the wheel's surfacevel projected onto the ground's tangent
		var dp:Number = - n.y * vx + n.x * vy;
		
		// set the wheel's spinspeed to track the ground
		rp.prev.x = rp.curr.x - dp * rx;
		rp.prev.y = rp.curr.y - dp * ry;
		
		// some of the wheel's torque is removed and converted into linear displacement
		var w0:Number = 1 - coeffSlip;
		wp.curr.x += w0 * rp.speed * -n.y;
		wp.curr.y += w0 * rp.speed * n.x;
		
		rp.speed *= coeffSlip;
	}
	
	public function toString():String
	{
		return "[ Wheel |"+ wp +" | "+rp+"]";
	}

}