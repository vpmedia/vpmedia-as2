/**
 * @author todor
 */

import mx.utils.Delegate;

import gugga.common.UIComponentEx;
import gugga.debug.Assertion;
import gugga.utils.DebugUtils;
import gugga.utils.OnEnterFrameBeacon;

import tweens.zigo.TweenManager;
 
[Event("completed")]
class gugga.components.ProgressBar extends UIComponentEx
{
	private var mProgressedProperty:String = "_width";
	private var mProgressedPropertyMaxValue:Number = 100;
	private var mChangeCompletionTime:Number = 0.2; //in seconds
	
	private var mBar:Object;
	private var mProgressPercents:Number = 0;
	private var mFakeProgressPercents : Number = 0;
	private var mBeaconEnterFrameDelegate : Function;
	private var mCurrentPercentsPerFrame : Number;	
	
	private var mTweenManager;

	private var mMinPercentsPerFrame : Number = 0.01;
	public function get MinPercentsPerFrame() : Number { return mMinPercentsPerFrame; }
	public function set MinPercentsPerFrame(aValue:Number) : Void { mMinPercentsPerFrame = aValue; } 
			
	private var mMaxPercentsPerFrame : Number = 2;
	public function get MaxPercentsPerFrame() : Number { return mMaxPercentsPerFrame; }
	public function set MaxPercentsPerFrame(aValue:Number) : Void { mMaxPercentsPerFrame = aValue; }
			
	private var mNormalPercentsPerFrame : Number = 0.6;
	public function get NormalPercentsPerFrame() : Number { return mNormalPercentsPerFrame; }
	public function set NormalPercentsPerFrame(aValue:Number) : Void { mNormalPercentsPerFrame = aValue; }
			
	private var mSensitivePercentsDifference : Number = 25;
	public function get SensitivePercentsDifference() : Number { return mSensitivePercentsDifference; }
	public function set SensitivePercentsDifference(aValue:Number) : Void { mSensitivePercentsDifference = aValue; }
			
	private var mUseFakeSmothness : Boolean = false;
	public function get UseFakeSmothnes() : Boolean { return mUseFakeSmothness; }
	public function set UseFakeSmothnes(aValue:Boolean) : Void { mUseFakeSmothness = aValue; }
			
	public function get ProgressPercents():Number
	{
		return mProgressPercents;
	}

	public function get ProgressedProperty():String
	{
		return mProgressedProperty;
	}

	public function set ProgressedProperty(aValue:String):Void
	{
		mProgressedProperty = aValue;
	}

	public function get ProgressedPropertyMaxValue():Number
	{
		return mProgressedPropertyMaxValue;
	}

	public function set ProgressedPropertyMaxValue(aValue:Number):Void
	{
		mProgressedPropertyMaxValue = aValue;
	}

	public function get ChangeCompletionTime():Number
	{
		return mChangeCompletionTime;
	}

	public function set ChangeCompletionTime(aValue:Number):Void
	{
		mChangeCompletionTime = aValue;
	}
	
	public function get Bar():Object
	{
		if(mBar)
		{
			return mBar;
		}
		else if(this["bar"])
		{
			return mBar;
		}
		else
		{
			Assertion.fail("No Bar instance set", this, arguments);
		}
	}

	public function set Bar(aValue:Object):Void
	{
		mBar = aValue;
	}
	
	//-------------------------------------- actual methods
	
	public function ProgressBar()
	{
		mTweenManager = TweenManager.Instance;
	}
	
	public function progressBy(aPercents:Number)
	{
		progressTo(mProgressPercents + aPercents);
	}

	public function progressFull()
	{
		mFakeProgressPercents = 100;
		progressTo(100);
	}

	public function reset()
	{
		progressTo(0);
	}
	
	public function progressTo(aPercents:Number)
	{
		if(!mBeaconEnterFrameDelegate)
		{
			mBeaconEnterFrameDelegate = Delegate.create(this, onBeaconEnterFrame); 
			OnEnterFrameBeacon.Instance.addEventListener("onEnterFrame", mBeaconEnterFrameDelegate);
		}
		
		if(aPercents < 0)
		{
			aPercents = 0;
		}		
		
		if(aPercents > 100)
		{
			aPercents = 100;
		}		
		
		mProgressPercents = aPercents;
	}
	
	public function forceProgressTo(aPercents:Number)
	{
		mProgressPercents = aPercents;
		mFakeProgressPercents = aPercents;
		onProgressUpdated();
	}
	
	
	private function onProgressUpdated()
	{
		if(mFakeProgressPercents < 0)
		{
			mFakeProgressPercents = 0;
		}		
		
		if(mFakeProgressPercents > 100)
		{
			mFakeProgressPercents = 100;
		}
		
		var barObject : Object = Bar;
		barObject[mProgressedProperty] = (mFakeProgressPercents / 100) * mProgressedPropertyMaxValue;
		
		if(mFakeProgressPercents >= 100)
		{
			DebugUtils.trace("ProgressBar.onBeaconEnterFrame() remove");
			dispatchEvent({type:"completed", target:this});
			OnEnterFrameBeacon.Instance.removeEventListener("onEnterFrame", mBeaconEnterFrameDelegate);
			mBeaconEnterFrameDelegate = null;
		}
	}
	
	private function onBeaconEnterFrame()
	{
		if(mUseFakeSmothness)
		{
			calculateCurrentPercentsPerFrame();
			mFakeProgressPercents += mCurrentPercentsPerFrame;
		}
		else
		{
			if(mProgressPercents > mFakeProgressPercents)
			{
				mFakeProgressPercents = mProgressPercents;
			}
		}
		
		onProgressUpdated();
	}
	
	private function calculateCurrentPercentsPerFrame()
	{
		if(mProgressPercents > mFakeProgressPercents)
		{
			var difference : Number = mProgressPercents - mFakeProgressPercents;
			
			if(difference >= mSensitivePercentsDifference)
			{
				mCurrentPercentsPerFrame = mMaxPercentsPerFrame;				
			}
			else
			{
				var relation : Number = difference / mSensitivePercentsDifference;
				mCurrentPercentsPerFrame = 
					mNormalPercentsPerFrame + ((mMaxPercentsPerFrame - mNormalPercentsPerFrame) * relation); 
			}
			
			if((mProgressPercents != 100) && 
				((100 - mFakeProgressPercents) < mSensitivePercentsDifference) &&
				(mCurrentPercentsPerFrame > mProgressPercents - mFakeProgressPercents))
			{
				mCurrentPercentsPerFrame = mProgressPercents - mFakeProgressPercents;
			}
		}
		else
		{
			if(100 - mFakeProgressPercents < mSensitivePercentsDifference)
			{
				mCurrentPercentsPerFrame = 0;
			}
			else
			{
				mCurrentPercentsPerFrame = mMinPercentsPerFrame;
			}
		}
	}
}