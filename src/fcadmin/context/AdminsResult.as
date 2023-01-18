/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-14
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * AdminsResult has the ability to handle result from
 * fcadmin.context.Server.getAdmins or 
 * fcadmin.context.VHost.getAdmins.
 *
 * @see fcadmin.context.Server#getAdmins
 * @see fcadmin.context.VHost#getAdmins
 */
class fcadmin.context.AdminsResult implements IResult
{
	/**
	 * This method is invoked after the admin list return successful.
	 *
	 * @param vhosts A array of admin defined for the specified server/vhost. 
	 * @see fcadmin.context.Admin
	 */
	function getAdminsSuccess(admins:Array):Void{}

	/**
	 * This method is invoked after the admin list return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getAdminsFailed(err:StatusObject):Void{}
}
