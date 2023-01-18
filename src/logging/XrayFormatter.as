import logging.IFormatter;
import logging.LogRecord;
/**
*	An Xray Debugger compatible formatter implementation.
*
*	@author András Csizmadia
*/
class logging.XrayFormatter implements IFormatter
{
	/**
	*	@see logging.IFormatter
	*/
	public function format (logRecord:LogRecord):String
	{
		var formatted:String = "";
		formatted += "[" + formatDate (logRecord.getDate ()) + "]" + "[" + logRecord.getLoggerName () + "]" + "[" + logRecord.getLevel ().getName () + "]";
		formatted += "<<LOG>>";
		formatted += logRecord.getMessage ();
		return formatted;
	}
	private function formatDate (dateRecord:Date):String
	{
		var cDate:Date = dateRecord;
		var cHour:Number = cDate.getHours ();
		var cMin:Number = cDate.getMinutes ();
		var cSec:Number = cDate.getSeconds ();
		var ct = (cHour * 3600) + cSec + (cMin * 60);
		//
		var hours = Math.floor (ct / 3600);
		var minutes = Math.floor (ct / 60) - (60 * hours);
		var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
		//
		minutes < 10 ? minutes = "0" + minutes : "";
		seconds < 10 ? seconds = "0" + seconds : "";
		hours < 10 ? hours = "0" + hours : "";
		//
		return hours + ":" + minutes + ":" + seconds;
	}
}
