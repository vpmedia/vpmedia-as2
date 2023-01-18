
/**
 * External Trace and Debug utils
 * 
 * Luminic Tracer implementation without all the extra crap
 * 
 * Usage:
 * 
 * import com.bumpslide.util.Debug;
 * Debug.trace( someObject );
 * Debug.error( "There was an error, dude.");
 * 
 */

class com.bumpslide.util.Debug {
	
	// Max recursion depth
	static var COLLAPSE_DEPTH : Number = 4;
	
	static var ENABLED = true;
	static var TIMER_ENABLED = false;
	
	// Debug Log levels
	static var Level = {
		LOG    : { name: 'LOG',   num:1 },
		DEBUG  : { name: 'DEBUG', num:2 },
		INFO   : { name: 'INFO',  num:4 },
		WARN   : { name: 'WARN',  num:8 },
		ERROR  : { name: 'ERROR', num:16},
		FATAL  : { name: 'FATAL', num:32}
	}

	private static var _lc : LocalConnection;
	
	private static function luminicTrace( debugData, logLevel) {
		if(!ENABLED) return;
		if(_lc==null) {
			// init
			_lc = new LocalConnection();
			Debug.debug = Debug.debugg;
		}		
		var o:Object = new Object();
		o.loggerId = null;
		o.levelName = logLevel.name;
		o.time = new Date();
		if(TIMER_ENABLED && typeof(debugData)!='object') debugData = getTimer() + ': '+debugData;
		o.argument = serializeObj(debugData, 1);
		_lc.send( "_luminicbox_log_console", "log", o );

		//_global.trace( debugData ); 
	}
	
	static function trace(o) {		
		luminicTrace(o, Level.LOG );
	}

	// luminic box log level (DEBUG) shortcut method
	static function log(o) {
		luminicTrace( o, Level.LOG );
	}
	
	// luminic box log level (DEBUG) shortcut method
	// note, Flash compiler doesn't like 'Debug.debug', so we call this debugg
	// and then the first time we trace something, we make the Debug.debug reference
	static function debugg(o) {
		luminicTrace( o, Level.DEBUG );
	}
	
	static var debug:Function;
	
	// luminic box log level (INFO) shortcut method
	static function info(o) {
		luminicTrace( o, Level.INFO );
	}
	
	// luminic box log level (WARN) shortcut method
	static function warn(o) {
		luminicTrace( o, Level.WARN );
	}
	
	// luminic box log level (ERROR) shortcut method
	static function error(o) {
		luminicTrace( o, Level.ERROR );
	}
	
	// luminic box log level (FATAL) shortcut method
	static function fatal(o) {
		luminicTrace( o, Level.FATAL );
	}	
		
	/*
	 * Original code from Pablo Costantini // LuminicBox.Log.ConsolePublisher 
	 */
	static function serializeObj(o,depth:Number) : Object {
		var type = getType(o);
		var serial = new Object();
		if(!type.inspectable) {
			serial.value = o;
		} else if(type.stringify) {
			serial.value = o+"";
		} else {
			if(depth <= COLLAPSE_DEPTH) {
				if(type.name == "movieclip" || type.name == "button") {
					serial.id = o + "";
				}
				var items:Array = new Array();
				if(o instanceof Array) {
					for (var pos:Number=0; pos<o.length; pos++) items.push( {property:pos,value:serializeObj( o[pos], (depth+1) )} );
				} else {
					for(var prop:String in o) items.push( {property:prop,value:serializeObj( o[prop], (depth+1) )} );
				}
				serial.value = items;
			} else {
				serial.reachLimit =true;
			}
		}
		serial.type = type.name;
		return serial;
	}	
	
	static function getType(o) : Object {
		var typeOf = typeof(o);
		var type = new Object();
		type.inspectable = true;
		type.name = typeOf;
		if(typeOf == "string" || typeOf == "boolean" || typeOf == "number" || typeOf == "undefined" || typeOf == "null") 
		{
			type.inspectable = false;
		} else if(o instanceof Date) 
		{
			// DATE
			type.inspectable = false;
			type.name = "date";
		} else if(o instanceof Array) 
		{
			// ARRAY
			type.name = "array";
		} else if(o instanceof Button) 
		{
			// BUTTON
			type.name = "button";
		} else if(o instanceof MovieClip) 
		{
			// MOVIECLIP
			type.name = "movieclip";
		} else if(o instanceof XML) 
		{
			// XML
			type.name = "xml";
			type.stringify = true;
		} else if(o instanceof XMLNode) 
		{
			// XML node
			type.name = "xmlnode";
			type.stringify = true;
		} else if(o instanceof Color) 
		{
			// COLOR
			type.name = "color";
		}
		return type;
	}
	
	
	static function test() {
		
		var testObj = {prop1:"String Value", numProp:2};
		var testArray = ["First", "Second", "Third"];
		var circularRef = { obj1: { testObj:testObj } };
		circularRef.obj1.circularReference = circularRef;
		
		Debug.trace("Testing Logger");
		Debug.trace("String...");
		Debug.trace("Hello, World");
		Debug.trace("Number...");
		Debug.trace(12345);
		Debug.trace("Simple Array...");
		Debug.trace(testArray);
		Debug.trace("Simple Object...");
		Debug.trace(testObj);
		Debug.trace("Complex Type...");
		Debug.trace( { arrayProp: [ 1, 3, 5, 8], objProp:testObj });
		Debug.trace("XML...");
		Debug.trace( new XML());
		Debug.trace("Date...");
		Debug.trace( new Date());
		Debug.trace("Color...");
		Debug.trace( new Color(_root) );
		Debug.trace("MovieClip");
		Debug.trace(_root);
		Debug.trace('Circular Reference...');
		Debug.trace(circularRef);
		
		Debug.log("This is a LOG message");
		Debug.debug("This is a DEBUG message");
		Debug.debug("This is an INFO message");
		Debug.warn("This is a WARN message");
		Debug.error("This is an ERROR message");
		Debug.fatal("This is a FATAL message");
		
	}
	
	
	
	
	private function Debug() {
		
	}
}