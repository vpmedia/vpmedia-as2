import eu.orangeflash.effects.IEffect;
import eu.orangeflash.effects.Composition;
import eu.orangeflash.events.EffectEvent;

import mx.utils.Delegate;

class eu.orangeflash.effects.Parallel extends Composition implements IEffect
{
	private var _duration:Number;
	private var currentIndex = 0;
	
	public function Parallel()
	{
		super();
	}	
	/**
	* Method, returns duration of the effect
	* 
	* @return		Number, duration.
	*/
	public function getDuration():Number
	{
		return getLongestEffect().getDuration();
	}
	/**
	* Method, starts effect instance
	* 
	* @return		Nothing
	*/
	public function start():Void
	{
		invokeMethod("start");
		
		for(var i:Number = 0; i < effects.length; i++)
		{
			effects[i].addEventListener(EffectEvent.COMPLETE, Delegate.create(this, onEffectComplete));
		}	
	}
	/**
	* Method, stops currently playing effect.
	* 
	* @return		Nothing
	*/
	public function stop():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
		
		invokeMethod("stop");
	}
	/**
	* Method, rewinds effects (plays backwards)
	* 
	* @return		Nothing
	*/
	public function rewind():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
		
		invokeMethod("rewind");
	}
	/**
	* Method, resumes previously stopped effect.
	* 
	* @return		Nothing
	*/
	public function resume():Void
	{
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
		
		invokeMethod("resume");
	}
	
	private function getLongestEffect():IEffect
	{		
		var result:IEffect = effects[0];
		
		for (var i:Number = 1; i<effects.length; i++)
		{
			result = compareDuration(result, effects[i]);
		}
		
		return result;
	}
	
	private function compareDuration(effect1:IEffect, effect2:IEffect):IEffect
	{
		if(effect1.getDuration() > effect2.getDuration())
		{
			return effect1;
		}
		else
		{
			return effect2;
		}
		return effect1;
	}
	
	private function invokeMethod(methodName:String):Void
	{
		for(var i:Number = 0; i<effects.length; i++)
		{
			var effect:IEffect = IEffect(effects[i]);
				effect[methodName]();
		}
	}
	
	private function onEffectComplete(event:Object):Void
	{
		currentIndex++
		if(currentIndex == effects.length-1)
		{
			dispatchEvent(new EffectEvent(EffectEvent.COMPLETE, this));
		}
		else
		{
			dispatchEvent(new EffectEvent(EffectEvent.UNIT_COMPLETE, this));
		}
		
	}
}