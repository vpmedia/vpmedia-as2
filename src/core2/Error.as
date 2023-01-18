
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
// Error object
//****************************************************************************

intrinsic class Error
{
	var message:String;
	var name:String;

	function Error(message:String);

	function toString():String;
	
    /*
      core2: ECMAScript core objects 2nd gig.
      
      Patch the Error object to compile for
      ActionScript v2.0 without causing compiler errors.
      
      attention:
      You have to include the ActionScript v1.0 files to
      be able to use these new features.
    */
	
	function equals( err:Error ):Boolean;
	function getMessage():String;
	function toSource():String;
	//function toString():String; //overrided
	
}