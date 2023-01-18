/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Rectangle class
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
import com.flade.physics.Particle;
import com.flade.geom.Vector;

/**
 * 	Rectangle
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 */
class com.flade.physics.Rectangle
{

	public var p0:Particle;
	public var p1:Particle;
	public var p2:Particle;
	public var p3:Particle;
		
	public function Rectangle(pSystem:ParticleSystem, center:Vector, rWidth:Number, rHeight:Number) 
	{
		// top left
		var p0:Particle = pSystem.addParticle(center.x - rWidth / 2, center.y - rHeight / 2);
		// top right
		var p1:Particle = pSystem.addParticle(center.x + rWidth / 2, center.y - rHeight / 2);
		// bottom right
		var p2:Particle = pSystem.addParticle(center.x + rWidth / 2, center.y + rHeight / 2);
		// bottom left
		var p3:Particle = pSystem.addParticle(center.x - rWidth / 2, center.y + rHeight / 2);
		
		// edges
		pSystem.addConstraint(p0, p1);
		pSystem.addConstraint(p1, p2);
		pSystem.addConstraint(p2, p3);
		pSystem.addConstraint(p3, p0);
		
		// crossing braces
		pSystem.addConstraint(p0, p2);
		pSystem.addConstraint(p1, p3);
		
		this.p0 = p0;
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		
		//trace(this)
	}
	
	public function toString():String
	{
		return "[Rectangle "+p0+" "+p1+" "+p2+" "+p3+"]"
	}
}

