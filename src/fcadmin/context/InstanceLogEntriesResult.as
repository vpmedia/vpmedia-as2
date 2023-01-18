/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-12
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.InstanceLogEntry;

/**
 * InstanceLogEntriesResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getLogEntries.
 *
 * @see fcadmin.context.ActiveInstance#getLogEntries
 */

class fcadmin.context.InstanceLogEntriesResult implements IResult
{	
	/**
	 * This method is invoked after the log entries return successful.
	 *
	 * @param entries An array of log entries.
	 * @see fcadmin.data.InstanceLogEntry
	 */
	function getLogEntriesSuccess(entries:Array):Void{}

	/**
	 * This method is invoked after the log entries return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getLogEntriesFailed(err:StatusObject):Void{}


	/**
	 * This method is invoked when the log entries being progress.
	 *
	 * @param ile A InstanceLogEntry provide information about log entry.
	 */
	function getLogEntriesProgress(ile:InstanceLogEntry):Void{}
}
