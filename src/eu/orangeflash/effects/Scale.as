import eu.orangeflash.effects.TweenEffect;
/**
* Class, resizes target.
* 
* @author	Nirth
* @url		http://blog.orangeflash.eu
*/
class eu.orangeflash.effects.Scale extends TweenEffect
{
	private var sf:Number;
	private var st:Number;
	
	/**
	* Constructor, creates new Scale instance.
	* 
	* @param	target		Object, effect target.
	* @param	easing		Function, easing function, see mx.transitions.easing package.
	* @param	scaleFrom	Number,
	* @param	scaleTo		Number
	* @param	duration	Number, duration in seconds.
	*/
	public function Scale(target:Object, easing:Function, scaleFrom:Number, scaleTo:Number, duration:Number)
	{
		super(target, easing, duration);
		
		sf = scaleFrom;
		st = scaleTo;
	
		tweens.push(createTween("_xscale", sf, st));
		tweens.push(createTween("_yscale", sf, st));
		
		addTweenEvents();
	}
}