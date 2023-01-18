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
	
/* ------- 	ButtonEventType

	AUTHOR

		Name : ButtonEventType
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTRUCTOR
	
		Private
	
	CONSTANT SUMMARY
	
		- CLICK:ButtonEventType
		
		- UP:ButtonEventType
		
		- DISABLED:ButtonEventType
		
		- DOUBLE_CLICK:ButtonEventType
		
		- DOWN:ButtonEventType
		
		- DRAG:ButtonEventType
		
		- ICON_CHANGE:ButtonEventType
		
		- LABEL_CHANGE:ButtonEventType
		
		- MOUSE_UP:ButtonEventType
		
		- MOUSE_DOWN:ButtonEventType
		
		- OUT:ButtonEventType
		
		- OUT_SELECTED:ButtonEventType
		
		- OVER:ButtonEventType
		
		- OVER_SELECTED:ButtonEventType
		
		- ROLLOUT:ButtonEventType
		
		- ROLLOVER:ButtonEventType
		
		- SELECT:ButtonEventType
		
		- UNSELECT:ButtonEventType
		
		- UP:ButtonEventType
	
	INHERIT
	
		EventType
	
----------  */

import com.bourre.events.EventType;

import neo.events.MouseEventType;
import neo.events.UIEventType;

class neo.events.ButtonEventType extends EventType {

	// ----o Constructor
	
	private function ButtonEventType(s:String) {
		super(s) ;
	}

	// ----o Static Properties

	static public var CLICK:ButtonEventType = new ButtonEventType(MouseEventType.CLICK) ;
	
	static public var DISABLED:ButtonEventType = new ButtonEventType("disabled") ;
	
	static public var DOUBLE_CLICK:ButtonEventType = new ButtonEventType(MouseEventType.DOUBLE_CLICK) ;
	
	static public var DOWN:ButtonEventType = new ButtonEventType("down") ;

	static public var DRAG:ButtonEventType = new ButtonEventType("drag") ;
	
	static public var ICON_CHANGE:ButtonEventType = new ButtonEventType(UIEventType.ICON_CHANGE) ;
	
	static public var LABEL_CHANGE:ButtonEventType = new ButtonEventType(UIEventType.LABEL_CHANGE) ;
	
	static public var MOUSE_UP:ButtonEventType = new ButtonEventType(MouseEventType.MOUSE_UP) ;
	
	static public var MOUSE_DOWN:ButtonEventType = new ButtonEventType(MouseEventType.MOUSE_DOWN) ;
	
	static public var OUT:ButtonEventType = new ButtonEventType("out") ;
	
	static public var OUT_SELECTED:ButtonEventType = new ButtonEventType("outSelected") ;
	
	static public var OVER:ButtonEventType = new ButtonEventType("over") ;
	
	static public var OVER_SELECTED:ButtonEventType = new ButtonEventType("overSelected") ;
	
	static public var ROLLOUT:ButtonEventType = new ButtonEventType(MouseEventType.ROLLOUT) ;
	
	static public var ROLLOVER:ButtonEventType = new ButtonEventType(MouseEventType.ROLLOVER) ;
		
	static public var SELECT:ButtonEventType = new ButtonEventType("select") ;
	
	static public var UNSELECT:ButtonEventType = new ButtonEventType("unselect") ;
	
	static public var UP:ButtonEventType = new ButtonEventType("up") ;

	static private var __ASPF__ = _global.ASSetPropFlags(ButtonEventType, null , 7, 7) ;

}
