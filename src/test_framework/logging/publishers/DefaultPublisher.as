/**
*	Standard implementation of the Logger's framework IPublisher interface.
*
*	@author Todor Kolev
*/

import test_framework.logging.formatters.DefaultFormatter;
import test_framework.logging.IFilter;
import test_framework.logging.IFormatter;
import test_framework.logging.IPublisher;
import test_framework.logging.Level;
import test_framework.logging.LogRecord;

class test_framework.logging.publishers.DefaultPublisher implements IPublisher
{
	private var filter:IFilter;
	private var formatter:IFormatter;
	private var level:Level;

	/**
	*	Constructs a new publisher with the standard formatter
	*/
	public function DefaultPublisher() 
	{
		this.setFormatter(new DefaultFormatter());
	}

	/**
	*	@see logging.IPublisher
	*/	
	public function publish(logRecord:LogRecord):Void
	{
		if (this.isLoggable(logRecord)) {
			trace(this.getFormatter().format(logRecord));
		}
	}
	
	/**
	*	@see logging.IPublisher
	*/
	public function setFilter(filter:IFilter):Void
	{
		this.filter = filter;
	}
	
	/**
	*	@see logging.IPublisher
	*/
	public function getFilter():IFilter
	{
		return this.filter;
	}

	/**
	*	@see logging.IPublisher
	*/		
	public function setFormatter(formatter:IFormatter):Void
	{
		this.formatter = formatter;
	}

	/**
	*	@see logging.IPublisher
	*/	
	public function getFormatter():IFormatter
	{
		return this.formatter;
	}
	
	/**
	*	@see logging.IPublisher
	*/
	public function setLevel(level:Level):Void
	{
		this.level = level;
	}
	
	/**
	*	@see logging.IPublisher
	*/
	public function getLevel():Level
	{
		return this.level;
	}
	
	/**
	*	@see logging.IPublisher
	*/
	public function isLoggable(logRecord:LogRecord):Boolean
	{
		if (this.getLevel() > logRecord.getLevel()) {
			return false;
		}
		
		if (this.getFilter() == undefined || this.getFilter() == null) {
			return true;
		}
		
		if (this.getFilter().isLoggable(logRecord)) {
			return true;
		}
		
		return false;
	}	
}