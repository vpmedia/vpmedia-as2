/**
*	The LogManager provides a hook mechanism applications can use for loading the logging.xml file which applications can use.
*	
*	The global LogManager object can be retrieved using LogManager.getInstance(). 
*	The LogManager object is created during class initialization and cannot subsequently be changed. 
*
*	@author Ralf Siegel
*/

import mx.events.EventDispatcher;

import test_framework.logging.errors.ClassNotFoundError;
import test_framework.logging.errors.IllegalArgumentError;
import test_framework.logging.errors.InvalidFilterError;
import test_framework.logging.errors.InvalidFormatterError;
import test_framework.logging.errors.InvalidPublisherError;
import test_framework.logging.IFilter;
import test_framework.logging.IFormatter;
import test_framework.logging.IPublisher;
import test_framework.logging.Level;
import test_framework.logging.Logger;
import test_framework.logging.publishers.Bit101Publisher;
import test_framework.logging.publishers.DefaultPublisher;
import test_framework.logging.publishers.SOSPublisher;

[Event("configApplied")]
class test_framework.logging.LogManager extends EventDispatcher
{		
	private static var instance:LogManager = new LogManager();	
	private var defaultPublisher:IPublisher;
	
	/**
	*	Private constructor.
	*/
	private function LogManager() 
	{	
		//just state types to force compiler to include them
		var defaultPublisherFakeVar:DefaultPublisher = null;
		var bit101PublisherFakeVar:Bit101Publisher = null;
		var sosPublisherFakeVar:SOSPublisher = null;
	}
	
	/**
	*	Get the singleton instance.
	*
	*	@return The LogManager instance
	*/
	public static function getInstance():LogManager
	{
		if (instance == undefined) {
			instance = new LogManager();
		}
		return instance;
	}
	
	/**
	*	Returns the Filter object associated with the class with the given string name
	*
	*	@param className the filter's class name 
	*	@return the Filter object
	*/
	private static function createFilterByName(className:String):IFilter
	{
		var Filter:Function = getClassByName(className);
		if (!((new Filter) instanceof IFilter)) {
			throw new InvalidFilterError(className);
		}
		return new Filter();		
	}
	
	/**
	*	Returns the Formatter object associated with the class with the given string name
	*
	*	@param className the formatters's class name 
	*	@return the Formatter object
	*/
	private static function createFormatterByName(className:String):IFormatter
	{
		var Formatter:Function = getClassByName(className);
		if (!((new Formatter) instanceof IFormatter)) {
			throw new InvalidFormatterError(className);
		}
		return new Formatter();		
	}
	
	/**
	*	Returns the Publisher object associated with the class with the given string name
	*
	*	@param className the publishers's class name 
	*	@return the Publisher object
	*/
	private static function createPublisherByName(className:String):IPublisher
	{
		var Publisher:Function = getClassByName(className);
		if (!((new Publisher) instanceof IPublisher)) {
			throw new InvalidPublisherError(className);
		}
		return new Publisher();		
	}

	/**
	*	Enables logging (logging is enabled by default) for all loggers.
	*/
	public function enableLogging():Void
	{
		if (Logger.prototype.log == null) {
			Logger.prototype.log = Logger.prototype.__log__;
			Logger.prototype.__log__ = null;
		}
	}
	
	/**
	*	Disables logging (logging is enabled by default) for all loggers.
	*/
	public function disableLogging():Void
	{
		if (Logger.prototype.log != null) {
			Logger.prototype.__log__ = Logger.prototype.log;
			Logger.prototype.log = null;
		}
	}
			
	/**
	*	Gets the default publisher, which usually will be the trace output.
	*
	*	@return the default publisher instance
	*/
	public function getDefaultPublisher():IPublisher
	{
		if (this.defaultPublisher == undefined) {
			this.defaultPublisher = new DefaultPublisher();
		}
		return this.defaultPublisher;
	}

	private static var logger:Logger = Logger.getLogger("logging.PropertyLoader");
	private static var ROOT_NODE:String = "logging";
	private static var LOGGER_NODE:String = "logger";
	private static var PUBLISHER_NODE:String = "publisher";
	
	/**
	*	Convenience method to start reading the external logging properties.
	*	The method is supposed to be invoked by an application's main class on startup as part of the hook mechanism.
	*	Make sure you have registered a listener before in order to proceed.
	*
	*	@param configFile A file location which contains logging properties	
	*/
	public function loadCofig(configFile:String):Void
	{	
		var logger:Logger = Logger.getLogger("logging");
		
		var loader:XML = new XML();
		loader.ignoreWhite = true;
		loader["container"] = this;
		loader.onLoad = function (isLoaded:Boolean){
			this.container.onCofigLoaded(this, isLoaded);
		};
		
		logger.info("Start loading logging properties from '" + configFile + "'");
		
		loader.load(configFile);
	}
	
	function onCofigLoaded(xmlObject:XML, isLoaded:Boolean)
	{
		if (isLoaded)
		{
			var root:XMLNode = xmlObject.firstChild;
			
			if (root.nodeName != ROOT_NODE) 
			{
				logger.warning("Invalid root node '" + root.nodeName + "' found -> '" + ROOT_NODE + "' expected instead.");
				return;
			}
			
			if (root.attributes.enabled == "false") 
			{
				logger.info("Logging will be disabled.");
				LogManager.getInstance().disableLogging();
			}
			
			for (var i = 0; i < root.childNodes.length; i++) 
			{
				var loggerNode:XMLNode = root.childNodes[i];
				if (loggerNode.nodeName == LOGGER_NODE) 
				{
					handleLoggerProperties(loggerNode.attributes.name, loggerNode.attributes.level, loggerNode.attributes.filter);
					for (var j = 0; j < loggerNode.childNodes.length; j++) 
					{
						var publisherNode:XMLNode = loggerNode.childNodes[j];
						if (publisherNode.nodeName == PUBLISHER_NODE) 
						{
							handlePublisherProperties(loggerNode.attributes.name, publisherNode.attributes.name, publisherNode.attributes.formatter, publisherNode.attributes.level);
						} 
						else 
						{
							logger.warning("Invalid child node '" + publisherNode.nodeName + "' found -> '" + PUBLISHER_NODE + "' expected instead.");
						}
					}
				} 
				else 
				{
					logger.warning("Invalid child node '" + loggerNode.nodeName + "' found -> '" + LOGGER_NODE + "' expected instead.");
				}
			}
			
			dispatchEvent({type:"configApplied", target:this});
		} 
		else 
		{
			logger.warning("The file does not exist -> no logging properties loaded.");
		}
	}
	
	/**
	*	Handles appliable properties for loggers. 
	*
	*	Important: If a filter is specified, make sure to import and reference the given class so it can be accessed by the Logger framework
	*
	*	@param name the Logger's name string, e.g. "a.b.c"
	*	@param level the logging level, e.g. "WARNING"
	*	@param filter the filter class name, e.g. "com.domain.CustomFilter"
	*/
	private function handleLoggerProperties(name:String, level:String, filter:String):Void
	{
		try 
		{		
			Logger.getLogger(name).setLevel(Level.forName(level));
		} 
		catch (e:test_framework.logging.errors.InvalidLevelError)
		{
			logger.warning(e.toString());
		} 
		catch (e:test_framework.logging.errors.IllegalArgumentError) 
		{
			// silently ignore
		}
		
		try {
			Logger.getLogger(name).setFilter(LogManager.createFilterByName(filter));
		} catch (e:test_framework.logging.errors.ClassNotFoundError) {
			logger.warning(e.toString());
		} catch (e:test_framework.logging.errors.InvalidFilterError) {
			logger.warning(e.toString());
		} catch (e:test_framework.logging.errors.IllegalArgumentError) {
			// silently ignore
		}
	}
	
	/**
	*	Handles appliable properties for publishers. 
	*
	*	Important: If a publisher or formatter is specified, make sure to import and reference the given class so it can be accessed by the Logging Framework
	*
	*	@param name the Logger's name string, e.g. "a.b.c"
	*	@param publisher the publisher class name, e.g. "com.domain.CustomPublisher"
	*	@param filter the formatter class name, e.g. "com.domain.CustomFormatter"
	*/
	private function handlePublisherProperties(name:String, publisher:String, formatter:String, level:String):Void
	{
		var p:IPublisher;
		
		try {
			p = LogManager.createPublisherByName(publisher);
			Logger.getLogger(name).addPublisher(p);
		} catch (e:test_framework.logging.errors.ClassNotFoundError) {
			logger.warning(e.toString());
			return;
		} catch (e:test_framework.logging.errors.InvalidPublisherError) {
			logger.warning(e.toString());
			return;
		} catch (e:test_framework.logging.errors.IllegalArgumentError) {
			return;
		}
		
		try {		
			p.setLevel(Level.forName(level));
		} catch (e:test_framework.logging.errors.InvalidLevelError) {
			logger.warning(e.toString());
		} catch (e:test_framework.logging.errors.IllegalArgumentError) {
			// silently ignore
		}
		
		try {
			p.setFormatter(LogManager.createFormatterByName(formatter));
		} catch (e:test_framework.logging.errors.ClassNotFoundError) {
			logger.warning(e.toString());
		} catch (e:test_framework.logging.errors.InvalidFormatterError) {
			logger.warning(e.toString());
		} catch (e:test_framework.logging.errors.IllegalArgumentError) {
			// silently ignore
		}
	}
	
	/**
	*	Returns the Function object associated with the class with the given string name.
	*
	*	@return the Function object
	*/
	private static function getClassByName(className:String):Function
	{
		if(className == undefined || className == null) {
			throw new IllegalArgumentError("'" + className + "' is not allowed.");
		}		
		var c:Function = eval("_global." + className);
		if ( c == undefined ) {
			throw new ClassNotFoundError(className);
		}
		return c;
	}
}