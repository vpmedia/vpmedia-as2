class eu.orangeflash.events.EffectEvent
{
	public static var BEGIN:String 		     = "begin";
	public static var COMPLETE:String 		 = "complete";
	public static var STOP:String 			 = "stop";
	public static var UNIT_COMPLETE:String	 = "unitComplete";
	public static var CHANGE:String			 = "change";
	public static var UNIT_BEGIN:String      = "unitBegin";
	
	public var type:String;
	public var target:Object;
	
	public function EffectEvent(type:String, target:Object)
	{
		this.type = type;
		this.target = target;
	}
}