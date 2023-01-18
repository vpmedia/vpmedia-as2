/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.MouseEventType;

class pegas.events.ButtonEventType 
{

	static public var CLICK:String = MouseEventType.CLICK ;
	
	static public var DISABLED:String = "disabled" ;
	
	static public var DOUBLE_CLICK:String = MouseEventType.DOUBLE_CLICK ;
	
	static public var DOWN:String = "down" ;

	static public var DRAG:String = "drag" ;
	
	static public var ICON_CHANGE:String = "onIconChanged" ;
	
	static public var LABEL_CHANGE:String = "onLabelChanged" ;
	
	static public var MOUSE_UP:String = MouseEventType.MOUSE_UP ;
	
	static public var MOUSE_DOWN:String = MouseEventType.MOUSE_DOWN ;
	
	static public var OUT:String = "out" ;
	
	static public var OUT_SELECTED:String = "outSelected" ;
	
	static public var OVER:String = "over" ;
	
	static public var OVER_SELECTED:String = "overSelected" ;
	
	static public var ROLLOUT:String = MouseEventType.ROLLOUT ;
	
	static public var ROLLOVER:String = MouseEventType.ROLLOVER ;
		
	static public var SELECT:String = "select" ;
	
	static public var START_DRAG:String = "startDrag" ;
	
	static public var STOP_DRAG:String = "stopDrag" ;
	
	static public var UNSELECT:String = "unselect" ;
	
	static public var UP:String = "up" ;

	static private var __ASPF__ = _global.ASSetPropFlags(ButtonEventType, null , 7, 7) ;

}
