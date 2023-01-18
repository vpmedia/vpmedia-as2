import gugga.debug.Debugger;
import gugga.logging.Logger;
import gugga.logging.publishers.SOSPublisher;
import gugga.utils.ReflectUtil;
import gugga.utils.SOSTraceUtil;

class gugga.utils.DebugUtils 
{	
	private static var mSOSTraceSocket : XMLSocket = new XMLSocket();
	private static var mSOSCommandSocket : XMLSocket = new XMLSocket();
	private static var mSocketsInitialized : Boolean = false;
	
	public static function setDebugMarker(aObject : Object, aMarker : String)
	{
		aObject["___debug_marker"] = aMarker;
	}

	public static function getDebugMarker(aObject : Object)
	{
		return aObject["___debug_marker"];
	}
	
	public static function getCallContextString(aContextObject, aCallArguments) : String
	{
		var argumentsArray : Array = aCallArguments;
		var argumentsString : String = arrayToString(argumentsArray);
		
		var contextMethod : Function = aCallArguments.callee;		
		var typeAndMethodInfo : Array; 
		
		if(typeof(aContextObject) == "function")
		{
			typeAndMethodInfo = ReflectUtil.getTypeAndMethodInfoByType(aContextObject, contextMethod);
		}
		else
		{
			typeAndMethodInfo = ReflectUtil.getTypeAndMethodInfoByInstance(aContextObject, contextMethod);
		}

		var contextString : String;
		contextString = typeAndMethodInfo[1] + "." + typeAndMethodInfo[2] + "(" + argumentsString + ")";
		
		return contextString;
	}
	
	private static function arrayToString(aArray : Array) : String
	{
		var result : String = "";

		for(var i : Number = 0; i < aArray.length; i++)
		{
			if(result != "")
			{
				result += ", ";	
			}
			
			result += objectToString(aArray[i]);	
		}
		
		return result;
	}
	
	//TODO: should be moved in another class
	public static function objectToString(aObject) : String
	{
		var result : String = "";
		
		if(aObject instanceof Array)
		{
			var objectAsArray : Array = aObject;
			result = "[" + arrayToString(objectAsArray) + "]";
		}
		else
		{
			switch(typeof(aObject))
			{
				case "string":
					result = "\"" + aObject + "\"";
				break;
				
				case "function":
					if(aObject[ReflectUtil.METHOD_NAME_KEY])
					{
						result = "[Function: " + aObject[ReflectUtil.METHOD_NAME_KEY] + "]";
					}
					else
					{
						result = "[Function]";
					}
				break;
				
				case "object":
					result = aObject.toString();
					
					if(result == "[object Object]")
					{
						result = ReflectUtil.getTypeNameForInstance(aObject);
					}
					
					if(!result)
					{
						result = "[Object]";
					}
				break;
				
				case "movieclip":
					result = aObject;
				break;
				
				// "number", "boolean", null, undefined
				default:
					result = aObject.toString();
			}
		}
		
		return result;
	}
		
	public static function trace(aTracedObject)
	{
		if(aTracedObject instanceof Object)
		{
			dump(aTracedObject);
		}
		else
		{
			SOSTraceUtil.trace(aTracedObject);
		}
	}
	
	public static function traceContext(aTracedObject, contextObject:Object, contextArguments:Object)
	{
		if(aTracedObject instanceof Object)
		{
			dump(aTracedObject, null, null, contextObject, contextArguments);
		}
		else
		{
			var contextString : String = getCallContextString(contextObject, contextArguments);
			var logger : Logger = Logger.getLoggerFor(contextObject);
			
			logger.info(aTracedObject.toString() + " [" + contextString + "]");
		}
	}
	
	public static function dump(o:Object, marker:String, recurseDepth:Number) : Void 
	{
		var title : String = getDumpTitle(o, marker);
		var dumpString : String = getDumpString(o, recurseDepth, 0);
	
		SOSTraceUtil.traceFoldedMessage(title, dumpString);
	}

	public static function dumpContext(o:Object, marker:String, recurseDepth:Number, contextObject:Object, contextArguments:Object) : Void 
	{
		var title : String = getDumpTitle(o, marker);
		var dumpString : String = getDumpString(o, recurseDepth, 0);
		var contextString : String = getCallContextString(contextObject, contextArguments);
		
		title += " [" + contextString + "]";
	
		var logger : Logger = Logger.getLoggerFor(contextObject);
		var dumpStringPackage : String = SOSPublisher.getFoldedMessagePackage(title, dumpString);
		
		logger.info(dumpStringPackage);
	}
	
	public static function getDumpTitle(aObject:Object, aMarker:String) : String
	{
		var title : String;
		
		var objectAsString : String = objectToString(aObject);
		
		if(aMarker)
		{
			setDebugMarker(aObject, aMarker);
			title = aMarker + " <" + objectAsString + ">";
		}
		else
		{
			title = objectAsString;
		}
		
		return title;
	}
	
	public static function getDumpString(aObject:Object, aRecurseDepth:Number, indent:Number) : String 
	{
		if(aRecurseDepth == undefined)
		{
			aRecurseDepth = 0;
		}
		
		if(indent == undefined)
		{
			indent = 0;
		}
		
		var dumpResult : String = "";
		
		var lead:String = "";
		for(var i=0;i<indent;i++)
		{
			lead += ".   ";
		}
		
		for (var prop:String in aObject)
		{	
			var obj:String;
			if(aObject[prop] instanceof Array)
			{
			    obj = "[Array]";
			}
			else
			{
    			obj = objectToString(aObject[prop]);
    		}
			    		
			dumpResult += lead + prop + ": " + obj + "\n";// + " (" + typeof o[prop] + ")");
			
			if(aRecurseDepth > 0)
			{
				var typeofObjectProperty : String = typeof(aObject[prop]);
				if(typeofObjectProperty == "object" || typeofObjectProperty == "movieclip" || typeofObjectProperty == "function")
				{
					dumpResult += getDumpString(aObject[prop], aRecurseDepth - 1, indent+1);
				}
			}
		}
		
		return dumpResult;
	}
}
