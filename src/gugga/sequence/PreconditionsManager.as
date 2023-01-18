import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.collections.CheckList;
import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.crypt.GUID;
import gugga.debug.Assertion;
import gugga.sequence.IPreconditionsManager;
import gugga.utils.DelayedCallTimeout;
import gugga.utils.Listener;

[Event("preconditionsMet")]
/**
 * <code>PreconditionsManager</code> is a checklist and manager for 
 * preconditions. Precondition is an <code>EventDescriptor</code> for an event 
 * that we expect to be raised at some point in time. When this event is raised 
 * the <code>PreconditionsManager</code> marks the precondition as checked in 
 * the preconditions checklist.
 * <p> 
 * When creating the <code>PreconditionsManager</code> through its constructor 
 * it can be set as <b><i>accepting</i></b> or as <b><i>unaccepting</i></b>. 
 * When <code>PreconditionsManager</code> is set as <b><i>unaccepting</i></b> 
 * it will not listen for the newly added preconditions, unless explicitly this 
 * precondition is <b><i>accepted</i></b>, which can be accomplished with the 
 * <code>accept(aPrecondition : EventDescriptor)</code> and 
 * <code>acceptEventSource(aEventSource : IEventDispatcher)</code> methods.
 * <p>
 * Example for an unaccepting <code>PreconditionsManager</code>:
 * <code>
 * 		import gugga.sequence.PreconditionsManager;
 * 		import gugga.common.EventDescriptor;
 * 		import gugga.common.IEventDispatcher;
 * 		
 * 		var isAccepting:Boolean = false;
 * 		var preconditionsManager:PreconditionsManager
 * 			= new PreconditionsManager(isAccepting);
 * 		
 * 		var eventSource:IEventDispatcher = new SomeEventSource();
 * 		var precondition:EventDescriptor = new EventDescriptor(
 * 				eventSource, 
 * 				"someEvent");
 * 		
 * 		preconditionsManager.add(precondition);
 * 		
 * 		// Now precondition is added to the checklist, but preconditionsManager  
 * 		// is still not listening for the described event. To start a listener 
 * 		// for the described event, additional function call is needed:
 * 		preconditionsManager.accept(precondition);
 * 		
 * 		// The second way to accomplish this is:
 * 		preconditionsManager.acceptEventSource(eventSource);
 * </code>
 * <p>
 * <code>acceptAll()</code> method will set the 
 * <code>PreconditionsManager</code> as <b><i>accepting</i></b> and will start 
 * listeners for all preconditions in the checklist. 
 * <p>
 * <code>ignoreAll()</code> method will set the 
 * <code>PreconditionsManager</code> as <b><i>unaccepting</i></b> and will 
 * stop all started listeners. 
 * <p>
 * To check the current <b><i>accepting</i><b> state of the 
 * <code>PreconditionsManager</code> use the <code>Accepting</code> property or 
 * the <code>isAccepting()</code> method.
 * <p>
 * When all of the preconditions are met, the <code>PreconditionsManager</code> 
 * fires the <b><i>preconditionsMet</i></b> event.
 * <p>
 * The <code>PreconditionsManager</code> is not a task, and in order to dispach 
 * <b><i>completed</i></b> event it is wrapped up in the  
 * <code>PreconditionsTask</code> class, which listens for the 
 * <b><i>preconditionsMet</i></b> event.
 * 
 * @author todor
 * @see IPreconditionsManager
 * @see PreconditionsTask
 * @see guggaLibTests.PreconditionsManagerTest
 */
class gugga.sequence.PreconditionsManager 
		extends EventDispatcher 
		implements IPreconditionsManager
{
	private var mListeners : HashTable;
	private var mPreconditions : CheckList;
	private var mAccepting : Boolean;
	
	public function get PreconditionsMet() : Boolean
	{
		return getPreconditionsMet();
	}
	
	public function get Accepting() : Boolean
	{
		return isAccepting();
	}
	
	public function PreconditionsManager(aAccepting : Boolean)
	{
		mPreconditions = new CheckList();
		mListeners = new HashTable();
		
		/**
		 * Simulation of overloading
		 */
		if(aAccepting != undefined)
		{
			mAccepting = aAccepting;
		}
		else
		{
			mAccepting = true;
		}
	}
	
	public function getPreconditionsMet() : Boolean
	{
		return mPreconditions.isCompleted();
	}
	
	public function isAccepting() : Boolean 
	{
		return mAccepting;
	}
	
	public function accept(aPrecondition : EventDescriptor) : Void 
	{
		var key : String = getKeyByPrecondition(aPrecondition);
		if(key != null)
		{
			var listener : Listener = Listener(mListeners[key]);
			listener.start();
		}
	}
	
	public function acceptEventSource(aEventSource : IEventDispatcher) : Void 
	{
		for (var key : String in mListeners)
		{
			var listener : Listener = Listener(mListeners[key]);
			if(listener.TargetEventDescriptor.EventSource == aEventSource)
			{
				listener.start();
			}
		}
	}

	public function acceptAll() : Void 
	{
		mAccepting = true;
		var notMetPreconditions : Array = mPreconditions.UncheckedObjects;
		for (var i : Number = 0; i < notMetPreconditions.length; i++)
		{
			var key : String = String(notMetPreconditions[i]);
			var listener : Listener = Listener(mListeners[key]);
			listener.start();
		}
	}

	public function ignore(aPrecondition : EventDescriptor) : Void 
	{
		var key : String = getKeyByPrecondition(aPrecondition);
		if(key != null)
		{
			var listener : Listener = Listener(mListeners[key]);
			listener.stop();
		}
	}
	
	public function ignoreEventSource(aEventSource : IEventDispatcher) : Void 
	{
		for (var key : String in mListeners)
		{
			var listener : Listener = Listener(mListeners[key]);
			if(listener.TargetEventDescriptor.EventSource == aEventSource)
			{
				listener.stop();
			}
		}
	}
	
	public function ignoreAll() : Void 
	{
		mAccepting = false;
		var notMetPreconditions : Array = mPreconditions.UncheckedObjects;
		for (var i : Number = 0; i < notMetPreconditions.length; i++)
		{
			var key : String = String(notMetPreconditions[i]);
			var listener : Listener = Listener(mListeners[key]);
			listener.stop();
		}
	}
	
	public function add(aPrecondition : EventDescriptor) : Void
	{
		Assertion.warningIfReturnsTrue(
				this, contains, [aPrecondition],
				"Precondition (source : " + aPrecondition.EventSource + ", event : " + aPrecondition.EventName + ") " + "already added", this, arguments);
				
		var key : String = generateKey();
		var listener : Listener = new Listener(
				aPrecondition, 
				Delegate.create(this, onPreconditionMet), 
				{key : key}, 
				true);
			
		if(mAccepting)
		{
			listener.start();		
		}
		mListeners.add(key, listener);
		mPreconditions.add(key);
	}
	
	public function remove(aPrecondition : EventDescriptor) : Void
	{
		var key : String = getKeyByPrecondition(aPrecondition);
		if(key != null)
		{
			var listener : Listener = Listener(mListeners.remove(key));
			listener.stop();
			mPreconditions.remove(key);
			scheduleStatusChecking();
		}
	}
	
	public function removeByEventSource(aEventSource : IEventDispatcher) : Void
	{
		for (var key : String in mListeners)
		{
			var listener : Listener = Listener(mListeners[key]);
			if(listener.TargetEventDescriptor.EventSource == aEventSource)
			{
				mListeners.remove(key);
				listener.stop();
				mPreconditions.remove(key);
				scheduleStatusChecking();
			}
		}
	}
	
	public function replace(
			aPrecondition : EventDescriptor, 
			aNewPrecondition : EventDescriptor) : Void
	{
		var key : String = getKeyByPrecondition(aPrecondition);
		if(key != null)
		{
			replaceByKey(key, aNewPrecondition);
		}
	}
	
	public function replaceEventSource(
			aEventSource : IEventDispatcher, 
			aNewEventSource : IEventDispatcher) : Void
	{
		for (var key : String in mListeners)
		{
			var listener : Listener = Listener(mListeners[key]);
			var descriptor : EventDescriptor = listener.TargetEventDescriptor;
			if(descriptor.EventSource == aEventSource)
			{
				replaceByKey(
						key, 
						new EventDescriptor(aNewEventSource, descriptor.EventName));
			}
		}
	}
	
	private function replaceByKey(
			aKey : String, 
			aPrecondition : EventDescriptor) : Void
	{
		var listener : Listener = Listener(mListeners[aKey]);
		var newListener : Listener = new Listener(
				aPrecondition, 
				Delegate.create(this, onPreconditionMet), 
				{key : aKey}, 
				true);
		mListeners[aKey] = newListener;
		
		if(listener.Listening)
		{
			newListener.start();
		}	
		listener.stop();
	}
	
	public function contains(aPrecondition : EventDescriptor) : Boolean
	{
		return (getKeyByPrecondition(aPrecondition) != null);
	}
	
	/**
	 *  <code>reset()</code> has slightly unexpected behaviour. It resets the 
	 *  preconditions checklist - already met preconditions are unchecked and 
	 *  marked as uncompleted. Then it starts listeners for <b><i>all</i></b> 
	 *  preconditions in the checklist, without taking into consideration the 
	 *  <b><i>accepting</i></b> state of the <code>PreconditionsManager</code>. 
	 *  This simply means that <code>reset()</code> will start listeners for 
	 *  preconditions that need to be explicitly set as <b><i>accepted</i></b> 
	 *  through the <code>accept(aPrecondition : EventDescriptor)</code> and 
	 *  <code>acceptEventSource(aEventSource : IEventDispatcher)</code> methods. 
	 *  <p>
	 *  <b>IMPORTANT NOTICE!!!</b>
	 *  <p>
	 *  The current <code>reset()</code> method is more like a 
	 *  <code>resetAcceptAllAndRetainCurrentAcceptingState()</code> method. 
	 *  Future versions should consired the introduction of an additional 
	 *  method, with the name <code>restart()</code>. 
	 *  The <code>restart()</code> method will reset the preconditions 
	 *  checklist, and will attempt to start listeners for all preconditions, 
	 *  including already met(completed) preconditions and it will take into 
	 *  consideration the precondition's <b><i>accept</i></b> state. It will 
	 *  start listeners only for the preconditions that do not need to be set 
	 *  explicitly as <b><i>accepting</i></b>. This implies the introduction of 
	 *  a <code>Precondition</code> object, that will store an 
	 *  <code>EventDescriptor</code> and an <b><i>accepting</i></b> state for 
	 *  this precondition.
	 */
	public function reset() : Void
	{
		var isAccepting:Boolean = this.mAccepting;
		mPreconditions.reset();
		acceptAll();
		this.mAccepting = isAccepting;
	}
	
	private function generateKey() : String
	{
		var result : String = GUID.create();
		while(mListeners.containsKey(result))
		{
			result = GUID.create();	
		}
		return result;
	}
	
	private function getKeyByPrecondition(aPrecondition : EventDescriptor) : String
	{
		var result : String = null;
		
		for (var key : String in mListeners)
		{
			var item : Listener = Listener(mListeners[key]);
			
			if(item.TargetEventDescriptor.equals(aPrecondition))
			{
				result = key;
				break;
			}
		}
		
		return result;
	}
	
	private function scheduleStatusChecking() : Void
	{
		var delayedCAllTimeout:DelayedCallTimeout = 
			new DelayedCallTimeout(10, this, this.checkStatus);
	}
	
	private function checkStatus() : Void
	{
		if(mPreconditions.isCompleted())
		{
			dispatchEvent({type : "preconditionsMet", target : this});
		}
	}
	
	private function onPreconditionMet(ev) : Void
	{
		var key : String = String(ev.key);
		mPreconditions.check(key);
		
		checkStatus();
	}
}