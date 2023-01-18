import eu.orangeflash.effects.TweenEffect;

import mx.transitions.Tween;

class eu.orangeflash.effects.DoubleTween extends TweenEffect
{
	private var secondTween:Tween;
	
	public function DoubleTween(target:Object, easing:Function, duration:Number, useSeconds:Boolean)
	{
		super(target, easing, duration, useSeconds);
	}
}