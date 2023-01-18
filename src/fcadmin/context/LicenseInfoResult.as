/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.LicenseSummary;


/**
 * LicenseInfoResult has the ability to handle result from
 * fcadmin.context.Server.getLicenseInfo.
 *
 * @see fcadmin.context.Server#getLicenseInfo
 */

class fcadmin.context.LicenseInfoResult implements IResult
{	
	/**
	 * This method is invoked after the license info return successful.
	 *
	 * @param info The complete license information. 
	 */
	function getLicenseInfoSuccess(info:LicenseSummary):Void{}

	/**
	 * This method is invoked after the license info return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getLicenseInfoFailed(err:StatusObject):Void{}
}