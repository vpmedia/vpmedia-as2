

/**
 * All objects than implement IDisplayObject have all this method.
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  01/12/2006 
 */
interface com.delfiweb.display.IDisplayObject
{
	public function attach (mc:MovieClip, d:Number):MovieClip
	
	public function addListener(oInst:Object):Boolean
	
	public function removeListener(oInst:Object):Boolean
	
	public function remove():Boolean
	
	public function destruct():Boolean
	
	public function toString():String
}