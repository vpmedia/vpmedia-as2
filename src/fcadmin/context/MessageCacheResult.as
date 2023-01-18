/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.data.MessageCache;

/**
 * MessageCacheResult has the ability to handle result from
 * fcadmin.context.Server.getMessageCache.
 *
 * @see fcadmin.context.Server#getMessageCache
 */

class fcadmin.context.MessageCacheResult implements IResult
{	
	/**
	 * This method is invoked after the TCMessage return successful.
	 *
	 * @param tc The server TCMessage cache statistics.
	 */
	function getMessageCacheSuccess(tc:MessageCache):Void{}

	/**
	 * This method is invoked after the TCMessage return failed.
	 *
	 * @param err A StatusObject provide information about errors.
	 */
	function getMessageCacheFailed(err:StatusObject):Void{}
}
