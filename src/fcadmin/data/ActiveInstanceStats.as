/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-2
 ******************************************************************************/

import fcadmin.data.ScriptStats;

/**
 * Performance data for all instances of a application.
 */
class fcadmin.data.ActiveInstanceStats
{

	/**
	 * ActionScript Date object; time the application started.
	 */	
	var launchTime:Date;
 
 
	/**
	 * Time, in seconds, the application has been running.
	 */
	var upTime:Number;
 
	/**
	 * Total number of messages processed by this application.
	 */
	var msgIn:Number;
 
	/**
	 * Total number of messages sent by this application.
	 */
	var msgOut:Number;

	/**
	 * Total number of messages dropped by this application.
	 */
	var msgDropped:Number;
 

	/**
	 * Total number of bytes read by this application.
	 */
	var bytesIn:Number;

	/**
	 * Total number of bytes written by this application.
	 */
	var bytesOut:Number;

	/**
	 * Total number of connection attempts accepted by this application.
	 */
	var accepted:Number;

	/**
	 * Total number of connection attempts rejected by this application.
	 */
	var rejected:Number;


	/**
	 * Total number of connections currently active.
	 */
	var connected:Number;


	/**
	 * Total number of socket connections to the application since the application was started.
	 */
	var totalConnects:Number;

	/**
	 * Total number of disconnections from the application since the application was started.
	 */
	var totalDisconnects:Number;



	/**
	 * Object that contains script engine performance data. 
 	 */
	var script:ScriptStats;


	/**
	 * Current bandwidth in, in bytes per second.
	 */
	var bwIn:Number;

	/**
	 * Current bandwidth out, in bytes per second.
	 */
	var bwOut:Number;



	private function ActiveInstanceStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):ActiveInstanceStats
	{
		//trace("ActiveInstanceStats.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(rawStats,true).join("\r"));

		var stats:ActiveInstanceStats=new ActiveInstanceStats();

		stats.launchTime=rawStats.launch_time;
		stats.upTime=rawStats.up_time;
		stats.msgIn=rawStats.msg_in;
		stats.msgOut=rawStats.msg_out;
		stats.msgDropped=rawStats.msg_dropped;
		stats.bytesIn=rawStats.bytes_in;
		stats.bytesOut=rawStats.bytes_out;
		stats.accepted=rawStats.accepted;
		stats.rejected=rawStats.rejected;
		stats.connected=rawStats.connected;
		stats.totalConnects=rawStats.total_connects;
		stats.totalDisconnects=rawStats.total_disconnects;
		stats.script=ScriptStats.fromRawData(rawStats.script);
		stats.bwIn=rawStats.bw_in;
		stats.bwOut=rawStats.bw_out;

		return stats;
	}

}
