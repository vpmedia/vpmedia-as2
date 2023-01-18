/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;

import fcadmin.data.AppStats;


/**
 * VHostStatsResult has the ability to handle result from
 * fcadmin.context.App.getStats.
 *
 * @see fcadmin.context.App#getStats
 */

class fcadmin.context.AppStatsResult implements IResult
{	
	/**
	 * This method is invoked after the app stats return successful.
	 *
	 * @param stats The performance data for a specified instance 
	 *		of an application.
	 */
	function getStatsSuccess(stats:AppStats):Void{}


	/**
	 * This method is invoked after the app stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}