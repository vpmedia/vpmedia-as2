import gugga.logging.IFormatter;
import gugga.logging.LogRecord;

/**
*	A default formatter implementation.
*
*	@author Ralf Siegel
*/
class gugga.logging.formatters.SimpleFormatter implements IFormatter
{
	/**
	*	@see logging.IFormatter
	*/
	public function format(logRecord:LogRecord):String
	{
		return logRecord.getMessage();
	}
}