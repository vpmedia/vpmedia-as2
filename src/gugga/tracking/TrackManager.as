import mx.events.EventDispatcher;

import gugga.logging.errors.ClassNotFoundError;
import gugga.logging.errors.IllegalArgumentError;
import gugga.logging.errors.InvalidFilterError;
import gugga.logging.errors.InvalidFormatterError;
import gugga.logging.errors.InvalidPublisherError;
import gugga.logging.Logger;
import gugga.tracking.IFilter;
import gugga.tracking.IFormatter;
import gugga.tracking.IPublisher;
import gugga.tracking.publishers.DefaultPublisher;
import gugga.tracking.Tracker;
import gugga.utils.DebugUtils;

[Event("configApplied")]
class gugga.tracking.TrackManager extends EventDispatcher
{		
	private static var instance:TrackManager = new TrackManager();	
	private var defaultPublisher:IPublisher;
	
	/**
	*	Private constructor.
	*/
	private function TrackManager() 
	{	
		//just state types to force compiler to include them
		//var defaultPublisherFakeVar:DefaultPublisher = null;
		//var bit101PublisherFakeVar:Bit101Publisher = null;
		//var sosPublisherFakeVar:SOSPublisher = null;
		
		//var simpleFormatterFakeVar:SimpleFormatter = null;
	}
	
	/**
	*	Get the singleton instance.
	*
	*	@return The LogManager instance
	*/
	public static function getInstance():TrackManager
	{
		if (instance == undefined) {
			instance = new TrackManager();
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
		if (Tracker.prototype.log == null) {
			Tracker.prototype.log = Tracker.prototype.__log__;
			Tracker.prototype.__log__ = null;
		}
	}
	
	/**
	*	Disables logging (logging is enabled by default) for all loggers.
	*/
	public function disableLogging():Void
	{
		if (Tracker.prototype.log != null) {
			Tracker.prototype.__log__ = Tracker.prototype.log;
			Tracker.prototype.log = null;
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

	private static var logger:Logger = Logger.getLogger("tracking.PropertyLoader");
	private static var ROOT_NODE:String = "tracking";
	private static var TRACKER_NODE:String = "tracker";
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
		var logger:Logger = Logger.getLogger("tracking");
		
		var loader:XML = new XML();
		loader.ignoreWhite = true;
		loader["container"] = this;
		loader.onLoad = function (isLoaded:Boolean){
			this.container.onCofigLoaded(this, isLoaded);
		};
		
		logger.info("Start loading logging properties from '" + configFile + "'");
		
		loader.load(configFile);
	}
	
	public function applyConfigFromXml(aXml:XML)
	{
		var root:XMLNode = aXml.firstChild;
		
		if (root.nodeName != ROOT_NODE) 
		{
			logger.warning("Invalid root node '" + root.nodeName + "' found -> '" + ROOT_NODE + "' expected instead.");
			return;
		}
		
		if (root.attributes.enabled == "false") 
		{
			logger.info("Logging will be disabled.");
			TrackManager.getInstance().disableLogging();
		}
		
		for (var i = 0; i < root.childNodes.length; i++) 
		{
			var loggerNode:XMLNode = root.childNodes[i];
			if (loggerNode.nodeName == TRACKER_NODE) 
			{
				handleTrackerProperties(loggerNode.attributes.name, loggerNode.attributes.actions, loggerNode.attributes.filter);
				for (var j = 0; j < loggerNode.childNodes.length; j++) 
				{
					var publisherNode:XMLNode = loggerNode.childNodes[j];
					if (publisherNode.nodeName == PUBLISHER_NODE) 
					{
						handlePublisherProperties(loggerNode.attributes.name, publisherNode.attributes.name, publisherNode.attributes.formatter, publisherNode.attributes.actions);
					} 
					else 
					{
						logger.warning("Invalid child node '" + publisherNode.nodeName + "' found -> '" + PUBLISHER_NODE + "' expected instead.");
					}
				}
			} 
			else 
			{
				logger.warning("Invalid child node '" + loggerNode.nodeName + "' found -> '" + TRACKER_NODE + "' expected instead.");
			}
		}
		
		dispatchEvent({type:"configApplied", target:this});
	}
	
	function onCofigLoaded(xmlObject:XML, isLoaded:Boolean)
	{
		if (isLoaded)
		{
			applyConfigFromXml(xmlObject);
		} 
		else 
		{
			logger.warning("The file does not exist -> no logging properties loaded.");
		}
	}
	
	/**
	*	Handles appliable properties for loggers. 
	*
	*	Important: If a filter is specified, make sure to import and reference the given class so it can be accessed by the Tracker framework
	*
	*	@param name the Tracker's name string, e.g. "a.b.c"
	*	@param level the logging level, e.g. "WARNING"
	*	@param filter the filter class name, e.g. "com.domain.CustomFilter"
	*/
	private function handleTrackerProperties(name:String, actions:String, filter:String):Void
	{
		try 
		{		
			Tracker.getTracker(name).setTrackableActions(actions);
		} 
		catch (e)
		{
			switch(true)
			{
				case (e instanceof gugga.logging.errors.InvalidLevelError):
					logger.warning(e.toString());
					break;					
						
				case (e instanceof gugga.logging.errors.IllegalArgumentError):
					// silently ignore
					break;					
			}
		} 
		
		try 
		{
			Tracker.getTracker(name).setFilter(TrackManager.createFilterByName(filter));
		} 
		catch (e)
		{
			switch(true)
			{
				case (e instanceof gugga.logging.errors.ClassNotFoundError):
					logger.warning(e.toString());
					break;				
					
				case (e instanceof gugga.logging.errors.InvalidFilterError):
					logger.warning(e.toString());
					break;	
						
				case (e instanceof gugga.logging.errors.IllegalArgumentError):
					// silently ignore
					break;					
			}
		} 
	}
	
	/**
	*	Handles appliable properties for publishers. 
	*
	*	Important: If a publisher or formatter is specified, make sure to import and reference the given class so it can be accessed by the Logging Framework
	*
	*	@param name the Tracker's name string, e.g. "a.b.c"
	*	@param publisher the publisher class name, e.g. "com.domain.CustomPublisher"
	*	@param filter the formatter class name, e.g. "com.domain.CustomFormatter"
	*/
	private function handlePublisherProperties(name:String, publisher:String, formatter:String, actions:String):Void
	{
		var p:IPublisher;
		
		try 
		{
			p = TrackManager.createPublisherByName(publisher);
			Tracker.getTracker(name).addPublisher(p);
		} 
		catch (e)
		{
			switch(true)
			{
				case (e instanceof gugga.logging.errors.ClassNotFoundError):
					logger.warning(e.toString());
					return;
					break;				
					
				case (e instanceof gugga.logging.errors.InvalidPublisherError):
					logger.warning(e.toString());
					return;
					break;	
						
				case (e instanceof gugga.logging.errors.IllegalArgumentError):
					// silently ignore
					return;
					break;					
			}
		}
		
		try 
		{		
			p.setTrackableActions(actions);
		} 
		catch (e)
		{
			switch(true)
			{
				case (e instanceof gugga.logging.errors.InvalidLevelError):
					logger.warning(e.toString());
					break;					
						
				case (e instanceof gugga.logging.errors.IllegalArgumentError):
					// silently ignore
					break;					
			}
		} 

		try {
			p.setFormatter(TrackManager.createFormatterByName(formatter));
		} 
		catch (e)
		{
			switch(true)
			{
				case (e instanceof gugga.logging.errors.ClassNotFoundError):
					logger.warning(e.toString());
					return;
					break;				
					
				case (e instanceof gugga.logging.errors.InvalidFormatterError):
					logger.warning(e.toString());
					return;
					break;	
						
				case (e instanceof gugga.logging.errors.IllegalArgumentError):
					// silently ignore
					return;
					break;					
			}
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