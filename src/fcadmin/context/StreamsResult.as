/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * StreamsResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getStreams.
 *
 * @see fcadmin.context.ActiveInstance#getStreams
 */

class fcadmin.context.StreamsResult implements IResult
{	
	/**
	 * This method is invoked after the streams return successful.
	 *
	 * @param streams An array of network streams that are 
	 *			currently connected to the specified 
	 *			instance of the application.
	 * @see fcadmin.context.StreamContext
	 */
	function getStreamsSuccess(streams:Array):Void{}

	/**
	 * This method is invoked after the streams return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getStreamsFailed(err:StatusObject):Void{}
}
