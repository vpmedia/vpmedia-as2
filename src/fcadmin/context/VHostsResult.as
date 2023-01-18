/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * VHostsResult has the ability to handle result from
 * fcadmin.context.Adaptor.getVHosts.
 *
 * @see fcadmin.context.Adaptor#getVHosts
 */
class fcadmin.context.VHostsResult implements IResult
{
	/**
	 * This method is invoked after the vhost list return successful.
	 *
	 * @param vhosts A array of vhost defined for the specified adaptor. 
	 * @see fcadmin.context.VHost
	 */
	function getVHostsSuccess(vhosts:Array):Void{}

	/**
	 * This method is invoked after the vhost list return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getVHostsFailed(err:StatusObject):Void{}
}
