import eu.orangeflash.effects.TweenEffect;

class eu.orangeflash.effects.Alpha extends TweenEffect
{
	private var af:Number;
	private var at:Number;
	
	public function Alpha(target:Object, easing:Function, alphaFrom:Number, alphaTo:Number, duration:Number)
	{
		super(target, easing, duration);
		
		af = alphaFrom;
		at = alphaTo;
		
		tweens.push(createTween("_alpha", af, at));
		
		addTweenEvents();
	}
}