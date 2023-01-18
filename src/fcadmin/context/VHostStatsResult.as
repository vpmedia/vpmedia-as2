/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.VHostStats;

/**
 * VHostStatsResult has the ability to handle result from
 * fcadmin.context.VHost.getStats.
 *
 * @see fcadmin.context.VHost#getStats
 */

class fcadmin.context.VHostStatsResult implements IResult
{	
	/**
	 * This method is invoked after the vhost stats return successful.
	 *
	 * @param stats The aggregate performance data for all instances for all 
	 *		applications for the specified vhost. 
	 */
	function getStatsSuccess(stats:VHostStats):Void{}

	/**
	 * This method is invoked after the vhost stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}
