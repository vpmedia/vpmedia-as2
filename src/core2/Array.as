
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is core2: ECMAScript core objects 2nd gig AS2. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2003-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
*/

//****************************************************************************
// ActionScript Standard Library
// Array object
//****************************************************************************

intrinsic dynamic class Array
{
	static var CASEINSENSITIVE:Number;
	static var DESCENDING:Number;
	static var NUMERIC:Number;
	static var RETURNINDEXEDARRAY:Number;
	static var UNIQUESORT:Number;

	var length:Number;

	function Array(value:Object);

	function concat(value:Object):Array;
	function join(delimiter:String):String;
	function pop():Object;
	function push(value):Number;
	function reverse():Void;
	function shift():Object;
	function slice(startIndex:Number, endIndex:Number):Array;
	function sort(compareFunction:Object, options: Number):Array; // 'compare' might be omitted so untyped. 'options' is optional.
	function sortOn(fieldName:Object, options: Object):Array; // 'fieldName' is a String, or an Array of String. 'options' is optional.
	function splice(startIndex:Number, deleteCount:Number, value:Object):Array;
	function toString():String;
	function unshift(value:Object):Number;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Array object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function clone():Array;
	function contains( value ):Boolean; // 'value' can be of any type
	function copy():Array;
	function copyTo( destination:Array, /*int*/ index:Number ):Void;
	function equals( arrObj:Array ):Boolean;
	function every( callback:Function, thisObject ):Boolean;
	function filter( callback:Function, thisObject ):Array;
	function forEach( callback:Function, thisObject ):Void;
	static function fromArguments( args ):Array;
	function indexOf( value, /*int*/ startIndex:Number, /*int*/ count:Number ):Number; /*int*/
	static function initialize( /*int*/ index:Number, value ):Array;
	function map( callback:Function, thisObject ):Array;
	function some( callback:Function, thisObject ):Boolean;
	function toSource( /*int*/ indent:Number, indentor:String ):String;
	
}