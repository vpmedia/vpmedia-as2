/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * UsersResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getUsers.
 *
 * @see fcadmin.context.ActiveInstance#getUsers
 */

class fcadmin.context.UsersResult implements IResult
{	
	/**
	 * This method is invoked after the users return successful.
	 *
	 * @param users An array of users who are connected to the 
	 *		specified instance of an application.
	 * @see fcadmin.context.User
	 */
	function getUsersSuccess(users:Array):Void{}

	/**
	 * This method is invoked after the users return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getUsersFailed(err:StatusObject):Void{}
}
