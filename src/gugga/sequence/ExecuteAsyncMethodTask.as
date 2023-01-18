import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.common.ITask;
import gugga.utils.Listener;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
/**
 * An <code>ExecuteAsyncMethodTask</code> object is initialized with the 
 * <code>static</code> methods <code>create()</code> and 
 * <code>createBasic()</code> which expect the following parameters:
 * <ul>
 * 	<li><code>EventDescriptor</code> object or event name, which specifies the event that should be raised in order to fire event <b><i>completed</i><b> for this <code>ExecuteAsyncMethodTask</code></li>
 * 	<li>method scope</li>
 * 	<li>method function (usually we expect that this method function will raise the event we are subscribed to)</li>
 * 	<li>array of arguments for the method function</li>
 * </ul>
 * 
 * @author todor
 */
class gugga.sequence.ExecuteAsyncMethodTask 
		extends EventDispatcher 
		implements ITask 
{
	private var mIsRunning:Boolean;
	
	private var mIsInterrupt:Boolean;
	
	private var mCompletionEventInfo : EventDescriptor;
	private var mMethodScope:Object;
	private var mMethodFunction:Function;
	
	private var mMethodArguments : Array;
	public function get MethodArguments() : Array { return mMethodArguments; }
	public function set MethodArguments(aValue : Array) : Void { mMethodArguments = aValue; }
	
	private function ExecuteAsyncMethodTask(
			aCompletionEventInfo:EventDescriptor, 
			aMethodScope:Object, 
			aMethodFunction:Function, 
			aMethodArguments:Array) 
	{
		mIsRunning = false;
		mCompletionEventInfo = aCompletionEventInfo;
		mMethodScope = aMethodScope;
		mMethodFunction = aMethodFunction;
		mMethodArguments = aMethodArguments;
	}
	
	public function start() : Void 
	{
		mIsRunning = true;
		mIsInterrupt = false;
		dispatchEvent({type:"start", target:this});
		
		/**
		 *	Modified in order to handle case when method dispatch the event synchronic with method's call. 
		 */
		Listener.createSingleTimeListener(
					mCompletionEventInfo, 
					Delegate.create(this, onMethodCompleted));
		mMethodFunction.apply(mMethodScope, mMethodArguments);
	}
	
	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function isImmediatelyInterruptable() : Boolean
	{
		return false;
	}
	
	/**
	 * On <code>interrupt()</code> <code>ExecuteAsyncMethodTask</code> will not 
	 * fire immediately <b><i>interrupted</i></b> event. This event will be 
	 * raised instead of the <b><i>completed</i></b> event, and 
	 * <b><i>completed</i></b> event won't be raised at all. 
	 */
	public function interrupt() : Void
	{
		mIsInterrupt = true;
	}
	
	private function onMethodCompleted(ev) : Void
	{
		mIsRunning = false;
		if(mIsInterrupt)
		{
			dispatchEvent({type:"interrupted", target:this});
		}
		else
		{
			dispatchEventLater({type:"completed", target:this});
		}
	}
	
	public static function create(
			aCompletionEventInfo:EventDescriptor, 
			aMethodScope:Object, 
			aMethodFunction:Function, 
			aMethodArguments:Array) : ExecuteAsyncMethodTask
	{
		var result = new ExecuteAsyncMethodTask(
				aCompletionEventInfo, 
				aMethodScope, 
				aMethodFunction, 
				aMethodArguments);
		return result;
	}
	
	public static function createBasic(
			aCompletionEventName:String, 
			aMethodScope:IEventDispatcher, 
			aMethodFunction:Function, 
			aMethodArguments:Array) : ExecuteAsyncMethodTask
	{
		var completionEventInfo:EventDescriptor 
			= new EventDescriptor(aMethodScope, aCompletionEventName);
		var result = new ExecuteAsyncMethodTask(
				completionEventInfo, 
				aMethodScope, 
				aMethodFunction, 
				aMethodArguments);
		return result;
	}
}