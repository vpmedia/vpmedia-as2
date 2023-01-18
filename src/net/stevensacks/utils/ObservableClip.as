import mx.events.EventDispatcher;

class net.stevensacks.utils.ObservableClip extends MovieClip
{
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	function ObservableClip() {
		EventDispatcher.initialize(this);
	}
}