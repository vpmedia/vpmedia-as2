/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-9
 ******************************************************************************/

import fcadmin.data.PublishStats;
import fcadmin.data.SubscribeStats;

/**
 * Gets detailed information for one or more network streams.
 */
class fcadmin.data.StreamStats
{

	/**
	 * Stream ID.
	 */	
	var streamID:Number;

	/**
	 * Stream name or empty if the stream is idle.
	 */
	var name:String;
 

	/**
	 * Stream type. Possible values are shown in the following list:i
	 * <ur>
	 *	<li>idle</li>
	 *	<li>publishing</li>
	 *	<li>playing live</li>
	 *	<li>play recorded</li>
	 * </ur>
	 */
	var type:String;
 
	/**
	 * User ID.
	 */
	var client:Number;



	/**
	 * Possible values are shown in the following list:
	 * <ur>
	 *	<li>If type = idle, value is 0.</li>
	 *	<li>If type = publishing, value is the time the stream was published.</li>
	 *	<li>If type = playing live, value is the time the playback of the stream started.</li>
	 *	<li>If type = play recorded, value is the time the playback of the stream started.</li>
	 */

	var time:Date;


	/**
	 * Publisher statistics
	 */
	var publisher:PublishStats=null;

	/**
	 * Array of subscriber statistics.
	 *
	 * @see fcadmin.data.SubscribeStats
	 */
	var subscribers:Array=null;





	private function StreamStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):StreamStats
	{
		var stats:StreamStats=new StreamStats();

		stats.streamID=rawStats.stream_id;
		stats.name=rawStats.name;
		stats.type=rawStats.type;
		stats.client=rawStats.client;
		stats.time=rawStats.time;

		if(rawStats.publisher!=undefined)
		{
			stats.publisher=PublishStats.fromRawData(rawStats.publisher);
		}
		else
		{
			stats.publisher=null;
		}
		if(rawStats.subscribers!=undefined)
		{
			stats.subscribers=new Array();
			for(var i:Number=0;i<rawStats.subscribers.length;i++)
			{
				stats.subscribers.push(SubscribeStats.fromRawData(rawStats.subscribers[i]));
			}
			if(stats.subscribers.length==0)
			{
				stats.subscribers=null;
			}
		}
		else
		{
			stats.subscribers=null;
		}
		return stats;
	}

}
