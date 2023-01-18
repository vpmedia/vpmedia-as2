/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.ServerStats;

/**
 * ServerStatsResult has the ability to handle result from
 * fcadmin.context.Server.getStats.
 *
 * @see fcadmin.context.Server#getServerStats
 */

class fcadmin.context.ServerStatsResult implements IResult
{	
	/**
	 * This method is invoked after the server stats return successful.
	 *
	 * @param stats The server status and statistics about the 
	 *		operation of the server, including the 
	 *		length of time the server has been running 
	 *		and I/O and message cache statistics.
	 */
	function getServerStatsSuccess(stats:ServerStats):Void{}

	/**
	 * This method is invoked after the server stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getServerStatsFailed(err:StatusObject):Void{}
}
