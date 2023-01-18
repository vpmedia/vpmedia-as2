/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Simon Oliver
 * @version 1.0
 */

// Classes from wilberforce
import wilberforce.geom.vector2D;

/**
* Individual 2D particle class
*/ 
class wilberforce.simulation.particles.particle2D
{
	var _pos:vector2D;
	var _vel:vector2D;

	private var _lifetime:Number;
	private var _mass:Number;
	private var _fc:Number;
	private var _timeleft:Number;
	
	function particle2D(lifetime:Number,position:vector2D,velocity:vector2D,mass:Number,frictionCoefficient:Number)
	{		
		_pos=position;
		_vel=velocity
		_timeleft=_lifetime=lifetime;
		
		if (!mass) mass=0;
		if (!frictionCoefficient) frictionCoefficient=1;
		
		_mass=mass;
		_fc=frictionCoefficient;		
	}
	function applyForce(force:vector2D)
	{		
		_vel.addVector(new vector2D(force.x/_mass,force.y/_mass));			
	}
	
	/**
	* Perform a single step
	* @return The percentage of the lifetime left
	*/
	function step():Number
	{
		_vel.mult(_fc);
		_pos.addVector(_vel);
		_timeleft--;
		return (_timeleft/_lifetime)
	}
}