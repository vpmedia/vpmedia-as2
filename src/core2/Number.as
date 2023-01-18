
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
// Number object
//****************************************************************************

intrinsic class Number
{
	static var MAX_VALUE:Number;
	static var MIN_VALUE:Number;
	static var NaN:Number;
	static var NEGATIVE_INFINITY:Number;
	static var POSITIVE_INFINITY:Number;

	function Number(num:Object);

	function toString(radix:Number):String;	
	function valueOf():Number;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Number object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function clone():Number;
	function copy():Number;
	function equals( numObj:Number ):Boolean;
	function toBoolean():Boolean;
	function toExponential( /*int*/ fractionDigits:Number ):String; // runtime patch
	function toFixed( /*int*/ fractionDigits:Number ):String; // runtime patch
	function toNumber():Number;
	function toObject():Object;
	function toPrecision( /*int*/ precision:Number ):String; // runtime patch
	function toSource():String;
	
}