/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-9
 ******************************************************************************/



/**
 * Stream publisher statistics.
 */
class fcadmin.data.PublishStats
{

	/**
	 * User ID.
	 */
	var client:Number;



	/**
	 * Time that the stream was published.
	 */

	var publishTime:Date;



	private function PublishStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):PublishStats
	{
		var stats:PublishStats=new PublishStats();

		stats.client=rawStats.client;
		stats.publishTime=rawStats.publish_time;
		return stats;
	}

}
