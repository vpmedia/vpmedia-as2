import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;

[Event("preconditionsMet")]

/**
 * @author Barni
 */
interface gugga.sequence.IPreconditionsManager extends IEventDispatcher
{
	public function isAccepting() : Boolean;
	public function getPreconditionsMet() : Boolean;
	public function add(aPrecondition : EventDescriptor) : Void;
	public function remove(aPrecondition : EventDescriptor) : Void;
	public function removeByEventSource(aEventSource : IEventDispatcher) : Void;
	public function replace(aPrecondition : EventDescriptor, aNewPrecondition : EventDescriptor) : Void;
	public function replaceEventSource(aEventSource : IEventDispatcher, aNewEventSource : IEventDispatcher) : Void;
	public function contains(aPrecondition : EventDescriptor) : Boolean;
	public function accept(aPrecondition : EventDescriptor) : Void;
	public function acceptEventSource(aEventSource : IEventDispatcher) : Void;
	public function acceptAll() : Void;
	public function ignore(aPrecondition : EventDescriptor) : Void;
	public function ignoreEventSource(aEventSource : IEventDispatcher) : Void;
	public function ignoreAll() : Void;
	public function reset() : Void;
}