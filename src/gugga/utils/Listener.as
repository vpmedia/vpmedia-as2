import mx.utils.Delegate;

import gugga.common.EventDescriptor;
/**
 * @author Barni
 */
class gugga.utils.Listener 
{
	private var mDataObject : Object;
	private var mConsumerDelegate : Function;
	private var mListenOnce : Boolean;
	private var mHandleEventDelegate : Function;
	private var mTargetEventDescriptor : EventDescriptor;
	private var mListening : Boolean;

	public function get Listening() : Boolean
	{
		return mListening;
	}
	
	public function get TargetEventDescriptor() : EventDescriptor
	{
		return mTargetEventDescriptor;
	}
	 
	public function Listener(
			aTargetEventDescriptor : EventDescriptor, 
			aConsumerDelegate : Function, 
			aDataObject : Object, 
			aForwardOnce : Boolean) 
	{
		mTargetEventDescriptor = aTargetEventDescriptor;
		mConsumerDelegate = aConsumerDelegate;
		mDataObject = aDataObject;
		mListenOnce = aForwardOnce;
		
		mHandleEventDelegate = Delegate.create(this, handleEvent);
		mListening = false;
	}
	 
	public function start() : Void
	{
		mListening = true;
		mTargetEventDescriptor.EventSource.addEventListener(
				mTargetEventDescriptor.EventName, 
				mHandleEventDelegate);
	}
	
	public function stop() : Void
	{
		mListening = false;
		mTargetEventDescriptor.EventSource.removeEventListener(
				mTargetEventDescriptor.EventName, 
				mHandleEventDelegate);
	}
	
	private function handleEvent(ev : Object) : Void
	{
		var resultEventObject : Object = new Object();
		
		for(var key : String in ev)
		{
			resultEventObject[key] = ev[key];
		}
		
		for(var key : String in mDataObject)
		{
			if(resultEventObject[key] == null 
				|| resultEventObject[key] == undefined)
			{
				resultEventObject[key] = mDataObject[key];
			}
		}
		
		if(mListenOnce)
		{
			this.stop();
		}
		
		mConsumerDelegate(resultEventObject);
	}
	
	public static function create(
			aTargetEventDescriptor : EventDescriptor, 
			aConsumerDelegate : Function, 
			aDataObject : Object, 
			aForwardOnce : Boolean) : Listener
	{		
		var result : Listener = new Listener(
				aTargetEventDescriptor, 
				aConsumerDelegate, 
				aDataObject, 
				aForwardOnce);					
		result.start();
		
		return result;
	}	
	
	public static function createMergingListener(
			aTargetEventDescriptor : EventDescriptor, 
			aConsumerDelegate : Function, 
			aDataObject : Object) : Listener
	{		
		var result : Listener = new Listener(
				aTargetEventDescriptor, 
				aConsumerDelegate, 
				aDataObject, 
				false);					
		result.start();
		
		return result;
	}	
	
	public static function createSingleTimeListener(
			aTargetEventDescriptor : EventDescriptor, 
			aConsumerDelegate : Function) : Listener
	{		
		var result : Listener = new Listener(
				aTargetEventDescriptor, 
				aConsumerDelegate, 
				null, 
				true);					
		result.start();
		
		return result;
	}	

	public static function createSingleTimeMergingListener(
			aTargetEventDescriptor : EventDescriptor, 
			aConsumerDelegate : Function, 
			aDataObject : Object) : Listener
	{		
		var result : Listener = new Listener(
				aTargetEventDescriptor, 
				aConsumerDelegate, 
				aDataObject, 
				true);					
		result.start();
		
		return result;
	}	
}