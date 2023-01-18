
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
// Date object
//****************************************************************************

intrinsic class Date
{
	function Date(yearOrTimevalue:Number,month:Number,date:Number,hour:Number,minute:Number,second:Number,millisecond:Number);

	static function UTC(year:Number,month:Number,date:Number,
                        hour:Number,minute:Number,second:Number,millisecond:Number):Number;

	function getDate():Number;
	function getDay():Number;
	function getFullYear():Number;
	function getHours():Number;
	function getMilliseconds():Number;
	function getMinutes():Number;
	function getMonth():Number;
	function getSeconds():Number;
	function getTime():Number;
	function getTimezoneOffset():Number;
	function getUTCDate():Number;
	function getUTCDay():Number;
	function getUTCFullYear():Number;
	function getUTCHours():Number;
	function getUTCMilliseconds():Number;
	function getUTCMinutes():Number;
	function getUTCMonth():Number;
	function getUTCSeconds():Number;
	function getUTCYear():Number; //runtime patch
	function getYear():Number; //runtime patch
	function setDate(date:Number):Number;
	function setFullYear(year:Number, month:Number, date:Number):Number;
	function setHours(hour:Number):Number;
	function setMilliseconds(millisecond:Number):Number;
	function setMinutes(minute:Number):Number;
	function setMonth(month:Number, date:Number):Number;
	function setSeconds(second:Number):Number;
	function setTime(millisecond:Number):Number;
	function setUTCDate(date:Number):Number;
	function setUTCFullYear(year:Number, month:Number, date:Number):Number;
	function setUTCHours(hour:Number, minute:Number, second:Number, millisecond:Number):Number;
	function setUTCMilliseconds(millisecond:Number):Number;
	function setUTCMinutes(minute:Number, second:Number, millisecond:Number):Number;
	function setUTCMonth(month:Number, date:Number):Number;
	function setUTCSeconds(second:Number, millisecond:Number):Number;
	function setYear(year:Number):Number;
	function toString():String;
	function valueOf():Number;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Date object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function clone():Date;
	function copy():Date;
	function equals( datObj:Date ):Boolean;
	//function getUTCYear():Number; //runtime patch
	//function getYear():Number; //runtime patch
	function toSource():String;
	
}