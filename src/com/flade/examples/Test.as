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
import com.flade.geom.Point;
import com.flade.physics.Rectangle;
import com.flade.physics.CircleSurface;
import com.flade.app.Application;

/**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.examples.Test extends Application
{
	private var psystem:ParticleSystem;
	private var head:Rectangle ;
			
	public function Test(s:MovieClip)
	{
		super(s);
		init();
	}
	
	public function init()
	{
		psystem = new ParticleSystem(scope);
		psystem.setDamping(1.0);
		psystem.setGravity(0.0, 0.5);
		
		// cooefficient of restitution
		psystem.setKfr(0.1);
		
		// surface friction for particles
		psystem.setFriction(0.7);
	
		createSurface();
		createCar();
		
	}

	private function createSurface()
	{
		
		var sA:Surface = new Surface(new Point(0, 0), new Point(8, 300));
		sA.setIsOrientH(false);
		psystem.addSurface(sA);

		var sB = new Surface(new Point(799, 300), new Point(799, 0));
		sB.setIsOrientH(false);
		psystem.addSurface(sB);
		
		psystem.addSurface(new Surface(new Point(8, 300), new Point(100, 300)));
		psystem.addSurface(new Surface(new Point(100, 300), new Point(300, 200)));
		psystem.addSurface(new Surface(new Point(300, 200), new Point(600, 350)));
		psystem.addSurface(new Surface(new Point(600, 350), new Point(799, 300)));

		var circ = new CircleSurface(300, 140, 50);
		psystem.addSurface(circ);
		psystem.paintSurfaces();
	}
	
	
	private function createCar()
	{
		var gx = 100;
		var gy = 100;
		head = psystem.addRectangle(new Vector(gx, gy), 30, 20);
		
		var p1 = psystem.addParticle(gx, gy);
		var p2 = psystem.addParticle(gx, gy + 10);
		var p3 = psystem.addParticle(gx+10, gy + 20);
		var p4 = psystem.addParticle(gx+10, gy + 10);
		
		var lineB = psystem.addConstraint(head.p0, p2);
		lineB.restLength = 15;
		
		var lineA = psystem.addConstraint(head.p1, p4)
		lineA.restLength = 15;
		
		/*
		var lineA = psystem.addConstraint(body.p0, p1);
		var lineB = psystem.addConstraint(p1, p2);
		var lineC = psystem.addConstraint(p2, p3);
		var lineD = psystem.addConstraint(p3, head.p0);
		
		lineA.restLength = 15;
		lineB.restLength = 15;
		lineC.restLength = 15;
		lineD.restLength = 15;
		*/
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@return	
	 */
	public function onEnterFrame()
	{
		var keySpeed1:Number = 3;
		var keySpeed2:Number = 1.5;
		
		if (Key.isDown(Key.UP))
		{
			head.p1.prev.y += keySpeed1;
			head.p2.prev.y += keySpeed1;
		}
		else if (Key.isDown(Key.DOWN))
		{
			head.p1.prev.y += keySpeed1;
			head.p2.prev.y += keySpeed1;
		} // end if
		if (Key.isDown(Key.LEFT))
		{
			head.p1.prev.x += keySpeed2;
			head.p2.prev.x += keySpeed2;
		}
		else if (Key.isDown(Key.RIGHT))
		{
			head.p1.prev.x += keySpeed2;
			head.p2.prev.x += keySpeed2;
		}
		psystem.timeStep();
		//psystem.paintParticles();
		psystem.paintWheels();
		psystem.paintConstraints();
	}
	
	/**
	 *	Main application entre
	 */
	public static function main():Void
	{
		var test:Test = new Test(_root);
	}
	
}
