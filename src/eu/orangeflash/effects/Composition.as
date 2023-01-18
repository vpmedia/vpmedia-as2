import eu.orangeflash.effects.IEffect;
import eu.orangeflash.events.EDispatcher;

import mx.utils.CollectionImpl;
import mx.utils.IteratorImpl;

class eu.orangeflash.effects.Composition extends EDispatcher
{	
	var effects:Array;
	
	public function Composition()
	{
		effects = new Array();
	}
	/**
	* Method, adds new Effect to collection.
	* 
	* @param	effect Effect instance.
	*/
	public function addEffect(effect:IEffect):Void
	{
		effects.push(effect);
		
	}
	
	private function onEffectChange(event:Object):Void
	{
		dispatchEvent({type:'change'});
	}
	
	///
}