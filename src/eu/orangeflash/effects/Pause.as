import eu.orangeflash.effects.IEffect;
import eu.orangeflash.events.EDispatcher;
import eu.orangeflash.events.EffectEvent;

import mx.transitions.OnEnterFrameBeacon;
import mx.utils.Delegate;
/**
* Class, creates "empty" event, which can be used as delay in Sequence.
*/
class eu.orangeflash.effects.Pause extends EDispatcher implements IEffect
{
	private var _duration:Number;
	private var _useSeconds:Boolean;
	private var interval:Number;
	private var ticks:Number = 0;    //ammounts of "ticks" before 'complete' event will be dispatched.
	private var currentTick:Number = 0;
	private var ups:Number = 10; //updates per second, used with setInterval;
	
	static var initBeacon = OnEnterFrameBeacon.init();
	
	public function Pause(duration:Number)
	{		
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
		dispatchEvent(new EffectEvent(EffectEvent.BEGIN, this));
		
		if(_useSeconds)
		{
			this.interval = setInterval(Delegate.create(this, onEnterFrame), 10);
			ticks = (_duration/ups)*1000;
		}
		else
		{
			_global.MovieClip.addListener(this);
		}
	}
	/**
	* Method, rewinds effects (plays backwards)
	* 
	* @return		Nothing
	*/
	public function rewind():Void
	{
		start();
	}
	/**
	* Method, resumes previously stopped effect.
	* 
	* @return		Nothing
	*/
	public function resume():Void
	{
		start();
	}
	/**
	* Method, stops currently playing effect.
	* 
	* @return		Nothing
	*/
	public function stop():Void
	{
		if(_useSeconds)
		{
			clearInterval(interval);
		}
		else
		{
			_global.MovieClip.removeListener(this);
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
	
	private function onEnterFrame():Void
	{
		currentTick++;

		if(currentTick < ticks)
		{
			dispatchEvent(new EffectEvent(EffectEvent.CHANGE, this));
		}
		else
		{
			dispatchEvent(new EffectEvent(EffectEvent.COMPLETE, this));
			
			//workaround
			clearInterval(interval);
			_global.MovieClip.removeListener(this);
			//
			
			currentTick = 0;
		}
	}
}