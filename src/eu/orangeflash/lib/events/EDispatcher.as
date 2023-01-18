import mx.events.EventDispatcher;
class eu.orangeflash.lib.events.EDispatcher extends MovieClip{
	//инициализируем EventDispatcher
	private static var ___initEventDispatcher = EventDispatcher.initialize(eu.orangeflash.lib.events.EDispatcher.prototype);
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
}