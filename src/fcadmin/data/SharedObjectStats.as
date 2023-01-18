/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-8
 ******************************************************************************/



/**
 * Detailed information about a shared object.
 */
class fcadmin.data.SharedObjectStats
{

	/**
	 * Version number of the shared object.
	 */	
	var version:Number;

	/**
	 * Total number of properties in the shared object.
	 */
	var numProperties:Number;
 

	/**
	 * Total messages in to the shared object.
	 */
	var msgIn:Number;
 
	/**
	 * Total messages out from the shared object.
	 */
	var msgOut:Number;



	/**
	 * Number of active subscribers.
	 */
	var connected:Number;


	/**
	 * Total number of connections to the shared object. 
	 */
	var totalConnects:Number;

	/**
	 * Total number of disconnections from the shared object.
	 */
	var totalDisconnects:Number;



	/**
	 * Maximum version retained before resynchronization. 
	 * If the difference between the server version number 
	 * and the client version number is greater than the 
	 * resyncDepth value, Flash Communication Server sends 
	 * only changes between versions.
	 */
	var resyncDepth:Number;


	private function SharedObjectStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):SharedObjectStats
	{
		var stats:SharedObjectStats=new SharedObjectStats();

		stats.version=rawStats.version;
		stats.numProperties=rawStats.num_properties;
		stats.msgIn=rawStats.msg_in;
		stats.msgOut=rawStats.msg_out;
		stats.connected=rawStats.connected;
		stats.totalConnects=rawStats.total_connects;
		stats.totalDisconnects=rawStats.total_disconnects;
		stats.resyncDepth=rawStats.resync_depth;

		return stats;
	}

}
