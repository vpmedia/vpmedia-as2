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
import wilberforce.geom.*;
import wilberforce.math.mathUtil;
//import wilberforce.math.vector2D;
//import wilberforce.math.shape2D;
import wilberforce.simulation.particles.particle2D;

/**
* Defines an emitter and its properties. Changing these properties can lead to a wide variety of effects
*/
class wilberforce.simulation.particles.particleEmitter2D
{
	private var _shape:IShape2D;
	
	private var _minAngle:Number;
	private var _maxAngle:Number;
	
	public var _minVelocity:Number;
	public var _maxVelocity:Number;
	public var _minLifeTime:Number;
	public var _maxLifeTime:Number;
	public var _minMass:Number;
	public var _maxMass:Number;
	public var _emitRate:Number;
	public var _frictionCoefficient:Number
	
	public var _directionAngle:Number
	public var _rangeAngle:Number
	
	/**
	* Constructor. Creates a new particleEmitter
	* @param	shape Shape of the emitter
	* @param	emitRate Rate of particle emission. Number to release per frame
	* @param	minAngle Minimum Angle of particle direction
	* @param	maxAngle Maximum Angle of particle direction
	* @param	minVelocity Minimum initial velocity of particle
	* @param	maxVelocity Maximum initial velocity of particle
	* @param	minLifeTime Minimum lifetime of particle
	* @param	maxLifeTime Maximum lifetime of particle
	* @param	minMass Minimum mass of particle
	* @param	maxMass Maximum mass of particle
	* @param	frictionCoefficient The constant friction of the particle
	*/
	function particleEmitter2D(shape:IShape2D,emitRate:Number,tDirectionAngle:Number,tRangeAngle:Number,minVelocity:Number,maxVelocity:Number,minLifeTime:Number,maxLifeTime:Number,minMass:Number,maxMass:Number,frictionCoefficient:Number)
	{
		_shape=shape;
		_directionAngle=tDirectionAngle;
		_rangeAngle=tRangeAngle;
		
		_minAngle=_directionAngle-_rangeAngle/2;
		_maxAngle=_directionAngle+_rangeAngle/2;
		
		//trace("Angle "+_minAngle+"-"+_maxAngle+" range "+_rangeAngle);
		
		_minVelocity=minVelocity;
		_maxVelocity=maxVelocity;
		_minLifeTime=minLifeTime;
		_maxLifeTime=maxLifeTime;
		_minMass=minMass;
		_maxMass=maxMass;
		_emitRate=emitRate;
	}
	

	/*
	public function setAngleRange(directionAngle:Number,rangeAngle:Number):Void
	{
		_minAngle=minAngle;
		_maxAngle=maxAngle
	}
	*/
	
	/**
	* Creates the a new particle based upon the emitter's parameters
	* @return The created particle
	*/
	public function newParticle():particle2D
	{
		var tAngle=mathUtil.randNum(_minAngle,_maxAngle);
		var tVelocity=mathUtil.randNum(_minVelocity,_maxVelocity);
		var tLifeTime=mathUtil.randNum(_minLifeTime,_maxLifeTime);
		var tMass=mathUtil.randNum(_minMass,_maxMass);
		
		var pos:vector2D=_shape.randomPointWithin()
		//(lifetime:Number,x:Number,y:Number,xVelocity:Number,yVelocity:Number,mass:Number,frictionCoefficient:Number)
		
		var vel:vector2D=new vector2D(Math.cos(tAngle),Math.sin(tAngle));
		
		vel.mult(tVelocity);
		// Divide by initial mass
		vel.mult(1/tMass);
		return new particle2D(tLifeTime,pos,vel,tMass,_frictionCoefficient)
		
	}
	
	public function get directionAngle():Number
	{
		return _directionAngle;
	}
	
	public function set directionAngle(value:Number)
	{
		_directionAngle=value;
		_minAngle=_directionAngle-_rangeAngle/2;
		_maxAngle=_directionAngle+_rangeAngle/2;
	}
	
	public function get rangeAngle():Number
	{
		return _rangeAngle;
	}
	
	public function set rangeAngle(value:Number)
	{
		_rangeAngle=value;
		_minAngle=_directionAngle-_rangeAngle/2;
		_maxAngle=_directionAngle+_rangeAngle/2;
	}
}