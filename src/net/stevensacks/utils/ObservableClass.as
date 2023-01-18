import mx.events.EventDispatcher;

class net.stevensacks.utils.ObservableClass
{
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	function ObservableClass() {
		EventDispatcher.initialize(this);
	}
}