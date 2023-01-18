/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.ScriptStats;

/**
 * ScriptStatsResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getScriptStats.
 *
 * @see fcadmin.context.ActiveInstance#getScriptStats
 */

class fcadmin.context.ScriptStatsResult implements IResult
{	
	/**
	 * This method is invoked after the script stats return successful.
	 *
	 * @param info The performance data for a script running on the 
	 *		specified instance of an application.
	 */
	function getScriptStatsSuccess(info:ScriptStats):Void{}

	/**
	 * This method is invoked after the script stats return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getScriptStatsFailed(err:StatusObject):Void{}
}
