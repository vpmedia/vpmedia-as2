/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-3
 ******************************************************************************/



/**
 * Performance data for all instances of a application.
 */
class fcadmin.data.AppStats
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
	 * Total number of instances that have been loaded since the application started.
 	 */
	var totalInstancesLoaded:Number;


	/**
	 * Total number of instances that have been unloaded since the application started.
 	 */
	var totalInstancesUnloaded:Number;


	/**
	 * Total number of active instances that have been loaded since the application started.
 	 */
	var totalActiveInstancesLoaded:Number;


	/**
	 * Current bandwidth in, in bytes per second.
	 */
	var bwIn:Number;

	/**
	 * Current bandwidth out, in bytes per second.
	 */
	var bwOut:Number;


	private function AppStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):AppStats
	{
		var appStats:AppStats=new AppStats();

		appStats.launchTime=rawStats.launch_time;
		appStats.upTime=rawStats.up_time;
		appStats.msgIn=rawStats.msg_in;
		appStats.msgOut=rawStats.msg_out;
		appStats.msgDropped=rawStats.msg_dropped;
		appStats.bytesIn=rawStats.bytes_in;
		appStats.bytesOut=rawStats.bytes_out;
		appStats.accepted=rawStats.accepted;
		appStats.rejected=rawStats.rejected;
		appStats.connected=rawStats.connected;
		appStats.totalConnects=rawStats.total_connects;
		appStats.totalDisconnects=rawStats.total_disconnects;
		appStats.totalInstancesLoaded=rawStats.total_instances_loaded;
		appStats.totalInstancesUnloaded=rawStats.total_instances_unloaded;
		appStats.totalActiveInstancesLoaded=rawStats.total_instances_loaded-rawStats.total_instances_unloaded;
		appStats.bwIn=rawStats.bw_in;
		appStats.bwOut=rawStats.bw_out;

		return appStats
	}

}
