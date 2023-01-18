import eu.orangeflash.effects.Composition
import eu.orangeflash.effects.IEffect;
import eu.orangeflash.events.EffectEvent;

import mx.utils.Delegate;

class eu.orangeflash.effects.Sequence extends Composition implements IEffect
{
	public static var START:String = "start";
	public static var REWIND:String = "rewind";
	
	private var currentIndex:Number = 0;
	private var currentAction:String = START;
	
	private var completeDelegate:Function;
	private var changeDelegate:Function;
	
	public function Sequence()
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
		var result:Number = 0;
		
		for(var i:Number = 0; i < effects.length; i++)
		{
			result += effects[i].getDuration();
		}
		
		return result;
	}
	/**
	* Method, starts effect instance
	* 
	* @return		Nothing
	*/
	public function start():Void
	{
		currentAction = START;
		executeSequence(0);
		
		completeDelegate = Delegate.create(this, onEffectComplete);
		
		effects[currentIndex].addEventListener('complete', completeDelegate);
	}
	/**
	* Method, stops currently playing effect.
	* 
	* @return		Nothing
	*/
	public function stop():Void
	{
		effects[currentIndex].stop();
	}
	/**
	* Method, rewinds effects (plays backwards)
	* 
	* @return		Nothing
	*/
	public function rewind():Void
	{
		currentAction = REWIND;
		executeSequence(effects.length-1);
	}
	/**
	* Method, resumes previously stopped effect.
	* 
	* @return		Nothing
	*/
	public function resume():Void
	{
		effects[currentIndex].resume();
	}
	
	private function executeSequence(fromIndex:Number):Void
	{
		effects[fromIndex][currentAction]();
		currentIndex = fromIndex;
	}
	
	private function configureListeners(addListener:Boolean, type:String, handler:Function):Void
	{
		var action:String = (addListener)? 'addEventListener':'removeEventListener';
		
		for(var i:Number = 0; i < effects.length; i++)
		{
			effects[i][action](type, handler);
		}
	}
	
	private function onEffectChange(event:Object):Void
	{
		dispatchEvent({type:'change'});
	}
	
	private function onEffectComplete(event:Object):Void
	{
		if(currentIndex == effects.length-1)
		{
			dispatchEvent(new EffectEvent(EffectEvent.COMPLETE, this));
		}
		else
		{
			dispatchEvent(new EffectEvent(EffectEvent.UNIT_COMPLETE, this));
			
			effects[currentIndex].removeEventListener('complete', completeDelegate);
			currentIndex++;
			effects[currentIndex][currentAction]();
			effects[currentIndex].addEventListener('complete', completeDelegate);
			
			dispatchEvent(new EffectEvent(EffectEvent.UNIT_BEGIN, this));			
		}
	}
	
}