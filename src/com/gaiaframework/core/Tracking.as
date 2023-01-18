import flash.external.ExternalInterface;

class com.gaiaframework.core.Tracking
{
	private static var eventQueue:Array = [];
	private static var eventQueueDelay:Number = 500;
	private static var eventQueueInterval:Number;
	
	public static function track():Void
	{
		var event:Object = {args:arguments};
		addTrackEventToQueue(event);
	}
	private static function addTrackEventToQueue(event:Object):Void 
	{
		if (eventQueue.length == 0) 
		{
			clearInterval(eventQueueInterval);
			eventQueueInterval = setInterval(executeNextTrackEvent, eventQueueDelay);
		}
		eventQueue.push(event);
	}
	private static function executeNextTrackEvent():Void 
	{
		if (eventQueue.length == 0) 
		{
			clearInterval(eventQueueInterval);
		}
		else
		{
			ExternalInterface.call.apply(ExternalInterface, eventQueue.shift().args.toString().split(","));
		}
	}
}
