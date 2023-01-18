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
import wilberforce.simulation.particles.particleEmitter2D;
import wilberforce.simulation.particles.particle2D;

// Classes from pixlib
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;
/**
* 2D Particle system used to simulate a variety of effects from snow, hoses, waterfalls, fire etc
*/
class wilberforce.simulation.particles.particleSystem2D implements IFrameListener
{
	
	private var _movieClip:MovieClip;
	private var _attachName:String;
	private var _constantForces:Array;	
	private var _emitter:particleEmitter2D;
	private var _maxParticles:Number;
	private var _particleMovieClips:Array;
	private var _particles:Array
	public var paused:Boolean;
	
	private var _emitRateAccumulator:Number;
	private var _bursting:Boolean;
	private var _burstComplete:Boolean;
	/**
	* Constructor. Creates the a particle system
	* 
	* @param	movieClip		The MovieClip to house the particle system. New clips will be created here
	* @param	attachName		The library "export to actionscript..." name
	* @param	emitter			The emitter to use
	* @param	tMaxParticles	The total number of particle to be allowed in the system at any time
	*/
	function particleSystem2D(movieClip:MovieClip,attachName:String,emitter:particleEmitter2D,tMaxParticles:Number)
	{
		_particleMovieClips=new Array();
		_particles=new Array();
		_constantForces=new Array();
		
		_movieClip=movieClip;
		_attachName=attachName;
		_emitter=emitter;		
		_maxParticles=tMaxParticles;
				
		paused=false;
		//frameEventBroadcaster.addEventListener("frameStep",this,frameStep);
		FPSBeacon.getInstance().addFrameListener(this);
		_emitRateAccumulator=0;
		
		_bursting=false;
		_burstComplete=false;
		
	}
	
	
	/**
	* Add a new constant force to the sytem. Used to add effects such as gravity, buoyancy in water etc
	* @param	force
	*/
	public function addConstantForce(force:vector2D)
	{		
		_constantForces.push(force);
	}
	
	/**
	* Used to add a new variable force, such as wind. Not implemented yet
	* 
	* @param	force
	* @param	noiseFactor
	*/
	public function addNoisyForce(force:vector2D,noiseFactor:Number)
	{
		//todo
	}
	
	
	/**
	* Fast forward a certain number of steps. Used to initialise a system such as a waterfall
	* @param	steps	The number of steps to complete
	*/
	public function fastForward(steps:Number):Void
	{
		for (var i:Number;i<steps;i++) onEnterFrame();
	}
	
	/**
	* Pause the particle system
	*/
	public function pause():Void
	{
		paused=true;	
	}
	
	
	public function burst():Void
	{
		//trace("Burst");
		reset();
		paused=false;
		_bursting=true;
		_burstComplete=false;
		_emitRateAccumulator=_maxParticles;
		//limitedParticlesNumber=
	}
	/**
	* Unpause the particle system
	*/
	public function unpause():Void
	{
		paused=false;
	}
	
	public function reset():Void
	{
		for (var i in _particleMovieClips)
		{
			 _particleMovieClips[i].removeMovieClip();
		}
		
		for (var i in _particles)
		{
			 delete _particles[i];
		}
		_particleMovieClips=[];
		_particles=[];
	}
	
	public function onEnterFrame():Void
	{
		if (paused) return;
		// Update every particle
		for (var i=0;i<_particles.length;i++)
		{
			var tParticle:particle2D=_particles[i];
			var tMovieClip:MovieClip=_particleMovieClips[i];
			
			// Apply every force
			for (var j=0;j<_constantForces.length;j++) tParticle.applyForce(_constantForces[j]);
			
			// Apply every noisy force - todo
			
			var stepResult:Number=tParticle.step();
			if (stepResult<=0)
			{
				//trace("Removing "+tMovieClip);
				tMovieClip.removeMovieClip();
				
				delete tParticle;
				_particles.splice(i,1);
				_particleMovieClips.splice(i,1)
				i--;
			}
			else {
				// Update the visual element
				tMovieClip._x=tParticle._pos.x;
				tMovieClip._y=tParticle._pos.y;
				tMovieClip.update(stepResult);
				
			}			
		}		
		// Deal with new particles
		
		if (_bursting && _burstComplete) return;
		
		if (_particles.length<_maxParticles)
		{
			while (_emitRateAccumulator>1 && _particles.length<_maxParticles){
				_emitRateAccumulator--;
				
				var tParticle:particle2D=_emitter.newParticle();
				_particles.push(tParticle);
				
				var tDepth=_movieClip.getNextHighestDepth();
				var tMovieClip=_movieClip.attachMovie(_attachName,"particle"+tDepth,tDepth);
				//trace("Adding particle "+tMovieClip+" to "+_movieClip);
				tMovieClip._x=tParticle._pos.x;
				tMovieClip._y=tParticle._pos.y;
				
				_particleMovieClips.push(tMovieClip);
			}
			
			// Only add to the accumulator if particles arent full. otherwise it will be meaningless
			if (!_bursting)
			{
				if (_particles.length<_maxParticles) _emitRateAccumulator+=_emitter._emitRate;
				
			}
			else {
				_burstComplete=true;
				//paused=true;
			}
		}
	}
	
	
	public function get maxParticles():Number{
		return _maxParticles;
	}
	
	public function set maxParticles(value:Number) {
		_maxParticles=value;
	}
}