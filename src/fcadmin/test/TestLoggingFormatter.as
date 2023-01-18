/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/


import logging.IFormatter;
import logging.LogRecord;

/**
 * @exclude
 */
class fcadmin.test.TestLoggingFormatter implements IFormatter
{
	/**
	 * @see logging.IFormatter
	 */
	public function format(logRecord:LogRecord):String
	{
		var date:Date=logRecord.getDate();
		
		var formatted:String = "";		
		formatted += "[" + logRecord.getLevel().getName() + "] " + date.getMonth() + "/" + date.getDay() + date.getYear() + " | " + logRecord.getLoggerName() + newline;
		formatted +=  logRecord.getMessage();
		return formatted;
	}
}