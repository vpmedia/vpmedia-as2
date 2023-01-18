/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-7
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * PingResult has the ability to handle result from
 * fcadmin.context.Server.ping.
 *
 * @see fcadmin.context.Server#ping
 */

class fcadmin.context.PingResult implements IResult
{	
	/**
	 * This method is invoked after the ping stats return successful.
	 *
	 * @param timestamp indicates the time that the command was executed.
	 */
	function pingSuccess(timestamp:Date):Void{}

	/**
	 * This method is invoked after the ping stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function pingFailed(err:StatusObject):Void{}
}
