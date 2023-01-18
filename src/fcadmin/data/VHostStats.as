/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-3
 ******************************************************************************/



/**
 * Performance data for all instances of a application.
 */
class fcadmin.data.VHostStats
{

 
	/**
	 * Total number of messages processed by this vhost.
	 */
	var msgIn:Number;
 
	/**
	 * Total number of messages sent by this vhost.
	 */
	var msgOut:Number;

	/**
	 * Total number of messages dropped by this vhost.
	 */
	var msgDropped:Number;
 

	/**
	 * Total number of bytes read by this vhost.
	 */
	var bytesIn:Number;

	/**
	 * Total number of bytes written by this vhost.
	 */
	var bytesOut:Number;

	/**
	 * Total number of connection attempts accepted by this vhost.
	 */
	var accepted:Number;

	/**
	 * Total number of connection attempts rejected by this vhost.
	 */
	var rejected:Number;


	/**
	 * Total number of connections currently active.
	 */
	var connected:Number;

	/**
	 * Total number of applications that have been created.
 	 */
	var totalApps:Number;


	/**
	 * Total number of connections to the server
	 */
	var totalConnects:Number;

	/**
	 * Total number of disconnections from the server. 
	 */
	var totalDisconnects:Number;



	/**
	 * Total number of instances that have been loaded. 
 	 */
	var totalInstancesLoaded:Number;


	/**
	 * Total number of instances that have been unloaded.
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


	/**
	 * Total number of bytes read through the tunnel.
 	 */
	var tunnelBytesIn:Number;

	/**
	 * Total number of bytes written through the tunnel.
 	 */
	var tunnelBytesOut:Number;

	/**
	 * Number of current requests.
 	 */
	var tunnelRequests:Number;

	/**
	 * Number of current responses.
 	 */
	var tunnelResponses:Number;

	/**
	 * Number of currently idle requests.
 	 */
	var tunnelIdleRequests:Number;

	/**
	 * Number of currently idle responses.
 	 */
	var tunnelIdleResponses:Number;


	private function VHostStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):VHostStats
	{
		
		//trace("VHostStats.fromRawData:"+fcadmin.utils.ObjectUtil.getProperties(rawStats,true))
		
		
		var vhostStats:VHostStats=new VHostStats();

		vhostStats.msgIn=rawStats.msg_in;
		vhostStats.msgOut=rawStats.msg_out;
		vhostStats.msgDropped=rawStats.msg_dropped;
		vhostStats.bytesIn=rawStats.bytes_in;
		vhostStats.bytesOut=rawStats.bytes_out;
		vhostStats.bwIn=rawStats.bw_in;
		vhostStats.bwOut=rawStats.bw_out;
		vhostStats.accepted=rawStats.accepted;
		vhostStats.rejected=rawStats.rejected;
		vhostStats.connected=rawStats.connected;
		vhostStats.totalApps=rawStats.total_apps;
		vhostStats.totalConnects=rawStats.total_connects;
		vhostStats.totalDisconnects=rawStats.total_disconnects;
		vhostStats.totalInstancesLoaded=rawStats.total_instances_loaded;
		vhostStats.totalInstancesUnloaded=rawStats.total_instances_unloaded;
		vhostStats.totalActiveInstancesLoaded=rawStats.total_instances_loaded-rawStats.total_instances_unloaded;
		vhostStats.tunnelBytesIn=rawStats.tunnel_bytes_in;
		vhostStats.tunnelBytesOut=rawStats.tunnel_bytes_out;
		vhostStats.tunnelIdleRequests=rawStats.tunnel_idle_requests;
		vhostStats.tunnelIdleResponses=rawStats.tunnel_idle_responses;
		vhostStats.tunnelRequests=rawStats.tunnel_requests;
		vhostStats.tunnelResponses=rawStats.tunnel_responses;
		
		return vhostStats;
	}

}
