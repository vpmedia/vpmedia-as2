class net.zeusdesign.events.Event
{
	//*** MEMBER VARIABLES ***//
	private var _name:String;
	private var _listeners:Array;
	private var _routes:Array;
	
	//*** CONSTRUCTOR ***//
	function Event(name)
	{
		this._name = name;
		this._listeners = new Array();
		this._routes = new Array();
	}
	
	//*** PUBLIC FUNCTIONS ***//
	public function addListener(listener:Object, routingFunction:String):Void
	{
		var duplicate:Boolean = false;
		for(var i:Number = 0; i < this._listeners.length; i++)
		{
			if(this._listeners[i] == listener)
			{
				duplicate = true;
				break;
			}
		}
		
		if(!duplicate)
		{
			this._listeners.push(listener);
			this._routes.push(routingFunction);	
		}
	}
	
	public function removeListener(listener:Object):Void
	{
		for(var i:Number = 0; i < this._listeners.length; i++)
		{
			if(this._listeners[i] == listener)
			{
				this._listeners.splice(i, 1);
				this._routes.splice(i, 1);
				break;
			}
		}
	}
	
	public function dispatch(args:Array):Void
	{
		for(var i:Number = 0; i < this._listeners.length; i++)
		{
			if(this._routes[i] != undefined)
				this._listeners[i][this._routes[i]].apply(this._listeners[i], args);
			else
				this._listeners[i][this._name].apply(this._listeners[i], args);
		}
	}
	
	//*** GET PROPERTIES ***//
	public function get name():String
	{
		return this._name;
	}
}