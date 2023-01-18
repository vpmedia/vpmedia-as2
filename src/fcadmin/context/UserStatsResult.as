/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;

import fcadmin.data.UserStats;

/**
 * UserStatsResult has the ability to handle result from
 * fcadmin.context.User.getStats.
 *
 * @see fcadmin.context.User#getStats
 */

class fcadmin.context.UserStatsResult implements IResult
{	
	/**
	 * This method is invoked after the user stats return successful.
	 *
	 * @param stats The performance data for the connection of a specified user.
	 */
	function getStatsSuccess(stats:UserStats):Void{}

	/**
	 * This method is invoked after the user stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}
