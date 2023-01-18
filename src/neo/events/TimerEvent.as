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

/* ------- 	TimerEvent

	AUTHOR

		Name : TimerEvent
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
		
	CONSTRUCTOR
	
		new TimerEvent(e:EventType, target) ;


	METHOD SUMMARY

	
		- getTarget():Object

		

		- getType():String

		

		- setTarget(target:Object):Void

		

		- setType(type:String):Void

		

		- toString():String

	INHERIT
	
		BasicEvent

			|

			TimerEvent
		
	IMPLEMENTS
	
		IEvent

----------  */

import com.bourre.core.HashCodeFactory;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class neo.events.TimerEvent extends BasicEvent {

	// ----o Constructor
	
	public function TimerEvent(e:EventType, target) {

		super(e, target) ;

	}


	// ----o Public Methods



	public function toString() : String {

		return '[TimerEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';

	}

	
}
