

/**
 * All objects than implement IContainer must have all this function.
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  01/12/2006 
 */
interface com.delfiweb.ui.IContainer
{
	public function attach (mc:MovieClip, d:Number):Void
	
	public function addListener(oInst:Object):Boolean
	public function removeListener(oInst:Object):Boolean
	
	
	public function remove():Boolean
	
	public function destruct():Boolean
	
	public function toString():String
}