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

/**
 * This enumeration static class is based on ECMA-262 property attributes specification. See chapter 8.6.1 - PDF p38/188
 * @author eKameleon
 * @see Attribute
 * @see ASSetPropFlags
 */
class vegas.util.AttributeType 
{

	/**
	 * The NONE value(0).
	 */	
	static public var NONE:Number = 0 ;
	
	/**
	 * The DONT_ENUM value(1).
	 */	
	static public var DONT_ENUM:Number = 1 ;
	
	/**
	 * The DONT_DELETE value(2).
	 */
	static public var DONT_DELETE:Number = 2 ;

	/**
	 * The READ_ONLY value(4).
	 */
	static public var READ_ONLY:Number = 4 ;

	/**
	 * The OVERRIDE_ONLY value(3).
	 */
	static public var OVERRIDE_ONLY:Number = DONT_ENUM | DONT_DELETE ;

	/**
	 * The DELETE_ONLY value(5).
	 */
	static public var DELETE_ONLY:Number = DONT_ENUM | READ_ONLY ;

	/**
	 * The ENUM_ONLY value(6).
	 */
	static public var ENUM_ONLY:Number = READ_ONLY | DONT_DELETE ;

	/**
	 * The LOCKED value(7).
	 */
	static public var LOCKED:Number = DONT_DELETE | DONT_ENUM | READ_ONLY ;


	static private var __ASPF__ = _global.ASSetPropFlags(AttributeType, null, 7, 7) ;
	
}