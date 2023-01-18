/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/

import logging.IFilter;
import logging.IPublisher;
import logging.Level;
import logging.LogRecord;
import logging.IFormatter;
import logging.DefaultFormatter;

import mx.core.UIComponent;
import mx.controls.TextArea;

import fcadmin.test.TestLoggingFormatter;

class fcadmin.test.TestProviderOutput extends UIComponent implements IPublisher
{

	static var symbolName:String = "fcadmin.test.TestProviderOutput";

	static var symbolOwner:Object = TestProviderOutput;

	
	private var filter:IFilter;
	private var formatter:IFormatter;
	private var level:Level;

	private var console:TextArea;
	private var boundingBox:MovieClip;
	
	
	
	function TestProviderOutput()
	{
		this.setFormatter(new TestLoggingFormatter());
	}

	function init():Void
	{
		super.init();
		boundingBox._visible=false;
	}

	function createChildren():Void
	{
		createClassObject(TextArea,"console",1,{visible:false,editable:false,styleName:this});
	}

	function size():Void
	{
		console.setSize(width,height);
	}

	function draw():Void
	{
		setSize(width,height);
		console.visible=true;
	}
	

		
	/**
	*	@see logging.IPublisher
	*/
	public function publish(logRecord:LogRecord):Void
	{
		if (this.isLoggable(logRecord)) {

			var labelLength:Number=console.label.text.length;
			var newText:String=this.getFormatter().format(logRecord);
			//trace(newText)
			//console.label.replaceText(labelLength, labelLength, newText+"\r");
			console.text+=newText + newline;

			console.vPosition=console.maxVPosition;
			//doLater(console, "adjustScrollBars");
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