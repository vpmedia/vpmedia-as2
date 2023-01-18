/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * ParticleSystem class
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
 import com.flade.physics.Wheel
 import com.flade.physics.Constraint
 import com.flade.physics.ISurface
 import com.flade.physics.Surface
 import com.flade.physics.AngularConstraint
 import com.flade.physics.Rectangle
 import com.flade.geom.Vector
 
 /**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.core.ParticleSystem
{
	
	private  var particles:Array
	private var surfaces:Array;
	private var constraints:Array
	private var wheels:Array;
	
	// default values
	public var gravity:Vector
	public var coeffRest:Number
	// surface friction
	public var coeffFric:Number
	// global damping
	public var coeffDamp:Number
		
	public var scope:MovieClip;
	
	public function ParticleSystem(s:MovieClip) 
	{
		
		particles = new Array();
		surfaces = new Array();
		constraints = new Array();
		wheels = new Array();
		
		// default values
		gravity = new Vector(0,1);	
		coeffRest = 1 + 0.5;
		coeffFric = 0.01;	
		coeffDamp = 0.99; 	
		scope = s;
	}


	public function addParticle(px:Number, py:Number) :Particle
	{
		var p:Particle = new Particle(px, py,scope);
		particles.push(p);
		return p;
	}


	public function addWheel(px:Number, py:Number, r:Number) :Wheel
	{
		var w:Wheel = new Wheel(px, py, r,scope);
		wheels.push(w);
		return w;
	}


	public function addSurface(s:ISurface) :Void
	{
		s.setTimeline(scope);
		surfaces.push(s);
	}


	public function addConstraint(p1:Particle, p2:Particle):Constraint 
	{
		var c:Constraint = new Constraint(p1, p2,scope);
		constraints.push(c);
		return c;
	}
	
	
	public function addAngularConstraint(p1:Particle, p2:Particle, p3:Particle):AngularConstraint 
	{
		var ac:AngularConstraint = new AngularConstraint(p1, p2, p3);
		constraints.push(ac);
		return ac;
	}
	
	
	public function setKfr(kfr:Number) :Void
	{
		coeffRest = 1 + kfr;
	}
	
	
	public function setFriction(f:Number) :Void
	{
		coeffFric = f;
	}
	
	
	public function setDamping(d:Number) :Void
	{
		coeffDamp = d;
	}
	
	
	public function setGravity(gx:Number, gy:Number) :Void
	{
		gravity.x = gx;
		gravity.y = gy;
	}
	
	
	public function addRectangle(center:Vector, rWidth:Number, rHeight:Number):Rectangle
	{
		return new Rectangle(this, center, rWidth, rHeight);
	}
	
	
	public function verlet()
	{
		for (var i:Number = 0; i < particles.length; i++) {
			particles[i].verlet(this);		
		}
		for (var k:Number = 0; k < wheels.length; k++) {
			wheels[k].verlet(this);		
		}
	
	}
	
	
	public function satisfyConstraints() 
	{
		for (var n:Number = 0; n < constraints.length; n++) 
		{
			constraints[n].resolve();
		}
	}
	
	
	public function checkCollisions() :Void
	{
		for (var j:Number = 0; j < surfaces.length; j++) 
		{
			var s:Surface = surfaces[j];
		
			for (var i:Number = 0; i < particles.length; i++) {
				var p:Particle = particles[i];		
				p.checkCollision(s, this);
			}
			
			for (var k:Number = 0; k < wheels.length; k++) {
				var w:Wheel = wheels[k];		
				w.checkCollision(s, this);
			}
		}
	}
	
	
	public function paintSurfaces() :Void
	{
		for (var j:Number = 0; j < surfaces.length; j++) 
		{
			surfaces[j].paint();
		}
	}
	
	
	public function paintParticles() :Void
	{
		for (var j:Number = 0; j < particles.length; j++) 
		{
			particles[j].paint();
		}
	}
	
	
	public function paintConstraints() :Void
	{
		for (var j:Number = 0; j < constraints.length; j++) 
		{
			constraints[j].paint();
		}
	}
	
	public function paintWheels() :Void
	{
		for (var j:Number = 0; j < wheels.length; j++) 
		{
			wheels[j].paint();
		}
	}
	
	
	public function timeStep() :Void
	{
		verlet();
		satisfyConstraints();
		checkCollisions();
	}	
}



