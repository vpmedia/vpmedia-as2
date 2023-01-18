import gugga.common.IEventDispatcher;
/**
 * @author Barni
 */
class gugga.common.EventDescriptor
{
	private var mEventSource : IEventDispatcher;
	private var mEventName : String;
	
	public function get EventSource() : IEventDispatcher
	{
		return mEventSource;
	}

	public function get EventName() : String
	{
		return mEventName;
	}
	
	public function EventDescriptor(aEventSource : IEventDispatcher, aEventName : String)
	{
		mEventSource = aEventSource;
		mEventName = aEventName;
	}
	
	public function equals(aTarget : EventDescriptor) : Boolean
	{
		return ((mEventSource === aTarget.EventSource) && (mEventName == aTarget.EventName)); 
	}
}