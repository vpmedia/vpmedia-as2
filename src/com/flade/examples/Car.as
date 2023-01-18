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
 
import com.flade.core.ParticleSystem;
import com.flade.physics.Surface;
import com.flade.geom.Vector;
import com.flade.physics.Wheel;
import com.flade.physics.Rectangle;
import com.flade.physics.Constraint;
import com.flade.physics.Particle;
import com.flade.physics.CircleSurface;
import com.flade.app.Application;

/**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.examples.Car extends Application
{
	private var psystem:ParticleSystem;
	private var wheelA:Wheel ;
	private var wheelB:Wheel ;
		
	public function Car(s:MovieClip)
	{
		super(s);
		init();
	}
	
	public function init()
	{
		psystem = new ParticleSystem(scope);
		psystem.setDamping(0.99);
		psystem.setGravity(0.0, 0.4);
		
		// cooefficient of restitution
		psystem.setKfr(0.1);
		
		// surface friction for particles
		psystem.setFriction(0.5);
	
		createSurface();
		createCar();
	}

	private function createSurface()
	{
		// surfaces		
		psystem.addSurface(new Surface(new Vector(1, 300), new Vector(400, 300)));
		//psystem.addSurface(new Surface(new Vector(100, 300), new Vector(300, 300)));
		//psystem.addSurface(new Surface(new Vector(300, 300), new Vector(400, 350)));
		//psystem.addSurface(new Surface(new Vector(400,350), new Vector(400, 300)));
		
		var sA:Surface = new Surface(new Vector(0, 100), new Vector(1, 300));
		sA.setIsOrientH(false);
		psystem.addSurface(sA);
		
		var sB:Surface = new Surface(new Vector(400, 300), new Vector(400, 100));
		sB.setIsOrientH(false);
		psystem.addSurface(sB);
		
		psystem.addSurface(new CircleSurface(100, 370, 100));
		psystem.paintSurfaces();
	}
	
	
	private function createCar()
	{
		var leftX:Number = 10;
		var rightX:Number = 80
		var widthX:Number = rightX - leftX;
		var midX:Number = leftX + (widthX / 2);
		
		var topY:Number = 180;
		
		// wheels
		wheelA = psystem.addWheel(leftX, topY, 20);
		wheelB = psystem.addWheel(rightX, topY, 20);
		
		wheelA.coeffSlip = 0;
		wheelB.coeffSlip = 0.2;
		
		// body
		var rectA:Rectangle = psystem.addRectangle(new Vector(midX, topY), widthX, 10);
		
		// wheel struts
		var conn1:Constraint = psystem.addConstraint(wheelA.wp, rectA.p3);
		conn1.setRestLength(5);
		
		var conn2:Constraint = psystem.addConstraint(wheelB.wp, rectA.p2);
		conn2.setRestLength(5);
		
		var conn1a:Constraint = psystem.addConstraint(wheelA.wp, rectA.p0);
		conn1a.setRestLength(5);
		
		var conn2a:Constraint = psystem.addConstraint(wheelB.wp, rectA.p1);
		conn2a.setRestLength(5);
		
		var wheelC = psystem.addWheel(midX, topY, 20);
		
		// triangle top of car
		var p1:Particle = psystem.addParticle(midX, topY - 50);

		var conn3:Constraint = psystem.addConstraint(wheelA.wp, p1);
		var conn4:Constraint = psystem.addConstraint(wheelB.wp, p1);
		var conn6:Constraint = psystem.addConstraint(wheelC.wp, p1);
		conn6.setRestLength(0);
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@return	
	 */
	public function run()
	{
		
		var keySpeed:Number = 2.0;
		
		if(Key.isDown(Key.LEFT)) 
		{
			wheelA.rp.vs = -keySpeed;
			wheelB.rp.vs = -keySpeed;
		} else if(Key.isDown(Key.RIGHT)) 
		{
			wheelA.rp.vs = keySpeed;
			wheelB.rp.vs = keySpeed;
		} else 
		{
			wheelA.rp.vs = 0;
			wheelB.rp.vs = 0;
		}
	    
		psystem.timeStep();
		psystem.paintParticles();
		psystem.paintWheels();
		psystem.paintConstraints();
	}
	/**
	 *	Main application 
	 */
	public static function main(scope:MovieClip):Void
	{
		var car:Car = new Car(scope);
	}
	
}
