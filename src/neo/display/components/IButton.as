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

/* ------- IButton [Interface]

	AUTHOR
	
		Name : IButton
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	METHOD SUMMARY
	
		- getLabel():String
		
		- getSelected():Boolean
		
		- getToggle():Boolean
		
		- setLabel(str:String):Void
		
		- setSelected(b:Boolean, noEvent:Boolean):Void
		
		- setToggle(b:Boolean):Void
	
----------  */

interface neo.display.components.IButton {
	
	 function getLabel():String ;
		
	function getSelected():Boolean ;
	
	function getToggle():Boolean ;
	
	function setLabel(str:String):Void ;

	function setSelected (b:Boolean, noEvent:Boolean):Void ;
	
	function setToggle(b:Boolean):Void ;
	
}