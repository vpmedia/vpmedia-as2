/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * CommandResult has the ability to handle result from command 
 * which do not have success result parameter.
 */

class fcadmin.context.CommandResult implements IResult
{	
	/**
	 * This method is invoked after the command return successful.
	 */
	function success():Void{}

	/**
	 * This method is invoked after the command return falied.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function failed(err:StatusObject):Void{}
}