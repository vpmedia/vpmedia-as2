import eu.orangeflash.effects.TweenEffect;

class eu.orangeflash.effects.Rotate extends TweenEffect
{
	private var af:Number;
	private var at:Number;
	
	public function Rotate(target:Object, easing:Function, angleFrom:Number, angleTo:Number, duration:Number)
	{
		super(target, easing, duration);
		
		af = angleFrom;
		at = angleTo;
		
		tweens.push(createTween("_rotation", af, at));
		
		addTweenEvents();
	}
}