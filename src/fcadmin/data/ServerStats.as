/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-6
 ******************************************************************************/

import fcadmin.data.IOStats;
import fcadmin.data.MessageCache;
import fcadmin.utils.ObjectUtil;

/**
 * The server status and statistics about the operation of the server, 
 * including the length of time the server has been running and I/O 
 * and message cache statistics.
 */
class fcadmin.data.ServerStats
{

	/**
	 * ActionScript Date object; time the server was started.
	 */
	var launchTime:Date;
 
 	/**
	 * Length of time, in seconds, that the server has been running.
	 */
	var upTime:Number;

	/**
	 * I/O statistics.
	 */ 
	var io:IOStats;

	/**
	 * Flash Communication Server message packet cache statistics
	 */
	var msgCache:MessageCache;

	/**
	 * On Microsoft Windows NT 4.0, the approximate percentage of the 
	 * last 1000 pages of physical memory in use.
	 * On Windows 2000 or Windows XP, the approximate percentage of 
	 * total physical memory in use.
	 */
	var memoryUsage:Number;

	/**
	 * Approximate percentage of CPU in use.
	 */
	var cpuUsage:Number;



	private function ServerStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):ServerStats
	{
		var stats:ServerStats=new ServerStats();

		stats.launchTime=rawStats.launch_time;
		stats.upTime=rawStats.up_time;

		stats.io=IOStats.fromRawData(rawStats.io);
		stats.msgCache=MessageCache.fromRawData(rawStats.msg_cache);

		stats.memoryUsage=rawStats.memory_Usage;
		stats.cpuUsage=rawStats.cpu_Usage;

		return stats;
	}

}
