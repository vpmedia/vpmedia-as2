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

/* ------- 	MouseEventType

	AUTHOR

		Name : MouseEventType
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-05
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		private
	
	CONSTANT SUMMARY
	
		- CLICK:MouseEventType
		
		- DOUBLE_CLICK:MouseEventType
		
		- MOUSE_DOWN:MouseEventType
		
		- MOUSE_MOVE:MouseEventType
		
		- MOUSE_OUT:MouseEventType
		
		- MOUSE_OVER:MouseEventType
		
		- MOUSE_UP:MouseEventType
		
		- MOUSE_WHEEL:MouseEventType
		

		- ROLLOUT:MouseEventType

		

		- ROLLOVER:MouseEventType



----------  */


import com.bourre.events.EventType;


class neo.events.MouseEventType extends EventType {

	// ----o Constructor
	
	private function MouseEventType(s:String) {
		super(s) ;
	}

	// ----o Constant


	static public var CLICK:MouseEventType = new MouseEventType("click") ;

	static public var DOUBLE_CLICK:MouseEventType = new MouseEventType("doubleClick") ;

	static public var MOUSE_DOWN:MouseEventType = new MouseEventType("mouseDown") ;

	static public var MOUSE_MOVE:MouseEventType = new MouseEventType("mouseMove") ;

	static public var MOUSE_OUT:MouseEventType = new MouseEventType("mouseOut") ;

	static public var MOUSE_OVER:MouseEventType = new MouseEventType("mouseOver") ;

	static public var MOUSE_UP:MouseEventType = new MouseEventType("mouseUp") ;

	static public var MOUSE_WHEEL:MouseEventType = new MouseEventType("mouseWheel") ;

	static public var ROLLOUT:MouseEventType = new MouseEventType("rollOut") ;

	static public var ROLLOVER:MouseEventType = new MouseEventType("rollOver") ;

	static private var __ASPF__ = _global.ASSetPropFlags(MouseEventType, null , 7, 7) ;

}
