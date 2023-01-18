/**
 * @author todor
 */

import mx.events.EventDispatcher;

import gugga.animations.IAnimation;
import gugga.utils.DebugUtils;

import tweens.zigo.TweenManager;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
class gugga.animations.PropertiesTweenAnimation extends EventDispatcher implements IAnimation 
{	
	private var mIsRunning:Boolean;
	
	private var mSubject:Object;
	private var mTweeningProprties:Array;
	private var mTweenToValues:Array;
	private var mTweenTime:Number;
	private var mTweenType:String;
	private var mTweenDelay:Number;
	
	private var mCuePoints:Array;
	private var mTweenManager:TweenManager;
	
	public function getCuePointEventNames() : Array 
	{
		var result : Array = new Array();
		for (var i : Number = 0; i < mCuePoints.length; i++)
		{
			result.push(mCuePoints[i].event);
		}
		return result;
	}
	
	public function PropertiesTweenAnimation()
	{
		mIsRunning = false;
		mCuePoints = new Array();
		mTweenManager = TweenManager.Instance;
	}
	
	public function start() : Void 
	{
		mIsRunning = true;
		var callbacks:Object = new Object();
		
		callbacks.func = onTweenFinished;
		callbacks.scope = this;
		
		callbacks.updfunc = onTweenUpdate;
		callbacks.updscope = this;
		
		callbacks.startfunc = onTweenStarted;
		callbacks.startscope = this;
		
		var animType : String = mTweenType.toLowerCase();
		var eqf;
		
		if (animType == "linear") 
		{
			eqf = _global.tweens.robertpenner.easing.Linear.easeNone;
		} 
		else if (animType.indexOf("easeoutin") == 0) 
		{
			var t = animType.substr(9);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			eqf = _global.tweens.robertpenner.easing[t].easeOutIn;
		} 
		else if (animType.indexOf("easeinout") == 0) 
		{
			var t = animType.substr(9);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			eqf = _global.tweens.robertpenner.easing[t].easeInOut;
		}
		else if (animType.indexOf("easein") == 0) 
		{
			var t = animType.substr(6);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			eqf = _global.tweens.robertpenner.easing[t].easeIn;
		} 
		else if (animType.indexOf("easeout") == 0) 
		{
			var t = animType.substr(7);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			eqf = _global.tweens.robertpenner.easing[t].easeOut;
		}
		
		if (eqf == undefined) 
		{
			// set default tweening equation
			eqf = _global.tweens.robertpenner.easing.Expo.easeOut;
		}
		
		mTweenManager.removeTween(mSubject, mTweeningProprties);
		mTweenManager.addTweenWithDelay(mTweenDelay, mSubject, mTweeningProprties, mTweenToValues, 
			mTweenTime, eqf, callbacks);
			
		//mSubject.tween(mTweeningProprties, mTweenToValues, mTweenTime, mTweenType, mTweenDelay, callbacks);
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return true;
	}
	
	public function interrupt() : Void
	{
		mIsRunning = false;
		mTweenManager.removeTween(mSubject, mTweeningProprties);
		dispatchEvent({type:"interrupted", target:this});
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function addCuePoint(aPropertyValueReached:Number, aEventName:String):Void
	{
		mCuePoints.push({position:aPropertyValueReached, event:aEventName});
		mCuePoints.sortOn("position");
	}
	
	//TODO: this should be made in the constructor
	public function setTween(aSubject:Object, aTweeningProprties:Array, aTweenToValues:Array, aTweenTime:Number, aTweenType:String, aTweenDelay:Number)
	{
		mSubject = aSubject;
		mTweeningProprties = aTweeningProprties;
		mTweenToValues = aTweenToValues;
		mTweenTime = aTweenTime;
		mTweenType = aTweenType;
		mTweenDelay = aTweenDelay;
	}	
	
	public function setFadeInTween(aSubject:Object, aTweenTime:Number, aTweenType:String)
	{
		var tweenType:String;
		
		if(aTweenType)
		{
			tweenType = aTweenType;
		}
		else
		{
			tweenType = "linear";
		}
		
		setTween(aSubject, ["_alpha"], [100], aTweenTime, aTweenType, 0);
	}		

	public function setFadeOutTween(aSubject:Object, aTweenTime:Number, aTweenType:String)
	{
		var tweenType:String;
		
		if(aTweenType)
		{
			tweenType = aTweenType;
		}
		else
		{
			tweenType = "linear";
		}
		
		setTween(aSubject, ["_alpha"], [0], aTweenTime, aTweenType, 0);
	}		
	
	
	private function onTweenStarted()
	{
		dispatchEvent({type:"start", target:this});
	}

	private function onTweenUpdate()
	{
		var currentPosition:Number = mSubject[mTweeningProprties[0]];
		
		for(var i:Number = mCuePoints.length - 1; i >= 0; i--)
		{
			if(currentPosition >= mCuePoints[i].position)
			{
				dispatchEvent({type:mCuePoints[i].event, target:this});
				break;
			}
		}
	}

	private function onTweenFinished()
	{
		mIsRunning = false;
		dispatchEvent({type:"completed", target:this});
	}
}