/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- TypeUtil

	AUTHOR

		Name : TypeUtil
		Package : neo.util
		Version : 1.0.0.0
		Date : 2006-02-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTANT SUMMARY
	
		- const BOOLEAN:String
		
		- const COLOR:String
		
		- const DATE:String
		
		- const ERROR:String
		
		- const FUNCTION:String
		
		- const MOVIECLIP:String
		
		- const NULL:String
		
		- const NUMBER:String
		
		- const OBJECT:String
		
		- const STRING:String
		
		- const UNDEFINED:String
		
		- const XML:String
	
	METHOD SUMMARY
	
		- static compare(o1, o2) : Compares the type of 2 objects.
			
			Compares the types of two objects.
			
		- static isExplicitInstanceOf(o, class:Function)
			
			Checks if the passed-in object is an explicit instance of the passed-in class.
			
		- static isInstanceOf(o, type:Function)
			
			Checks if the passed-in object is an instance of the passed-in type.
		
		- static isPrimitive(o)
		
			Checks if the passed-in object is a primitive type.
			
		- static isTypeOf(o, type:String)
		
			Checks if the result of an execution of the typeof method on the passed-in object matches the passed-in type.
			
		- static typesMatch(o, type:Function)
		
			Checks if the type of the passed-in object matches the passed-in type
		

		- static toString(type:Function):String


----------  */

import neo.util.ConstructorUtil;

class neo.util.TypeUtil {
	
	// ----o Constructor
	
	private function TypeUtil() {
		//
	}

	

	// ----o CONSTANT

	static public var BOOLEAN:String = "boolean" ;
	static public var COLOR:String = "color" ;
	static public var DATE:String = "date" ;
	static public var ERROR:String = "error" ;
	static public var FUNCTION:String = "function" ;
	static public var MOVIECLIP:String = "movieclip" ;
	static public var NULL:String = "null" ;
	static public var NUMBER:String = "number" ;
	static public var OBJECT:String = "object" ;
	static public var STRING:String = "string" ;
	static public var UNDEFINED:String = "undefined" ;
	static public var XML:String = "xml" ;

	static private var __ASPF__ = _global.ASSetPropFlags(TypeUtil, null , 7, 7) ;

	// ----o Static Methods

	static public function compare(o1, o2):Boolean {
		return typeof(o1) == typeof(o2) ;
	}

	static public function isExplicitInstanceOf(o, c:Function):Boolean {
		if (TypeUtil.isPrimitive(o)) {
			var tof:String = typeof(o) ;
			if (c == String) return (tof == TypeUtil.STRING) ;
			else if (c == Number) return (tof == TypeUtil.NUMBER) ;
			else if (c == Boolean) return (tof == TypeUtil.BOOLEAN) ;
		} 
		return (o instanceof c	&& !(o.__proto__ instanceof c));
	}

	static public function isInstanceOf(o, type:Function):Boolean {
		if (type === Object) return true ;
		return (o instanceof type) ;
	}
	
	static public function isPrimitive(o):Boolean {
		var tof:String = typeof(o) ;
		return (tof == TypeUtil.STRING || tof == TypeUtil.NUMBER || tof == TypeUtil.BOOLEAN) ;
	}
	
	static public function isTypeOf(o, type:String):Boolean {
		return typeof(o) == type ;
	}

	static public function typesMatch(o, type:Function):Boolean {

		if (type === Object) return true ;
		if ( TypeUtil.isPrimitive(o) ) {
			var tof:String = typeof(o);
			if (tof == TypeUtil.STRING && (type === String || ConstructorUtil.isSubConstructorOf(type, String))) return true;
			else if (tof == TypeUtil.BOOLEAN && (type === Boolean || ConstructorUtil.isSubConstructorOf(type, Boolean))) return true;
			else if (tof == TypeUtil.NUMBER && (type === Number || ConstructorUtil.isSubConstructorOf(type, Number))) return true;
			else return false;
		} else {
			return (isInstanceOf(o, type));
		}
	}

	

	static public function toString(type:Function):String {

		if (type === undefined) return "undefined" ;

		if (type === null) return "null" ;

		var instance = ConstructorUtil.createBasicInstance(type) ;

		var path:String = ConstructorUtil.getPath(instance) ;

		if ( path != null) return path ;

		else if (type == Array) return "Array" ;

		else if (type == Boolean) return "Boolean" ;

		else if (type == Color) return "Color" ;

		else if (type == Date) return "Date" ;

		else if (type == Error) return "Error" ;

		else if (type == Number) return "Number" ;

		else if (type == String) return "String" ;

		else if (type == XML) return "XML" ;

		else if (type == XMLNode) return "XMLNode" ;

		else if (type == Function) return "Function" ;

		else return "Object" ;

	}

}
