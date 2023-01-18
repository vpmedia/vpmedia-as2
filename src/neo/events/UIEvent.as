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

/* ------- 	UIEvent

	AUTHOR

		Name : UIEvent
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-05
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		new UIEvent(e:EventType, target) ;

	PROPERTY SUMMARY

		- child
		
		- index:Number
	
	METHOD SUMMARY
	
		- getTarget():Object
		
		- getType():String
		
		- setTarget(target:Object):Void
		
		- setType(type:String):Void
		
		- toString():String
		
	INHERIT
	
		Object > BasicEvent > MouseEvent
		
	IMPLEMENTS
	
		IEvent

----------  */

import com.bourre.core.HashCodeFactory;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class neo.events.UIEvent extends BasicEvent {

	// ----o Constructor
	
	public function UIEvent(e:EventType, target){
		super(e, target) ;
	}

	// ----o Public Properties
	
	public var child ;
	public var index:Number ;
	
	public static var CHANGE : EventType;;

	// ----o Public Methods

	public function toString() : String {
		return '[UIEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';
	}
	
}
