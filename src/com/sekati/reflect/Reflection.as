/**
 * com.sekati.reflect.Reflection
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Reflection allows class introspection for logging and identification purposes.
 * {@code Usage:
 * 	var loader:Baseloader = new Baseloader("init");
 * 	Reflection.getFullyQualifiedClassName(loader);	// returns: "com.sekati.load.BaseLoader"
 * 	ClasReflection.getClassName(loader);				// returns: "BaseLoader"
 * 	Reflection.getPackageName(loader);					// returns: "com.sekati.load"
 * }
 */
class com.sekati.reflect.Reflection {

	/**
	 * Get the Fully Qualified Class Name Definition from a class instance.
	 * @param o (Object) instance object to identify.
	 * @return String - string representation of FQCN
	 * {@code Usage:
	 * 	Reflection.getFullyQualifiedClassName(myTest); // returns: "com.sekati.tests.MyTest"
	 * }
	 */
	public static function getFullyQualifiedClassName(o:Object):String {
		o = (typeof (o) == "function") ? Function( o ).prototype : o.__proto__;
		return (Reflection._containsDefinition( o )) ? Reflection._getFullyQualifiedClassName( o ) : Reflection._buildDefinition( "", _global, o );
	}

	/**
	 * Get the Class Name Definition from a class instance.
	 * @param o (Object) instance object to identify.
	 * @return String - string representation of CN
	 * {@code Usage:
	 * 	Reflection.getClassName(myTest); // returns: "MyTest"
	 * }
	 */	
	public static function getClassName(o:Object):String {
		var s:String = Reflection.getFullyQualifiedClassName( o );
		return s.substr( s.lastIndexOf( "." ) + 1 );
	}

	/**
	 * Get the Class Package Definition from a class instance.
	 * @param o (Object) instance object to identify.
	 * @return String - string representation of CP
	 * {@code Usage:
	 * 	Reflection.getPackageName(myTest);	// returns: "com.sekati.tests"
	 * }
	 */
	public static function getPackageName(o:Object):String {
		var s:String = Reflection.getFullyQualifiedClassName( o );
		return s.slice( 0, s.lastIndexOf( "." ) );
	}	

	/**
	 * Build the class instance definition and cache it as a property in the Object instance for future use.
	 * @param s (String) package start string.
	 * @param pkg (Object) top level object to recursively build definition from.
	 * @param o (Object) instance object to identify.
	 * @return String - the fully qualified class definition, if unable to locate Object name will be tried and if all else fails "undefined.Origin" is returned.
	 */	
	private static function _buildDefinition(s:String, pkg:Object, o:Object):String {
		for (var p:String in pkg) {
			var cProto:Function = pkg[p];
			if (cProto.__constructor__ === Object) {
				p = Reflection._buildDefinition( s + p + ".", cProto, o );
				if (p) return p;
			} else if (cProto.prototype === o) {
				Reflection._setFullyQualifiedClassName( o, s + p );
				return s + p;				
			}
		}
	}

	/**
	 * Check if the instance already contains a cached FQCN
	 * @param o (Object) instance object
	 * @return Boolean
	 */
	private static function _containsDefinition(o:Object):Boolean {
		return Boolean( o.__FQCN.length > 0 );
	}

	/**
	 * Return the cached FQCN
	 * @param o (Object) instance object
	 * @return String - FQCN
	 */
	private static function _getFullyQualifiedClassName(o:Object):String {
		return o.__FQCN;
	}

	/**
	 * Cache the FQCN as a property in the object instance.
	 * @param o (Object) instance object
	 * @return Void
	 */
	private static function _setFullyQualifiedClassName(o:Object, s:String):Void {
		o.__fullyQualifiedClassName = s;
		_global.ASSetPropFlags( o, [ "__FQCN" ], 7, 1 );
	}

	private function Reflection() {
	}
}