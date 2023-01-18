/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-3
 ******************************************************************************/

import fcadmin.data.MessageQueue;

/**
 * Performance data for all instances of a application.
 */
class fcadmin.data.UserStats
{

	/**
	 * Time, in seconds, that the user has been connected 
	 * to the specified instance of the application.
	 */	
	var connectTime:Date;
 
  
	/**
	 * Total number of messages processed by this user. 
	 */
	var msgIn:Number;
 
	/**
	 * Total number of messages sent by this user.
	 */
	var msgOut:Number;

	/**
	 * Total number of messages dropped by this user.
	 */
	var msgDropped:Number;
 

	/**
	 * Total number of bytes read by this user.
	 */
	var bytesIn:Number;

	/**
	 * Total number of bytes written by this user.
	 */
	var bytesOut:Number;

	/**
	 * Protocol used by the client to connect to 
	 * the server (RTMP or RTMPT).
	 */
	var protocol:String;


	/**
	 * Array of numbers that represent the stream IDs.
	 */
	var streamIDs:Array;

	/**
	 * The client message queue statistics
	 */
	var msgQueue:MessageQueue;


	private function UserStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):UserStats
	{
		var stats:UserStats=new UserStats();

		stats.connectTime=rawStats.connect_time;
		stats.msgIn=rawStats.msg_in;
		stats.msgOut=rawStats.msg_out;
		stats.msgDropped=rawStats.msg_dropped;
		stats.bytesIn=rawStats.bytes_in;
		stats.bytesOut=rawStats.bytes_out;
		stats.protocol=rawStats.protocol;
		stats.streamIDs=rawStats.stream_ids;
		stats.msgQueue=MessageQueue.fromRawData(rawStats.msg_queue);

		return stats;
	}

}
