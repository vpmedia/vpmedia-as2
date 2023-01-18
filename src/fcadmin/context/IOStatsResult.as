/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.IOStats;

/**
 * IOStatsResult has the ability to handle result from
 * fcadmin.context.Adaptor.getIOStats.
 *
 * @see fcadmin.context.Adaptor#getIOStats
 */
class fcadmin.context.IOStatsResult implements IResult
{	
	/**
	 * This method is invoked after the IO stats return successful.
	 *
	 * @param ioStats The detailed information about the network 
	 *			I/O characteristics of the connected 
	 *			adaptor. 
	 */
	function getIOStatsSuccess(ioStats:IOStats):Void{}

	/**
	 * This method is invoked after the IO stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getIOStatsFailed(err:StatusObject):Void{}
}
