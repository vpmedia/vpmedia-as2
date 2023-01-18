import net.zeusdesign.events.Event;
import net.zeusdesign.events.IBroadcaster;

class net.zeusdesign.events.EventManager
	implements IBroadcaster
{
	//*** STATIC FUNCTIONS ***//
	
	//EventManager can optionally add mixins as a singleton
	public static function initialize(target:Object):Void
	{
		target._eventManager = new EventManager();
		
		target.addEventListener = function(event:String, listener:Object, routingFunction:String):Void
		{
			this._eventManager.addEventListener(event, listener, routingFunction);
		}
		
		target.removeEventListener = function(event:String, listener:Object):Void
		{
			this._eventManager.removeEventListener(event, listener);
		}
		
		target.addListener = function(listener:Object):Void
		{
			this._eventManager.addListener(listener);
		}
		
		target.removeListener = function(listener:Object):Void
		{
			this._eventManager.removeListener(listener);
		}
	}
	
	//*** MEMBER VARIABLES ***//
	private var _events:Array;
	
	//*** CONSTRUCTOR ***//
	function EventManager()
	{
		this._events = new Array();
	}
	
	//*** PUBLIC FUNCTIONS ***//
	public function addEvent(eventName:String):Void
	{
		var duplicate:Boolean = false;
		for(var i:Number = 0; i < this._events.length; i++)
		{
			if(this._events[i].name == eventName)
			{
				duplicate = true;
				break;
			}
		}
		
		if(!duplicate)
		{
			var tempEvent:Event = new Event(eventName);
			this._events.push(tempEvent);
		}
	}
	
	public function removeEvent(eventName:String):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			if(this._events[i].name == eventName)
			{
				this._events.splice(i, 1);
				break;
			}
		}
	}
	
	public function addEventListener(eventName:String, listener:Object, routingFunction:String):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			if(this._events[i].name == eventName)
			{
				this._events[i].addListener(listener, routingFunction);
				break;
			}
		}
	}
	
	public function removeEventListener(eventName:String, listener:Object):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			if(this._events[i].name == eventName)
			{
				this._events[i].removeListener(listener);
				break;
			}
		}
	}
	
	public function addListener(listener:Object):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			this._events[i].addListener(listener);
		}
	}
	
	public function removeListener(listener:Object):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			this._events[i].removeListener(listener);
		}
	}
	
	public function dispatchEvent(eventName:String, args:Array):Void
	{
		for(var i:Number = 0; i < this._events.length; i++)
		{
			if(this._events[i].name == eventName)
			{
				this._events[i].dispatch(args);
				break;
			}
		}
	}
}