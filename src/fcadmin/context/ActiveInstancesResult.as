/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;


/**
 * ActiveInstancesResult has the ability to handle result from
 * fcadmin.context.App.getActiveInstances.
 *
 * @see fcadmin.context.App#getActiveInstances
 */


class fcadmin.context.ActiveInstancesResult implements IResult
{	
	
	/**
	 * This method is invoked after the active instances return successful.
	 *
	 * @param instances An array of active instances.
	 * @see fcadmin.context.ActiveInstance
	 */
	function getActiveInstancesSuccess(instances:Array):Void{}

	
	/**
	 * This method is invoked after the active instances return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getActiveInstancesFailed(err:StatusObject):Void{}
}