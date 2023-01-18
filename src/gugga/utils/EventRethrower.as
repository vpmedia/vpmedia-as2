import mx.utils.Delegate;

import gugga.common.IEventDispatcher;

/**
 * TODO: This class should be revised. (think over event bubbling mechanism)
 */

class gugga.utils.EventRethrower
{
	private var mContext:IEventDispatcher;
	private var mDispatcher:IEventDispatcher;
	private var mEvent:String;
	private var mDelegate:Function;
	private var mRethrowOnce : Boolean;
	
	public function get Event() : String
	{
		return mEvent;
	}
	
	public function EventRethrower(aContext:IEventDispatcher, 
		aDispatcher:IEventDispatcher, aEvent:String, aRethrowOnce : Boolean)
	{
		mContext = aContext;
		mDispatcher = aDispatcher;
		mEvent = aEvent;
		mDelegate = Delegate.create(this, forwardEvent);
		mRethrowOnce = aRethrowOnce;
	}
	
	private function forwardEvent(ev)
	{		
		/**
		 * TODO: Should we change the value of ev.target property to mContext?
		 * Shouldn't we also clone event info object before changing the target property.
		 */
		ev.target = mContext;
		mContext.dispatchEvent(ev);
		if(mRethrowOnce)
		{
			stopListening();
		}
	}

	public function startListening():Void
	{
		mDispatcher.addEventListener(mEvent, mDelegate);
	}
	
	public function stopListening():Void
	{
		mDispatcher.removeEventListener(mEvent, mDelegate);
	}
	
	public static function create(aContext:IEventDispatcher, 
		aDispatcher:IEventDispatcher, aEvent:String) : EventRethrower
	{		
		var result : EventRethrower = new EventRethrower(aContext, 
			aDispatcher, aEvent, false);					
		result.startListening();
		
		return result;
	}
	
	public static function createSingleTimeRethrower(aContext:IEventDispatcher, 
		aDispatcher:IEventDispatcher, aEvent:String) : EventRethrower
	{		
		var result : EventRethrower = new EventRethrower(aContext, 
			aDispatcher, aEvent, true);					
		result.startListening();
		
		return result;
	}
}