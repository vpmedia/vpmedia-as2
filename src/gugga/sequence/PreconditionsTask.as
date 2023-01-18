import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.common.ITask;
import gugga.sequence.IPreconditionsManager;
import gugga.sequence.PreconditionsManager;

[Event("start")]
[Event("interrupted")]
[Event("completed")]
[Event("preconditionsMet")]

/**
 * TODO: Create Acceptable and Ignoring Preconditions Manager, TaskManager, PreconditionsTask 
 */

/**
 * <code>PreconditionsTask</code> class is simply a task-wrapper for 
 * <code>IPreconditionsManager</code> objects. <code>PreconditionsTask</code> 
 * is initialized with an already existing <code>IPreconditionsManager</code> 
 * object through the <code>PreconditionsTask</code> constructor. This 
 * <code>IPreconditionsManager</code> object can already containt several 
 * preconditions, or these preconditions could be added through the wrapped 
 * functionallity of the <code>IPreconditionsManager</code> object. 
 * <p>
 * <code>PreconditionsTask</code> will fire event <b><i>completed</i></b> only if: 
 * <ul>
 * 	<li><code>PreconditionsTask</code> is started with its <code>start()</code> method</li>
 * 	<li><code>PreconditionsTask</code> is not interrupted with its <code>interrupt()</code> method</li>
 * 	<li>all preconditions are met</li>
 * </ul>
 * <p>
 * <b>IMPORTANT NOTICE!!!</b>
 * Future version of <code>PreconditionsTask</code> should reconsider the need 
 * for implementing the <code>IPreconditionsManager</code> interface. The 
 * <code>IPreconditionsManager</code> wrapped object could be exposed through 
 * <code>public</code> property. This way all managing responsibilities will be 
 * delegated to the <code>IPreconditionsManager</code> object, and its 
 * functionallity will be no longer wrapped up in 
 * <code>PreconditionsTask</code>.
 * 
 * @author Barni
 * @see IPreconditionsManager
 * @see PreconditionsManager
 * @see guggaLibTests.PreconditionsTaskTest
 */
class gugga.sequence.PreconditionsTask 
		extends EventDispatcher 
		implements ITask, IPreconditionsManager 
{
	private var mWrappedManager : IPreconditionsManager;
	private var mIsRunning : Boolean;
	private var mResetBeforeStart : Boolean;
	
	public function get PreconditionsMet() : Boolean
	{
		return getPreconditionsMet();
	}
	
	public function get Accepting() : Boolean
	{
		return isAccepting();
	}
	
	public function PreconditionsTask(aWrappedManager : IPreconditionsManager)
	{
		mIsRunning = false;
		mResetBeforeStart = false;
		
		if(aWrappedManager)
		{
			mWrappedManager = aWrappedManager;
		}
		else
		{
			mWrappedManager = new PreconditionsManager();
		}
		
		mWrappedManager.addEventListener(
				"preconditionsMet", 
				Delegate.create(this, onPreconditionsMet));
	}

	public function start() : Void 
	{
		mIsRunning = true;
		if(mResetBeforeStart)
		{
			reset();
		}

		dispatchEvent({type : "start", target : this});
		
		if(PreconditionsMet)
		{
			mIsRunning = false;
			dispatchEventLater({type : "completed", target : this});
		}
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
	
	public function isImmediatelyInterruptable() : Boolean 
	{
		return true;
	}

	public function interrupt() : Void 
	{
		mIsRunning = false;
		mResetBeforeStart = true;
		/**
		 * TODO: This will change Accepting of the manager to false
		 */
		ignoreAll();
		dispatchEvent({type : "interrupted", target : this});
	}

	public function isAccepting() : Boolean 
	{
		return mWrappedManager.isAccepting();
	}

	public function getPreconditionsMet() : Boolean 
	{
		return mWrappedManager.getPreconditionsMet();
	}

	public function add(aPrecondition : EventDescriptor) : Void 
	{
		mWrappedManager.add(aPrecondition);
	}

	public function remove(aPrecondition : EventDescriptor) : Void 
	{
		mWrappedManager.remove(aPrecondition);
	}

	public function removeByEventSource(aEventSource : IEventDispatcher) : Void 
	{
		mWrappedManager.removeByEventSource(aEventSource);
	}

	public function replace(
			aPrecondition : EventDescriptor, 
			aNewPrecondition : EventDescriptor) : Void 
	{
		mWrappedManager.replace(aPrecondition, aNewPrecondition);
	}

	public function replaceEventSource(
			aEventSource : IEventDispatcher, 
			aNewEventSource : IEventDispatcher) : Void 
	{
		mWrappedManager.replaceEventSource(aEventSource, aNewEventSource);
	}

	public function contains(aPrecondition : EventDescriptor) : Boolean 
	{
		return mWrappedManager.contains(aPrecondition);
	}

	public function accept(aPrecondition : EventDescriptor) : Void 
	{
		mWrappedManager.accept(aPrecondition);
	}
	
	public function acceptEventSource(aEventSource : IEventDispatcher) : Void 
	{
		mWrappedManager.acceptEventSource(aEventSource);
	}

	public function acceptAll() : Void 
	{
		mWrappedManager.acceptAll();
	}

	public function ignore(aPrecondition : EventDescriptor) : Void 
	{
		mWrappedManager.ignore(aPrecondition);
	}
	
	public function ignoreEventSource(aEventSource : IEventDispatcher) : Void 
	{
		mWrappedManager.ignoreEventSource(aEventSource);
	}

	public function ignoreAll() : Void 
	{
		mWrappedManager.ignoreAll();
	}

	public function reset() : Void 
	{
		mWrappedManager.reset();
		mResetBeforeStart = false;
	}

	private function onPreconditionsMet() : Void 
	{
		dispatchEvent({type : "preconditionsMet", target : this});
		
		if(mIsRunning)
		{
			mIsRunning = false;
			mResetBeforeStart = true;
			dispatchEvent({type : "completed", target : this});
		}
	}
}