interface net.zeusdesign.events.IBroadcaster
{
	public function addEventListener(event:String, listener:Object, routingFunction:String):Void;
	public function removeEventListener(event:String, listener:Object):Void;
	public function addListener(listener:Object):Void;
	public function removeListener(listener:Object):Void;
}