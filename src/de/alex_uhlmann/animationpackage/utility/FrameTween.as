import de.alex_uhlmann.animationpackage.APCore;
import mx.effects.Tween;
import de.andre_michelle.events.FrameBasedInterval;
import de.andre_michelle.events.ImpulsDispatcher;

/*
* @class FrameTween
* @author Alex Uhlmann
* @description  Frame-based tween engine. Extends mx.effects.Tween and overwrites methods 
* 				that are specific to frame tweening. mx.effects.Tween uses time based tweening via setInterval(). 
* 				Because of the architecture of FrameTween, AnimationPackage can use frame-based and 
* 				time-based tweening in the same way and therefore change it at runtime. 
* 				FrameTween uses André Michelle's FrameBasedInterval and ImpulsDispatcher classes 
* 				for efficient frame tweening. Frame based tweening is faster and more accurate than time based tweening.
*/
class de.alex_uhlmann.animationpackage.utility.FrameTween extends Tween {		

	static var ActiveTweens:Array = new Array();
	static var Interval:Number = 10;
	static var IntervalToken:Number;
	static var Dispatcher:Object = new Object();

	public static function AddTween(tween:FrameTween):Void {
		tween.ID = ActiveTweens.length;
		ActiveTweens.push(tween);		
		if (IntervalToken == null) {
			if(!ImpulsDispatcher._timeline) {						
				ImpulsDispatcher.initialize(APCore.getCentralMC());				
			}
			Dispatcher.DispatchTweens = DispatchTweens;
			ImpulsDispatcher.addImpulsListener(Dispatcher, "DispatchTweens");
			IntervalToken = 1;			
		}		
	}

	public static function RemoveTweenAt(index:Number):Void {
		var aT = ActiveTweens;
		
		if (index >= aT.length || index < 0 || index == undefined)
			return;	

		FrameBasedInterval.removeInterval(aT[index].frameIntervalToken);
		aT.splice(index, 1);		
		var len = aT.length;
		var i:Number;
		for (i = index; i < len; i++) {
			aT[i].ID--;
		}
		if (len == 0) {
			IntervalToken = null;
		}
	}

	private static function DispatchTweens():Void {	
		var aT = ActiveTweens;
		var len = aT.length;
		var i:Number;		
		for (i=0; i < len; i++) {		
			aT[i].doInterval();	
		}
	}
	
	/*instance properties inherited by mx.effects.Tween;*/
	public var frameIntervalToken:Object;
	public var easingParams:Array;
	
	public  function FrameTween(listenerObj, init, end, dur, easingParams:Array) {
		if (listenerObj == undefined)
			return;
		if (typeof(init) != "number")
			this.arrayMode = true;

		this.listener = listenerObj;
		this.initVal = init;
		this.endVal = end;
		if (dur != undefined) {
			this.duration = dur;
		}
		this.easingParams = easingParams;
		if (this.duration == 0) {
			this.doInterval();
		} else {			
			FrameTween.AddTween(this, easingParams);
			this.frameIntervalToken = FrameBasedInterval.addInterval(this, "onFrameEnd", duration);			
		}
		this.startTime = this.frameIntervalToken.startFrame;
	}
	
	/*
	private function onFrameEnd():Void {}
	*/
	
	function doInterval()
	{
		var curTime = FrameBasedInterval.frame - this.startTime;
		var curVal;
		if(this.easingParams == null) {
			curVal = getCurVal(curTime);
		} else {
			curVal= getCurVal2(curTime);
		}
		if (curTime >= duration) {			
			endTween(curVal);
		} else {
			if (updateFunc!=undefined) {
				listener[updateFunc](curVal);
			} else {
				listener.onTweenUpdate(curVal);
			}
		}		
	}	
	
	function getCurVal2(curTime)
	{
		if (arrayMode) {
			var returnArray = [];
			var i:Number;
			var len:Number = initVal.length;
			for (i=0; i<len; i++) {	
				returnArray[i] = easingEquation.apply(null, [curTime, initVal[i], endVal[i]-initVal[i], duration].concat(this.easingParams));
			}
			return returnArray;
		}
		else {			
			return easingEquation.apply(null, [curTime, initVal, endVal-initVal, duration].concat(this.easingParams));
		}
	}
	
	function endTween(v)
	{
		if (endFunc!=undefined) {
			listener[endFunc](v);
		} else {
			listener.onTweenEnd(v);
		}
		FrameTween.RemoveTweenAt(this.ID);
	}	

	public function toString(Void):String {
		return "FrameTween";
	}
}