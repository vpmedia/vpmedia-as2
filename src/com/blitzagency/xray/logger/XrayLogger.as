import com.blitzagency.xray.logger.Debug;
import com.blitzagency.xray.logger.Logger;
/**
 * @author John Grden
 */
class com.blitzagency.xray.logger.XrayLogger implements Logger
{
	public static var CLASS_REF = com.blitzagency.xray.logger.XrayLogger;
	
	public static var DEBUG:Number = 0;
	
	public static var INFO:Number = 1;
	
	public static var WARN:Number = 2;
	
	public static var ERROR:Number = 3;
	
	public static var FATAL:Number = 4;
	
	public static var NONE:Number = 5;
	
	public static var XRAYNODUMP:String = "noDump";
	
	public static function resolveLevelAsName(p_level:Number):String
	{
		switch(p_level)
		{
			case 0:
				return "debug";
			break;
			
			case 1:
				return "info";
			break;
			
			case 2:
				return "warn";
			break;
			
			case 3:
				return "error";
			break;
			
			case 4:
				return "fatal";
			break;
			
			default:
				return "debug";
		}
	}
	
	private var level:Number = 0; // set to DEBUG by default
	private var movieClipRecursionDepth:Number = 2;
	private var objectRecursionDepth:Number = 4;
	private var indentation:Number = 0;
	
	function XrayLogger()
	{
		
	}

	public function setMovieClipRecursionDepth(p_recursionDepth:Number):Void
	{
		movieClipRecursionDepth = p_recursionDepth;
	}
	
	public function setObjectRecursionDepth(p_recursionDepth:Number):Void
	{
		objectRecursionDepth = p_recursionDepth;
	}
	
	public function setIndentation(p_indentation:Number):Void
	{
		indentation = p_indentation;
	}
	
	public function setLevel(p_level:Number):Void
	{
		if(level != undefined)
		{
			level = p_level;
		}
	}
	
	public function debug(message:String, dump:Object, package:String):Void
	{
		if(level > XrayLogger.DEBUG) return;
		if(package == undefined) package = "";
		log(message, dump, package, 0);
	}
	
	public function info(message:String, dump:Object, package:String):Void
	{
		if(level > XrayLogger.INFO) return;
		if(package == undefined) package = "";
		log(message, dump, package, 1);
	}
	
	public function warn(message:String, dump:Object, package:String):Void
	{
		if(level > XrayLogger.WARN) return;
		if(package == undefined) package = "";
		log(message, dump, package, 2);
	}
	
	public function error(message:String, dump:Object, package:String):Void
	{
		if(level > XrayLogger.ERROR) return;
		if(package == undefined) package = "";
		log(message, dump, package, 3);
	}
	
	public function fatal(message:String, dump:Object, package:String):Void
	{
		if(level > XrayLogger.FATAL) return;
		if(package == undefined) package = "";
		log(message, dump, package, 4);
	}
	
	/**
	 * Logs the {@code message} using the {@code Debug.trace} method if
	 * {@code traceObject} is turned off or if the {@code message} is of type
	 * {@code "string"}, {@code "number"}, {@code "boolean"}, {@code "undefined"} or
	 * {@code "null"} and using the {@code Debug.traceObject} method if neither of the
	 * above cases holds {@code true}.
	 *
	 * @param message the message to log
	 */
	public function log(message:String, dump:Object, package:String, level:Number):Void 
	{		
		// add time stamp
		message = "\n(" + getTimer() + ") " + message;

		Debug.trace(message, package, level);
		
		if(dump == XrayLogger.XRAYNODUMP) return;		
		
		// check to see if dump is an object or not
		var type:String = typeof(dump);
		//Debug.trace("typeof? " + (dump instanceof MovieClip), package, level);
		if (type == "string" || type == "number" || type == "boolean" || type == "undefined" || type == "null") 
		{
			if(dump == undefined) 
			{
				dump = "undefined";
			}
			Debug.trace(dump, package, level);
		}else if(dump instanceof MovieClip)
		{
			var str:String = "[MovieClip]" + eval(dump._target);
			str += ", _x:" + dump._x;
			str += ", _y:" + dump._y;
			str += ", _visible:" + dump._visible;
			str += ", _alpha:" + dump._alpha;
			str += ", _width:" + dump._width;
			str += ", height:" + dump._height;
			Debug.trace(str, package, level);
		}else
		{
			Debug.traceObject(dump, resolveDepth(dump), indentation, package, level);
		}
	}
	
	private function resolveDepth(obj:Object):Number
	{
		switch(typeof(obj))
		{
			case "movieclip":
				return movieClipRecursionDepth;
			break;
			
			case "object":
				return objectRecursionDepth;
			break;
			
			default:
				return objectRecursionDepth;
		}
	}
}
