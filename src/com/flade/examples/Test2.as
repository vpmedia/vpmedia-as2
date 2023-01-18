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
import com.flade.physics.Particle;
import com.flade.geom.Point;
import com.flade.physics.Rectangle;
import com.flade.app.Application;

/**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.examples.Test2 extends Application
{
	private var psystem:ParticleSystem;
	private var head:Rectangle ;
			
	public function Test2(s:MovieClip)
	{
		super(s);
		init();
	}
	
	public function init()
	{
		psystem = new ParticleSystem(scope);
		psystem.setKfr(0.1);
		psystem.setFriction(0.3);
		psystem.setGravity(0, 1500);
	
		createSurface();
		createCar();
	}

	private function createSurface()
	{
		var s0 = new Surface(new Point(1, 300), new Point(200, 350));
		psystem.addSurface(s0);
		var s1 = new Surface(new Point(200, 350), new Point(400, 250));
		psystem.addSurface(s1);
		psystem.paintSurfaces();
	}
	
	
	private function createCar()
	{
		var rows = 5;
		var cols = 20;
		var startX = 40;
		var startY = 20;
		var spacing = 16;
		var currX = startX;
		var currY = startY;
		var n = 0;
		
		while (n < rows)
		{
		    var j = 0;
		    while (j < cols)
		    {
			   currY = currY + Math.random() * 1;
			   currX = currX + Math.random() * 1;
			   var p = new Particle(currX, currY);
			   psystem.addParticle(p);
			   currX = currX + spacing;
			   j++;
		    } 
		    currX = startX;
		    currY = currY + spacing;
		    n++;
		} 
		
		
		var lastPar = null;
		
		n = 0;
		while (n < cols)
		{
		    var j = 0;
		    while (j < rows)
		    {
			   var i = cols * j + n;
			   var par:Particle = psystem.getParticle(i);
			   if (lastPar != null)
			   {
				  psystem.addConstraint(par, lastPar);
			   } 
			   lastPar = par;
			   j++;
		    } 
		    lastPar = null;
		    n++;
		} 
		
		var i = 0;
		while (i < psystem.getParticleCount())
		{
		    var par:Particle = psystem.getParticle(i);
		    if (lastPar != null && i % cols != 0)
		    {
			   psystem.addConstraint(par, lastPar);
		    } 
		    lastPar = par;
		    i++;
		} 
		
	}
	
	/**
	 *	
	 *	@usage	
	 *		
	 *	@return	
	 */
	public function onEnterFrame()
	{
		psystem.timeStep();
		//psystem.paintParticles();
		psystem.paintConstraints();
	}
	
	/**
	 *	Main application entre
	 */
	public static function main():Void
	{
		var test:Test2 = new Test2(_root);
	}
	
}

/*
 // end while
this.onEnterFrame = function ()
{
    psystem.timeStep();
    if (!isDrag)
    {
        psystem.particles[0].pin();
        psystem.particles[19].pin();
    } // end if
    var _l1 = 0;
    while (_l1 < psystem.constraints.length)
    {
        psystem.constraints[_l1].paint();
        _l1++;
    } // end while
};
*/
