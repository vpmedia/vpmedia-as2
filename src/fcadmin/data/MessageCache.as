/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-6
 ******************************************************************************/



/**
 * Flash Communication Server message packet cache statistics
 */
class fcadmin.data.MessageCache
{

	/**
	 * Total number of message objects allocated.
	 */
	var allocated:Number;
 
	/**
	 * Total number of objects reused.
	 */
	var reused:Number;

	/**
	 * Size of the cache, in number of message packets.
	 */
	var size:Number;

	/**
	 * Undocument raw element, not implement yet.
	 */
	var bytes:Object;

	/**
	 * Undocument raw element, not implement yet.
	 */
	var units:Object;

	/**
	 * Undocument raw element, not implement yet.
	 */
	var threadCount:Number



	private function MessageCache()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):MessageCache
	{
		//trace("MessageCache.bytes:\r"+fcadmin.utils.ObjectUtil.getProperties(rawStats.bytes,true).join("\r"));
		//trace("MessageCache.units:\r"+fcadmin.utils.ObjectUtil.getProperties(rawStats.units,true).join("\r"));
		
		var stats:MessageCache=new MessageCache();

		stats.allocated=rawStats.allocated;
		stats.reused=rawStats.reused;
		stats.size=rawStats.size;

		stats.bytes=rawStats.bytes;
		stats.units=rawStats.units;
		stats.threadCount=rawStats.thread_count;

		return stats;
	}

}
