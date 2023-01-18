/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation  
 * Last modified:
 *        2004-12-2
 ******************************************************************************/

/**
 * @deprecated will use standard classes if available
 */
class fcadmin.context.PermissionError extends Error
{
	public var name:String = "PermissionError";
	public var message:String = "";

	public function PermissionError(message:String)
	{
		super();
		this.message = message;
	}
	
	public function toString():String
	{
		return "[" + this.name + "] " + this.message;
	}
}