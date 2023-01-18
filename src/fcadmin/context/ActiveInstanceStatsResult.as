/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.ActiveInstanceStats;


/**
 * ActiveInstanceStatsResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getStats.
 *
 * @see fcadmin.context.ActiveInstance#getStats
 */

class fcadmin.context.ActiveInstanceStatsResult implements IResult
{	
	/**
	 * This method is invoked after the active instance stats return successful.
	 *
	 * @param stats The performance data for a specified instance of an application.
	 */
	function getStatsSuccess(stats:ActiveInstanceStats):Void{}


	/**
	 * This method is invoked after the active instance stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}