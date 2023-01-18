import gugga.debug.MethodCallInfo;
import gugga.logging.Level;
import gugga.logging.Logger;
import gugga.utils.DebugUtils;
import gugga.utils.Weaver;
import gugga.logging.publishers.SOSPublisher;
import gugga.utils.ReflectUtil;
import mx.events.EventDispatcher;
/**
 * @author Todor Kolev
 */
class gugga.debug.Debugger 
{
	private var mDebuggedObject : Object;
	public function get DebuggedObject() : Object { return mDebuggedObject; }
	
	private function Debugger(aDebuggedObject : Object)
	{
		mDebuggedObject = aDebuggedObject;
		
		Weaver.weaveToAllAccessors(mDebuggedObject, traceContextFiner, traceContextFinished);
	
		var methodNames : Array = ReflectUtil.getMethodNames(mDebuggedObject); 	
		
		var methodName : String;
		for(var i : Number = 1; i < methodNames.length; i++)
		{
			methodName = methodNames[i];
			if(methodName != "addEventListener" && methodName != "dispatchEvent" && methodName != "dispatchEventLater")
			{
				if(methodName.indexOf("on") == 0 && methodName.charCodeAt(2) >= 65 && methodName.charCodeAt(2) <= 90)
				{
					Weaver.weaveToMethod(aDebuggedObject, methodName, traceEventHandler, traceContextFinished);
				}
				else
				{
					Weaver.weaveToMethod(aDebuggedObject, methodName, traceContextFine, traceContextFinished);
				}
			}
		}
		
		if(aDebuggedObject["addEventListener"])
		{
			Weaver.weaveToMethod(aDebuggedObject, "addEventListener", traceContextFinest, traceContextFinished);
		}
		if(aDebuggedObject["dispatchEvent"])
		{
			Weaver.weaveToMethod(aDebuggedObject, "dispatchEvent", traceDispatchEvent, traceContextFinished);
		}
		if(aDebuggedObject["dispatchEventLater"])
		{
			Weaver.weaveToMethod(aDebuggedObject, "dispatchEventLater", traceDispatchEvent, traceContextFinished);
		}
	}
	
	public static function create(aDebuggedObject : Object) : Debugger
	{
		return new Debugger(aDebuggedObject);
	}
	
	private function traceEventHandler(aCallData:MethodCallInfo)
	{
		var logger : Logger = Logger.getLoggerFor(aCallData.ScopeObject);		
		var contextString : String = DebugUtils.getCallContextString(aCallData.ScopeObject, aCallData.Arguments);
		var eventInfo : String = DebugUtils.getDumpString(aCallData.Arguments[0]);
		
		var logString:String = SOSPublisher.getFoldedMessagePackage(contextString, eventInfo);
		
		logger.log(Level.FINER, logString);
	}

	private function traceDispatchEvent(aCallData:MethodCallInfo)
	{
		var logger : Logger = Logger.getLoggerFor(aCallData.ScopeObject);		
		var contextString : String = DebugUtils.getCallContextString(aCallData.ScopeObject, aCallData.Arguments);
		var eventInfo : String = DebugUtils.getDumpString(aCallData.Arguments[0]);
		
		var logString:String = SOSPublisher.getFoldedMessagePackage(contextString, eventInfo);
		
		logger.log(Level.FINER, logString);
	}
	
	private function traceContextFinished(aCallData:MethodCallInfo, aMethodResult)
	{
		var logger : Logger = Logger.getLoggerFor(aCallData.ScopeObject);		
		var logText : String = DebugUtils.getCallContextString(aCallData.ScopeObject, aCallData.Arguments);
		
		var methodResultString : String = DebugUtils.objectToString(aMethodResult);
		logText = logText + " finished! Returned: " + methodResultString;
		
		var typeofMethodResult : String = typeof(aMethodResult);
		if(typeofMethodResult == "object" || typeofMethodResult == "movieclip" || typeofMethodResult == "function")
		{
			var methodResultDump : String = DebugUtils.getDumpString(aMethodResult, 0);
			var logTextBody : String = "Returned result dump:\n" + methodResultDump;
			
			logText = SOSPublisher.getFoldedMessagePackage(logText, logTextBody);
		}
		
		logger.log(Level.FINEST, logText);
	}
	
	private static function traceContext(aCallData:MethodCallInfo, aLogLevel:Level)
	{
		var logger : Logger = Logger.getLoggerFor(aCallData.ScopeObject);		
		var contextString : String = DebugUtils.getCallContextString(aCallData.ScopeObject, aCallData.Arguments);
		
		if(aCallData.Arguments.length > 0)
		{
			var argumentsDump : String = DebugUtils.getDumpString(aCallData.Arguments, 1);
			var logTextBody : String = "Arguments dump:\n" + argumentsDump;
			
			contextString = SOSPublisher.getFoldedMessagePackage(contextString, logTextBody);
		}
		
		logger.log(aLogLevel, contextString);
	}	
			
	private function traceContextFine(aCallData:MethodCallInfo)
	{
		Debugger.traceContext(aCallData, Level.FINE);
	}

	private function traceContextFiner(aCallData:MethodCallInfo)
	{
		Debugger.traceContext(aCallData, Level.FINER);
	}

	private function traceContextFinest(aCallData:MethodCallInfo)
	{
		Debugger.traceContext(aCallData, Level.FINEST);
	}
}