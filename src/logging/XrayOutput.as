import logging.IFilter;
import logging.IPublisher;
import logging.Level;
import logging.LogRecord;
import logging.IFormatter;
import logging.XrayFormatter;
/**
*	Extended Xray debugger implementation of the Logger's framework IPublisher interface.
*	Plain text formats incoming logging messages and sends them to the Xray Debugger output window.
*
*	@author András Csizmadia
*/
class logging.XrayOutput implements IPublisher
{
	private var filter:IFilter;
	private var formatter:IFormatter;
	private var level:Level;
	/**
	*	Constructs a new trace publisher with the default formatter
	*/
	public function XrayOutput ()
	{
		this.setFormatter (new XrayFormatter ());
	}
	/**
	*	@see logging.IPublisher
	*/
	public function publish (logRecord:LogRecord):Void
	{
		if (this.isLoggable (logRecord))
		{
			var result = this.getFormatter ().format (logRecord);
			var result_arr = result.split("<<LOG>>")
			var result_level=result_arr[0]
			var result_message=result_arr[1]
			_global.tt (result_level,result_message );
		}
	}
	/**
	*	@see logging.IPublisher
	*/
	public function setFilter (filter:IFilter):Void
	{
		this.filter = filter;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function getFilter ():IFilter
	{
		return this.filter;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function setFormatter (formatter:IFormatter):Void
	{
		this.formatter = formatter;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function getFormatter ():IFormatter
	{
		return this.formatter;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function setLevel (level:Level):Void
	{
		this.level = level;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function getLevel ():Level
	{
		return this.level;
	}
	/**
	*	@see logging.IPublisher
	*/
	public function isLoggable (logRecord:LogRecord):Boolean
	{
		if (this.getLevel () > logRecord.getLevel ())
		{
			return false;
		}
		if (this.getFilter () == undefined || this.getFilter () == null)
		{
			return true;
		}
		if (this.getFilter ().isLoggable (logRecord))
		{
			return true;
		}
		return false;
	}
}
