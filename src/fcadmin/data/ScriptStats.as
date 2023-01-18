/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-22
 ******************************************************************************/


/**
 * Performance data for a script running on the specified instance of an application.
 */

class fcadmin.data.ScriptStats
{

	/**
	 * Maximum amount of time, in seconds, the script has taken to execute an event.
	 */	
	var timeHighWaterMark:Number;
 
 
	/**
	 * Total number of events currently in the script engine queue.
	 */
	var queueSize:Number;
 
	/**
	 * Total number of events processed by the script engine.
	 */
	var totalProcessed:Number;
 
	/**
	 * Number of seconds taken to process the number of events in totalProcessed.
	 */
	var totalProcessTime:Number;

	/**
	 * Maximum number of events in the queue.
	 */
	var queueHighWaterMark:Number;
 



	private function ScriptStats()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawStats:Object):ScriptStats
	{
		//trace("ScriptStats.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(rawStats,true).join("\r"));

		var stats:ScriptStats=new ScriptStats();

		stats.timeHighWaterMark=rawStats.time_high_water_mark;
		stats.queueSize=rawStats.queue_size;
		stats.totalProcessed=rawStats.total_processed;
		stats.totalProcessTime=rawStats.total_process_time;
		stats.queueHighWaterMark=rawStats.queue_high_water_mark;
		return stats;
	}

}
