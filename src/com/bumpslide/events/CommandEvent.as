import com.bumpslide.util.Debug;
import com.bumpslide.util.ObjectUtil;
/**
* Simple Event with optional arguments
* 
*/
class com.bumpslide.events.CommandEvent extends com.bumpslide.events.Event
{
	
	public var type:String;
	public var target:Object;	
	public var arg:Object;
	
	/**
	* Creates a new command event
	* 
	* any additional arguments are stored as event.args
	*/
	function CommandEvent(t:String, src:Object, extraArg:Object)
	{
		type = t;
		target = src;
		arg = extraArg;
		
		//Debug.info( this.toString() );
		//Debug.info( arg );
	}
	
	function toString() : String {
		var s = '[CommandEvent] "'+type+'" ';
		if(arg!=null) s += arg;
		return s;
	}
}
