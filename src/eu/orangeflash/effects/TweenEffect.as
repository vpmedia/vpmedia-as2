import eu.orangeflash.effects.IEffect;
import eu.orangeflash.events.EDispatcher;
import eu.orangeflash.events.EffectEvent;

import mx.transitions.Tween;
import mx.transitions.easing.*;
import mx.utils.Delegate;
/**
* Base class for all Tween events.
* 
* @author	Nirth
* @url		http://blog.orangeflash.eu
*/
class eu.orangeflash.effects.TweenEffect extends EDispatcher implements IEffect
{	
	private var tweens:Array;
	
	private var _target;
	private var _duration:Number;
	private var _useSeconds:Boolean;
	private var _easing:Function;
	
	public function TweenEffect(target:Object, easing:Function, duration:Number)
	{		
		tweens = new Array();
		
		_target = target;
		_easing = easing;
		_duration = duration;
		_useSeconds = true;
	}
	/**
	* Method, starts effect instance
	* 
	* @return		Nothing
	*/
	public function start():Void
	{		
		for(var i:Number = 0; i<tweens.length; i++)
		{
			//trace("TweenEffect::start() starting #"+i.toString());
			tweens[i].start();
		}
	}
	/**
	* Method, rewinds effects (plays backwards)
	* 
	* @return		Nothing
	*/
	public function rewind():Void
	{		
		for(var i:Number = 0; i<tweens.length; i++)
		{
			tweens[i].rewind();
		}
	}
	/**
	* Method, stops currently playing effect.
	* 
	* @return		Nothing
	*/
	public function stop():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.STOP, this));
		
		for(var i:Number = 0; i<tweens.length; i++)
		{
			tweens[i].stop();
		}
	}
	/**
	* Method, resumes previously stopped effect.
	* 
	* @return		Nothing
	*/
	public function resume():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
		
		for(var i:Number = 0; i<tweens.length; i++)
		{
			tweens[i].resume();
		}
	}
	/**
	* Method, returns duration of the effect
	* 
	* @return		Number, duration.
	*/
	public function getDuration():Number
	{
		return _duration;
	}
	
	private function addTweenEvents():Void
	{
		tweens[0].onMotionStarted  = Delegate.create(this, onStart);
		tweens[0].onMotionChanged  = Delegate.create(this, onChange);
		tweens[0].onMotionFinished = Delegate.create(this, onFinish);
		tweens[0].onMotionStoped   = Delegate.create(this, onStop);
 	}
	
	private function createTween(property:String, from:Number, to:Number)
	{
		var oldFrom:Number = _target[property];
		
		var result:Tween = new Tween( _target, property, _easing, from, to, _duration, _useSeconds);
			result.stop();
			
		_target[property] = oldFrom;
		
		return result;
	}
	
	private function onStop():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.STOP, this));
	}
	
	private function onStart():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
	}
	
	private function onChange():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.CHANGE, this));
	}
	private function onFinish():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.COMPLETE, this));
	}
}