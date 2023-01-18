/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-2
 ******************************************************************************/

/**
 * Detailed information about the network I/O characteristics of the connected adaptor/server. 
 */
class fcadmin.data.IOStats
{

 
	/**
	 * Total number of messages processed by the adaptor/server.
	 */
	var msgIn:Number;
 
	/**
	 * Total number of messages sent by the adaptor/server.
	 */
	var msgOut:Number;

	/**
	 * Total number of messages dropped by the adaptor/server.
	 */
	var msgDropped:Number;
 
	/**
	 * Total number of bytes read by the adaptor/server.
	 */
	var bytesIn:Number;

	/**
	 * Total number of bytes written by the adaptor/server.
	 */
	var bytesOut:Number;

	/**
	 * Total number of system read calls.
	 */
	var reads:Number;

	/**
	 * Total number of system writes.
	 */
	var writes:Number;

	/**
	 * Number of currently active socket connections to the adaptor/server.
	 */
	var connected:Number;

	/**
	 * Total number of socket connections to the adaptor/server since the adaptor/server was started.
	 */
	var totalConnects:Number;

	/**
	 * Total number of socket disconnections from the adaptor/server.
	 */
	var totalDisconnects:Number;

	/**
	 * Tunneling header bytes in (this is the overhead over and above RTMP payload).
 	 */
	var tunnelBytesIn:Number;

	/**
	 * Tunneling header bytes out (overhead in the other direction).
 	 */
	var tunnelBytesOut:Number;

	/**
	 * Number of tunneling requests thus far.
 	 */
	var tunnelRequests:Number;

	/**
	 * Number of tunneling responses thus far.
 	 */
	var tunnelResponses:Number;

	/**
	 * Number of tunneling requests that had no payload (network chatter overhead).
 	 */
	var tunnelIdleRequests:Number;

	/**
	 * Number of tunneling responses that had no payload (network chatter overhead).
 	 */
	var tunnelIdleResponses:Number;





	private function IOStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):IOStats
	{
		var ioStats:IOStats=new IOStats();

		ioStats.msgIn=rawStats.msg_in;
		ioStats.msgOut=rawStats.msg_out;
		ioStats.msgDropped=rawStats.msg_dropped;
		ioStats.bytesIn=rawStats.bytes_in;
		ioStats.bytesOut=rawStats.bytes_out;

		ioStats.reads=rawStats.reads;
		ioStats.writes=rawStats.writes;

		ioStats.connected=rawStats.connected;
		ioStats.totalConnects=rawStats.total_connects;
		ioStats.totalDisconnects=rawStats.total_disconnects;

		ioStats.tunnelBytesIn=rawStats.tunnel_bytes_in;
		ioStats.tunnelBytesOut=rawStats.tunnel_bytes_out;
		ioStats.tunnelRequests=rawStats.tunnel_requests;
		ioStats.tunnelResponses=rawStats.tunnel_responses;
		ioStats.tunnelIdleRequests=rawStats.tunnel_idle_requests;
		ioStats.tunnelIdleResponses=rawStats.tunnel_idle_responses;

		return ioStats
	}

}
