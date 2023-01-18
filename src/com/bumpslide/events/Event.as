//import com.bumpslide.util.Debug;
/**
* Generic event class with support for additional arguments
*/
dynamic class com.bumpslide.events.Event
{
	public var type:String;
	public var target:Object;	
	
	/**
	 * Creates a new event with the name of the event handler and the source of the event.
	 * 
	 * @param t:String - name of event
	 * @param trgt:Object - target/source of event
	 * @param params:Object - map of aditional parameters to apply to this event
	 */
	function Event (t:String, trgt:Object, params:Object) {
		
		//Debug.warn('*EVENT* '+t);
		
		type = t;
		target = trgt;
		
		if(params!=null) {
			for(var prop:String in params) {
				this[prop] = params[prop];
			}
		}
	}
}