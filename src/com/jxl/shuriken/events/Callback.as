import com.jxl.shuriken.events.Event;

class com.jxl.shuriken.events.Callback
{
	public var scope:Object;
	public var callback:Function;
	
	public function Callback(p_scope:Object, p_callback:Function)
	{
		if(p_scope == null) return;
		scope			= p_scope;
		callback		= p_callback;
	}
	
	public function dispatch(p_event:Event):Void
	{
		if(scope == null) return;
		callback.call(scope, p_event);
	}
}