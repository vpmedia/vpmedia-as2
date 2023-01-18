/**
 * com.sekati.validate.TypeValidation
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced/adapted from nectere fw for dependencies only
 */
 
/**
 * Simple Type Validation class. 
 * @see {@link com.sekati.validate.StringValidation}
 */
class com.sekati.validate.TypeValidation {	

	/**
	 * get an objects type and return an info object containing properties:
	 * {@code
	 * 	.inspectable:Boolean, 
	 * 	.name:String;
	 * 	.stringify:Boolean;
	 * }
	 * @param o (Object)
	 * @return Object
	 */
	public static function getType(o:Object):Object {
		var typeOf:String = typeof (o);
		var type:Object = new Object();
		type.inspectable = true;
		type.name = typeOf;
		if (TypeValidation.isString(o) || TypeValidation.isBoolean(o) || TypeValidation.isNumber(o) || typeOf == "undefined" || typeOf == "null") {
			type.inspectable = false;
		} else if (o instanceof Date) {
			type.inspectable = false;
			type.name = "date";
		} else if (o instanceof Array) {
			type.name = "array";
		} else if (o instanceof Button) {
			type.name = "button";
		} else if (o instanceof MovieClip) {
			type.name = "movieclip";
		} else if (o instanceof XML) {
			type.name = "xml";
			type.stringify = true;
		} else if (o instanceof XMLNode) {
			type.name = "xmlnode";
			type.stringify = true;
		} else if (o instanceof Color) {
			type.name = "color";
		}
		return type;
	}
		
	public static function isNumber(val:Object):Boolean {
		return compare(val, "number", Number);
	}
	
	public static function isString(val:Object):Boolean {
		return compare(val, "string", String);
	}
	
	public static function isFunction(val:Object):Boolean {
		return compare(val, "function", Function);
	}
	
	public static function isBoolean(val:Object):Boolean {
		return compare(val, "boolean", Boolean);
	}
	
	public static function isArray(val:Object):Boolean {
		return compare(val, "array", Array);
	}
	
	public static function isDate(val:Object):Boolean {
		return compare(val, "date", Date);
	}
	
	public static function isSound(val:Object):Boolean {
		return compare(val, "sound", Sound);
	}
	
	public static function isMovieClip(val:Object):Boolean {
		return compare(val, "movieclip", MovieClip);
	}
	
	public static function isTextField(val:Object):Boolean {
		return compare(val, "textfield", TextField);
	}

	public static function isXML(val:Object):Boolean {
		return compare(val, "xml", XML);
	}
	
	public static function isXMLNode(val:Object):Boolean {
		return compare(val, "xmlnode", XMLNode);
	}
	
	public static function isObject(val:Object):Boolean {
		return compare(val, "object", Object);
	}
	
	public static function isInstanceOf(val:Object, classPath:Function):Boolean {
		return (val instanceof classPath);
	}
	
	public static function isNull(val:Object):Boolean {
		return (val == null || val == undefined || val == "");
	}
	
	private static function compare(val:Object, as1:String, as2:Function):Boolean {
		return (typeof(val) == as1 || val instanceof as2);
	}
	
	private function TypeValidation(){
	}
}