/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-9
 ******************************************************************************/



/**
 * Stream subscriber statistics.
 */
class fcadmin.data.SubscribeStats
{

	/**
	 * User ID.
	 */
	var client:Number;



	/**
	 * The time that the user subscribed to the stream. 
	 */

	var subscribeTime:Date;



	private function SubscribeStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):SubscribeStats
	{
		var stats:SubscribeStats=new SubscribeStats();

		stats.client=rawStats.client;
		stats.subscribeTime=rawStats.subscribe_time;
		return stats;
	}

}
