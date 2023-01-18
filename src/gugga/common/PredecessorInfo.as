import gugga.common.IEventDispatcher;
/**
 * @author Barni
 */
class gugga.common.PredecessorInfo {

	public var EventSource:IEventDispatcher;
	public var EventName:String;
	
	public function PredecessorInfo(aEventSource:IEventDispatcher, aEventName:String)
	{
		EventSource = aEventSource;
		EventName = aEventName;
	}
}