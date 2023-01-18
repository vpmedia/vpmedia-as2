import eu.orangeflash.effects.TweenEffect;
import eu.orangeflash.events.EDispatcher;
import eu.orangeflash.events.EffectEvent;

import flash.filters.BlurFilter;
import flash.filters.BitmapFilter;

import mx.transitions.Tween;

class eu.orangeflash.effects.Blur extends TweenEffect
{
	private var xf:Number;
	private var yf:Number;
	private var xt:Number;
	private var yt:Number;
	private var filter:BitmapFilter;
	
	public function Blur(target:Object, easing:Function, blurXFrom:Number, blurXTo:Number, blurYFrom:Number, blurYTo:Number, duration:Number)
	{
		super(target, easing, duration);
		
		xf = blurXFrom;
		xt = blurXTo;
		yf = blurYFrom;
		yt = blutYTo;
		
		var blur:BlurFilter = new BlurFilter(blurXFrom, blurYFrom);
		
		trace(target.filters);
		
		target.filters = [blur];
	}
	
	private function createTween(property:String, from:Number, to:Number):Tween
	{
		var oldFrom:Number = filter[property];
		
		var result:Tween = new Tween(filter, property, _easing, from, to, _duration, _useSeconds);
			result.stop();
			
		filter[property] = oldFrom;
		
		return result;
	}
}