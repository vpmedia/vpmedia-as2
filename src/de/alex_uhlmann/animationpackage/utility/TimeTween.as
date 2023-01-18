import mx.effects.Tween;

/*
* @class TimeTween
* @author Alex Uhlmann
* @description  Time-based tween engine. Extends mx.effects.Tween and overwrites methods 
* 				
*/
class de.alex_uhlmann.animationpackage.utility.TimeTween extends Tween {		

	/*instance properties inherited by mx.effects.Tween;*/
	public var easingParams:Array;
	public var lastVal:Number;
	function TimeTween(listenerObj, init, end, dur, easingParams:Array)
	{

		if ( listenerObj==undefined ) return;
		if (typeof(init) != "number") arrayMode = true;

		listener = listenerObj;
		initVal = init;
		endVal = end;
		if (dur!=undefined) {
			duration = dur;
		}
		this.easingParams = easingParams;
		startTime = getTimer();

		if ( duration==0 ) {
 			endTween(); //doInterval() this called easingEq which got a div/by/zero
		} else {
			Tween.AddTween(this);
		}
	}

	function doInterval()
	{
		var curTime = getTimer()-startTime;
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
		mx.effects.Tween.RemoveTweenAt(ID);
	}

	public function toString(Void):String {
		return "TimeTween";
	}
}