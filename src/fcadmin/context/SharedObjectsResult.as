/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * SharedObjectsResult has the ability to handle result from
 * fcadmin.context.ActiveInstance.getSharedObjects.
 *
 * @see fcadmin.context.ActiveInstance#getSharedObjects
 */

class fcadmin.context.SharedObjectsResult implements IResult
{	
	/**
	 * This method is invoked after the shared objects return successful.
	 *
	 * @param socs All the shared objects that are currently active.
	 * @see fcadmin.context.SharedObjectContext
	 */
	function getSharedObjectsSuccess(socs:Array):Void{}

	/**
	 * This method is invoked after the shared objects return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getSharedObjectsFailed(err:StatusObject):Void{}
}