/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;

/**
 * AdaptorsResult has the ability to handle result from
 * fcadmin.context.Server.getAdaptors.
 *
 * @see fcadmin.context.Server#getAdaptors
 */

class fcadmin.context.AdaptorsResult implements IResult
{	
	/**
	 * This method is invoked after the adaptor list return successful.
	 *
	 * @param adaptors A array of adaptors that are defined.
	 * @see fcadmin.context.Adaptor
	 */
	function getAdaptorsSuccess(adaptors:Array):Void{}

	/**
	 * This method is invoked after the adaptor list return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getAdaptorsFailed(err:StatusObject):Void{}
}