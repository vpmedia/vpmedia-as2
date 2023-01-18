
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
// Boolean object
//****************************************************************************

intrinsic class Boolean
{
	function Boolean(value:Object);

	function toString():String;
	function valueOf():Boolean;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Boolean object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function compareTo( obj:Boolean ):Number; /*int*/
	function clone():Boolean;
	function copy():Boolean;
	function equals( boolObj:Boolean ):Boolean;
	function toBoolean():Boolean;
	function toNumber():Number;
	function toObject():Object;
	function toSource():String;
	
}