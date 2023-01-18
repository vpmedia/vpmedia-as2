/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Particle class
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
 
import com.flade.core.ParticleSystem;
import com.flade.geom.Vector;
import com.flade.util.Graphics
import com.flade.physics.ISurface;

 /**
 * 	Particle
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 */
class com.flade.physics.Particle
{

	public var curr:Vector;
	public var prev:Vector;
	
	private var temp:Vector;
	
	private var timeline:MovieClip;
	private var dmc:MovieClip;
	private static var depth:Number = 1000;

		
	public function Particle(posX:Number, posY:Number,ntimeline:MovieClip) 
	{
		// current and previous positions
		curr = new Vector(posX, posY);
		prev = new Vector(posX, posY);
		temp = new Vector(0,0);
		
		timeline = ntimeline
		var drawClipName:String = "partdrawclip_" + depth;
		dmc = timeline.createEmptyMovieClip (drawClipName, depth);
		
		depth++;
		
	}
	
	public function verlet(sysObj:ParticleSystem) 
	{
		temp.x = curr.x;
		temp.y = curr.y;
	
		curr.x += sysObj.coeffDamp * (curr.x - prev.x) + sysObj.gravity.x;
		curr.y += sysObj.coeffDamp * (curr.y - prev.y) + sysObj.gravity.y;
	
		prev.x = temp.x;
		prev.y = temp.y;
		paint()
	}
	
	public function checkCollision(surface:ISurface, sysObj:ParticleSystem) 
	{
		surface.resolveParticleCollision(this, sysObj);
	}
	
	
	public function paint() 
	{
		dmc.clear();
		dmc.lineStyle(0, 0x666666, 100);
		Graphics.paintCircle(dmc, curr.x, curr.y, 2);
	}
	
	public function setPos(px:Number, py:Number) :Void
	{
		curr.x = px;
		curr.y = py;
		prev.x = px;
		prev.y = py;
	}
	
	public function toString():String
	{
		return "{Particle : "+curr+" }";
	}

}