/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/


/**
 * An information object that all Server Management ActionScript API methods return.
 *
 */
class fcadmin.data.StatusObject
{
	/**
	 * A string that describes the result of the onStatus method.
	 *
	 */	
	var code:String;


	/**
	 * A string that is either "status", "warning", or "error"
	 *
	 */
	var level:String;


	/**
	 *  The Date object indicates the time that the command was executed.
	 */
	var timeStamp:Date;


	/**
	 * A string that provides a more specific reason for the failure.
	 *
	 */
	var description:String


	/**
	 * A string that provides a more specific reason for the failure.
	 *
	 */
	var details:String;




	
	private function StatusObject()
	{
	}



	/**
	 * @exclude
	 */
	static function fromRawData(info:Object):StatusObject
	{
		var stat:StatusObject=new StatusObject();

		stat.code=info.code;
		stat.level=info.level;
		stat.description=info.description;
		stat.details=info.details;
		stat.timeStamp=info.timestamp;

		return stat;
	}
}
