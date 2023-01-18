/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-19
 ******************************************************************************/


import fcadmin.AdminConnection;




/**
 * IAdminContext provide the ability to query or execute command
 * via the Server Management ActionScript API.
 */
interface fcadmin.context.IAdminContext
{


	/**
	 * Return the host connection for this context.
	 */
	function getHostConnection():AdminConnection;


	

	/**
	 * Invoke a context mathod on the server side.
	 *
	 * @useage <code>Service</code>.callService(<code><em>serviceMethodName</em>,<em>resultObject</em> | null[<em>, p1,...,pN</em>]</code>);
	 *
	 * @param serviceMethodName The method to execute.
	 * @param resultObject A parameter defined according to the statu message. 
	 *			See the individual method for more information.
	 * @param p1,...pN Optional parameters to be passed to the specified method. 
	 *			See the individual method for more information.
	 */
	function callService():Void;


}
 