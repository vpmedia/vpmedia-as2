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

/* ------- 	ActionEventType

	AUTHOR

		Name : ActionEventType
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTANT SUMMARY

		- CHANGED:ActionEventType
		
			"changed"
		
		- CLEARED:ActionEventType
		
			"cleared"
		
		- FINISHED:ActionEventType
		
			"finished"
		
		- LOOPED:ActionEventType
		
			"looped"
		
		- PROGRESS:ActionEventType
		
			"progress"
		
		- RESUMED:ActionEventType
		
			"resumed"
		
		- STARTED:ActionEventType
		
			"started"
		
		- STOPPED:ActionEventType
		
			"stopped"

----------  */

import com.bourre.events.EventType;

class neo.events.ActionEventType extends EventType {

	// ----o Constructor
	
	private function ActionEventType(s:String) {
		super(s) ;
	}

	// ----o Static Properties
	
	static public var CHANGED:ActionEventType = new ActionEventType("onChanged") ;
	
	static public var CLEARED:ActionEventType = new ActionEventType("onCleared") ;
	
	static public var FINISHED:ActionEventType = new ActionEventType("onFinished") ;
	
	static public var LOOPED:ActionEventType = new ActionEventType("onLooped") ;
	
	static public var PROGRESS:ActionEventType = new ActionEventType("onProgress") ;
	
	static public var RESUMED:ActionEventType = new ActionEventType("onResumed") ;
	
	static public var STARTED:ActionEventType = new ActionEventType("onStarted") ;
	
	static public var STOPPED:ActionEventType = new ActionEventType("onStopped") ;	
	
	static private var __ASPF__ = _global.ASSetPropFlags(ActionEventType, null , 7, 7) ;
	
}
