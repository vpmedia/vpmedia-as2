/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.util.ConstructorUtil;

/**
 * The {@code TypeUtil} utility class is an all-static class with methods for checking and working with the type of the object in AS2.
 * @author eKameleon
 */
class vegas.util.TypeUtil 
{
	
	/**
	 * The type of the 'boolean' objects.
	 */
	static public var BOOLEAN:String = "boolean" ;

	/**
	 * The type of the 'color' objects.
	 */
	static public var COLOR:String = "color" ;
	
	/**
	 * The type of the 'date' objects.
	 */
	static public var DATE:String = "date" ;
	
	/**
	 * The type of the 'error' objects.
	 */
	static public var ERROR:String = "error" ;
	
	/**
	 * The type of the 'function' objects.
	 */
	static public var FUNCTION:String = "function" ;
	
	/**
	 * The type of the 'movieclip' objects.
	 */
	static public var MOVIECLIP:String = "movieclip" ;

	/**
	 * The type of the 'null' objects.
	 */
	static public var NULL:String = "null" ;

	/**
	 * The type of the 'number' objects.
	 */
	static public var NUMBER:String = "number" ;
	
	/**
	 * The type of the 'object' objects.
	 */
	static public var OBJECT:String = "object" ;

	/**
	 * The type of the 'string' objects.
	 */
	static public var STRING:String = "string" ;

	/**
	 * The type of the 'undefined' objects.
	 */
	static public var UNDEFINED:String = "undefined" ;
	
	/**
	 * The type of the 'xml' objects.
	 */	
	static public var XML:String = "xml" ;

	static private var __ASPF__ = _global.ASSetPropFlags(TypeUtil, null , 7, 7) ;

	/**
	 * Compares the types of two objects.
	 * @return {@code true} if the two objects are the same primitive type.
	 */
	static public function compare(o1, o2):Boolean 
	{
		return typeof(o1) == typeof(o2) ;
	}

	/**
	 * Checks if the passed-in object is an explicit instance of the passed-in class.
	 * @return {@code true} if the passed-in object is an explicit instance of the passed-in class.
	 */
	static public function isExplicitInstanceOf(o, c:Function):Boolean 
	{
		if (TypeUtil.isPrimitive(o)) 
		{
			var tof:String = typeof(o) ;
			if (c == String) 
			{
				return (tof == TypeUtil.STRING) ;
			}
			else if (c == Number) 
			{
				return (tof == TypeUtil.NUMBER) ;
			}
			else if (c == Boolean) 
			{
				return (tof == TypeUtil.BOOLEAN) ;
			}
		} 
		return (o instanceof c	&& !(o.__proto__ instanceof c));
	}
	
	
	/**
	 * Checks if the passed-in object is a generic object.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.TypeUtil ;
	 * 
	 * trace( TypeUtil.isGenericObject( {} ) ) ; // true
	 * trace( TypeUtil.isGenericObject( new Object() ) ) ; // true
	 * trace( TypeUtil.isGenericObject( new Date() ) ) ; // false
	 * trace( TypeUtil.isGenericObject( new vegas.core.CoreObject() ) ) ; // false
	 * trace( TypeUtil.isGenericObject( new Number(2) ) ) ; // false
	 * trace( TypeUtil.isGenericObject( 2 ) ) ; // false
	 * }
	 * @return {@code true} if the passed-in object is a generic object.
	 */
	static public function isGenericObject(o):Boolean
	{
		return o.__proto__ == Object.prototype ;
	}

	/**
	 * Checks if the passed-in object is an instance of the passed-in type.
	 * @return {@code true} if the passed-in object is an instance of the passed-in type.
	 */
	static public function isInstanceOf(o, type:Function):Boolean 
	{
		if (type === Object) 
		{
			return true ;
		}
		return (o instanceof type) ;
	}
	
	/**
	 * Checks if the passed-in object is a primitive type.
	 * @return {@code true} if the passed-in object is a primitive type.
	 */
	static public function isPrimitive(o):Boolean 
	{
		var tof:String = typeof(o) ;
		return (tof == TypeUtil.STRING || tof == TypeUtil.NUMBER || tof == TypeUtil.BOOLEAN) ;
	}

	
	/**
	 * Checks if the result of an execution of the typeof method on the passed-in object matches the passed-in type.
	 * @return {@code true} if the result of an execution of the typeof method on the passed-in object matches the passed-in type.
	 */
	static public function isTypeOf(o, type:String):Boolean 
	{
		return typeof(o) == type ;
	}

	/**
	 * Checks if the type of the passed-in object matches the passed-in type.
	 * <p><b>Example :</b>
	 * {@code
	 * import vegas.util.TypeUtil ;
	 * 
	 * var s1:String = "hello world" ;
	 * var s2:String = new String("hello world") ;
	 * trace("s1 is string : " + TypeUtil.typesMatch( s1, String )) ; // output : 'true'
	 * trace("s2 is string : " + TypeUtil.typesMatch( s2, String )) ; // output : 'true'
	 * }
	 * </p>
	 * @see ConstructorUtil
	 */
	static public function typesMatch(o, type:Function):Boolean 
	{
		if (type === Object) 
		{
			return true ;
		}
		if ( TypeUtil.isPrimitive(o) ) 
		{
			var tof:String = typeof(o);
			if (tof == TypeUtil.STRING && (type === String || ConstructorUtil.isSubConstructorOf(type, String)))
			{
				return true ;
			}
			else if (tof == TypeUtil.BOOLEAN && (type === Boolean || ConstructorUtil.isSubConstructorOf(type, Boolean)))
			{
				return true ;
			}
			else if (tof == TypeUtil.NUMBER && (type === Number || ConstructorUtil.isSubConstructorOf(type, Number)))
			{
				return true ;
			}
			else
			{
				return false ;
			}
		}
		else 
		{
			return (isInstanceOf(o, type));
		}
	}
	
	/**
	 * Returns the string representation of the constructor function passed in argument.
	 * <p>If the constructor function is a custom class the method use the ConstructorUtil class.</p>
	 * @return the string representation of the type function passed in argument.
	 * @see ConstructorUtil.
	 */
	static public function toString( type:Function ):String 
	{
		if (type === undefined) 
		{
			return "undefined" ;
		}
		if (type === null) 
		{
			return "null" ;
		}
		var instance = ConstructorUtil.createBasicInstance(type) ;
		var path:String = ConstructorUtil.getPath(instance) ;
		if ( path != null) 
		{
			return path ;
		}
		else if (type == Array) 
		{
			return "Array" ;
		}
		else if (type == Boolean) 
		{
			return "Boolean" ;
		}
		else if (type == Color) 
		{
			return "Color" ;
		}
		else if (type == Date) 
		{
			return "Date" ;
		}
		else if (type == Error) 
		{
			return "Error" ;
		}
		else if (type == Number)
		{
			return "Number" ;
		}
		else if (type == String) 
		{
			return "String" ;
		}
		else if (type == XML) 
		{
			return "XML" ;
		}
		else if (type == XMLNode) 
		{
			return "XMLNode" ;
		}
		else if (type == Function) 
		{
			return "Function" ;
		}
		else 
		{
			return "Object" ;
		}
	}

}
