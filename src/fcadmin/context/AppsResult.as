/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * AppsResult has the ability to handle result from
 * fcadmin.context.VHost.getApps.
 *
 * @see fcadmin.context.VHost#getApps
 */

class fcadmin.context.AppsResult implements IResult
{	
	/**
	 * This method is invoked after the app list return successful.
	 *
	 * @param apps A array of all the applications that are installed
	 *		on the specified vhost. 
	 * @see fcadmin.context.App
	 */
	function getAppsSuccess(apps:Array):Void{}

	/**
	 * This method is invoked after the app list return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getAppsFailed(err:StatusObject):Void{}
}