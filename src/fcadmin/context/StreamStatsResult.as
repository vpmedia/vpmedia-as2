/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.StreamStats;

/**
 * StreamStatsResult has the ability to handle result from
 * fcadmin.context.StreamContext.getStats.
 *
 * @see fcadmin.context.StreamContext#getStats
 */

class fcadmin.context.StreamStatsResult implements IResult
{	
	/**
	 * This method is invoked after the stream stats return successful.
	 *
	 * @param stats Detailed information for a stream.
	 */
	function getStatsSuccess(stats:StreamStats):Void{}

	/**
	 * This method is invoked after the stream stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStatsFailed(err:StatusObject):Void{}
}
