interface eu.orangeflash.effects.IEffect
{
	/**
	* Method, starts effect instance
	* 
	* @return		Nothing
	*/
	public function start():Void;
	/**
	* Method, resumes previously stopped effect.
	* 
	* @return		Nothing
	*/
	public function resume():Void;
	/**
	* Method, stops currently playing effect.
	* 
	* @return		Nothing
	*/
	public function stop():Void;
	/**
	* Method, rewinds effects (plays backwards)
	* 
	* @return		Nothing
	*/
	public function rewind():Void;
	/**
	* Method, adds event listener, see mx.events.EventDispatcher.
	* 
	* @param	type
	* @param	handler
	*/
	public function addEventListener(type:String, handler:Function):Void
	/**
	* Method, removes event listener, see mx.events.EventDispatcher.
	* 
	* @param	type
	* @param	handler
	*/
	public function removeEventListener(type:String, handler:Function):Void
	/**
	* Method, returns duration of the effect
	* 
	* @return		Number, duration.
	*/
	public function getDuration():Number;
}