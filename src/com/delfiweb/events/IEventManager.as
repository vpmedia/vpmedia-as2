

/**
 * All objects than implement IDisplayObject have all this method.
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  01/12/2006 
 */
interface com.delfiweb.events.IEventManager
{
	
	public function addListener (oInst:Object):Boolean;

	public function removeListener (oInst:Object):Boolean;
	
	public function removeAllListeners():Boolean;
	
	public function broadcastEvent (sEvent:String, oObj:Object):Void;
	
}
	