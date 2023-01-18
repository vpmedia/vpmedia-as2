import mx.effects.Tween;
import mx.transitions.easing.Strong;

class com.jxl.shuriken.managers.TweenManager
{
	
	public static function createTween(pListener, 
									   pInit, 
									   pEnd, 
									   pDur, 
									   pEasing:Function, 
									   pUpdateFunction:String,
									   pEndFunction:String):Tween
	{
		var tween:Tween = new Tween(pListener, pInit, pEnd, pDur);
		var theEasingFunction:Function = (pEasing == null) ? Strong.easeOut : pEasing;
		tween.easingEquation = theEasingFunction;
		tween.setTweenHandlers(pUpdateFunction, pEndFunction);
		return tween;
	}
	
	public static function abortTween(pTween:Tween):Void
	{
		pTween.listener = null;
		pTween.updateFunc = null;
		pTween.endFunc = null;
		Tween.RemoveTweenAt(pTween.ID);
	}
	
}