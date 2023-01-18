
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
// Object object
//****************************************************************************

intrinsic class Object
{
	static var prototype:Object;

	var __proto__:Object;
	var __resolve:Object;	
	var constructor:Object;

	function Object();

	static function registerClass(name:String, theClass:Function):Boolean;

	function addProperty(name:String, getter:Function, setter:Function):Boolean;
	function hasOwnProperty(name:String):Boolean;
	function isPropertyEnumerable(name:String):Boolean;
	function isPrototypeOf(theClass:Object):Boolean;
	function toLocaleString():String;
	function toString():String;
	function unwatch(name:String):Boolean;
	function valueOf():Object;
	function watch(name:String, callback:Function, userData:Object):Boolean;

    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Object object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
    
    function clone():Object;
    function copy():Object;
    function equals( obj:Object ):Boolean;
    function getConstructorName():String;
    function getConstructorPath():String;
    function hasProperty( name:String ):Boolean;
    function memberwiseClone():Object;
    function memberwiseCopy():Object;
    function propertyIsEnumerable( name:String ):Boolean;
    function referenceEquals( obj:Object ):Boolean;
    function toBoolean():Boolean;
    function toNumber():Number;
    function toObject():Object;
    function toSource( /*int*/ indent:Number, indentor:String ):String;
    
}