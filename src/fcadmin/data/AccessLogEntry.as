/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-12
 ******************************************************************************/



/**
 * Flash Communication Server server access logging information.
 */
class fcadmin.data.AccessLogEntry
{

	/**
	 * timestamp for this logging entry.
	 */
	var time:Date; 

	/**
	 * the logging message.
	 */
	var description:String;

	/**
	 * describes the result of the onStatus method,
	 */
	var code:String;


	/**
	 * either "status", "warning", or "error". 
	 */
	var level:String;


	var tunnel:Boolean;


	var uri:String;


	var referrer:String;


	var pid:String;


	var id:String;



	private function AccessLogEntry()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(info:Object):AccessLogEntry
	{
		//trace("AccessLogEntry.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(info,true).join("\r"));

		var ile:AccessLogEntry=new AccessLogEntry();

		ile.time=info.time;
		ile.description=info.description;
		ile.code=info.code;
		ile.level=info.level;
		ile.tunnel=info.tunnel;
		ile.uri=info.uri;
		ile.referrer=info.referrer;
		ile.pid=info.pid;
		ile.id=info.id;

		return ile;
	}

}
