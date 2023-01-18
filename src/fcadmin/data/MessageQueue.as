/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-3
 ******************************************************************************/


/**
 * The client message queue statistics.
 */
class fcadmin.data.MessageQueue
{

	/**
	 * Total number of audio messages in all audio queues.
	 */	
	var audio:Number;
 
 
 
	/**
	 * Total number of video messages in all video queues.
	 */
	var video:Number;
 
	/**
	 * Total number of command/data messages in the other queue.
	 */
	var other:Number;


	private function MessageQueue()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):MessageQueue
	{
		var stats:MessageQueue=new MessageQueue();

		stats.audio=rawStats.audio;
		stats.video=rawStats.video;
		stats.other=rawStats.other;

		return stats;
	}

}
