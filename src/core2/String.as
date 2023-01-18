
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
// String object
//****************************************************************************

intrinsic class String
{
	var length:Number;

	function String(value:String);

	static function fromCharCode():String;

	function charAt(index:Number):String;
	function charCodeAt(index:Number):Number;
	function concat(value:Object):String;
	//function endswith( endString:String ):Number; // Central API
	function indexOf(value:String, startIndex:Number):Number;
	function lastIndexOf(value:String, startIndex:Number):Number;
	//function replace( re:String, repl:String ):String; // Central API
	function slice(start:Number,end:Number):String;
	function split(delimiter:String, limit:Number):Array;
	function substr(start:Number,length:Number):String;
	function substring(start:Number,end:Number):String;
	function toLowerCase():String;
	function toString():String;
	function toUpperCase():String;
	function valueOf():String;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the String object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function clone():String;
	static function compare( strA:String, strB:String, ignoreCase:Boolean ):Number; /*int*/
	function compareTo( value ):Number; /*int*/
	function copy():String;
	function equals( strObj:String ):Boolean;
	static var empty:String;
	function endsWith( value:String ):Boolean; //Central API is bogus, this should return a BOOLEAN!
	static function format( format:String /*, ...*/ ):String;
	function indexOfAny( anyOf:Array, /*int*/ startIndex:Number, /*int*/ count:Number ):Number; /*int*/
	function insert( /*int*/ startIndex:Number, value:String ):String;
	function lastIndexOfAny( anyOf:Array, /*int*/ startIndex:Number, /*int*/ count:Number ):Number; /*int*/
	function _padHelper( /*int*/ totalWidth:Number, /*char*/ paddingChar:String, isRightPadded:Boolean ):String;
	function padLeft( /*int*/ totalWidth:Number, /*char*/ paddingChar:String ):String;
	function padRight( /*int*/ totalWidth:Number, /*char*/ paddingChar:String ):String;
	function replace( oldValue:String , newValue:String ):String; // runtime patch
	function startsWith( value:String ):Boolean;
	function toBoolean():Boolean;
	function toCharArray( /*int*/ startIndex:Number, /*int*/ count:Number ):Array;
	function toNumber():Number;
	function toObject():Object;
	function toSource():String;
	function _trimHelper( trimChars:Array, trimStart:Boolean, trimEnd:Boolean ):String;
	function trim( trimChars:Array ):String;
	function trimEnd( trimChars:Array ):String;
	function trimStart( trimChars:Array ):String;
	static var whiteSpaceChars:Array;
	
}