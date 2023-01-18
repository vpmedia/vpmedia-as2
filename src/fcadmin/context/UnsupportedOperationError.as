/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation.
 * Last modified:
 *        2004-12-10
 ******************************************************************************/


/**
 * @deprecated will use standard classes if available
 */
class fcadmin.context.UnsupportedOperationError extends Error
{
	public var name:String = "UnsupportedOperationError";
	public var message:String;

	public function UnsupportedOperationError(message:String)
	{
		super();
		this.message = message;
	}
	
	public function toString():String
	{
		return "[" + this.name + "] " + this.message;
	}
}