

/**
 * All objects than implement IForm must have all this function.
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  01/12/2006 
 */
interface com.delfiweb.form.IForm
{
	public function attach (mc:MovieClip, d:Number):Void
	
	public function remove():Boolean
	
	public function destruct():Boolean
	
	public function toString():String
}