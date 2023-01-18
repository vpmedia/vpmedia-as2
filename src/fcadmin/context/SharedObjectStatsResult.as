/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.SharedObjectStats;

/**
 * SharedObjectStatsResult has the ability to handle result from
 * fcadmin.context.VHost.getStats.
 *
 * @see fcadmin.context.SharedObjectContext#getStats
 */

class fcadmin.context.SharedObjectStatsResult implements IResult
{	
	/**
	 * This method is invoked after the shared object stats return successful.
	 *
	 * @param stats Detailed information about a shared object.
	 */
	function getStatsSuccess(stats:SharedObjectStats):Void{}

	/**
	 * This method is invoked after the shared object stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}
