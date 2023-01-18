/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-12
 ******************************************************************************/



/**
 * Flash Communication Server application logging information.
 */
class fcadmin.data.InstanceLogEntry
{

	/**
	 * timestamp for this logging entry.
	 */
	var time:Date; 

	/**
	 * the application that broadcasts the logging message.
	 */
	var application:String;

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




	private function InstanceLogEntry()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(info:Object):InstanceLogEntry
	{
		//trace("InstanceLogEntry.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(info,true).join("\r"));

		var ile:InstanceLogEntry=new InstanceLogEntry();

		ile.time=info.time;
		ile.application=info.application;
		ile.description=info.description;
		ile.code=info.code;
		ile.level=info.level;

		return ile;
	}

}
