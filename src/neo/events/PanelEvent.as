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

/* ------- 	PanelEvent

	AUTHOR

		Name : PanelEvent
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
		
	CONSTRUCTOR
	
		new PanelEvent(e:EventType, key:Number, item:Object, target) ;

	PROPERTY SUMMARY
	
		- item:Object
		
		- key:Number

	METHOD SUMMARY
	
		- getTarget():Object
		
		- getType():String
		
		- setTarget(target:Object):Void
		
		- setType(type:String):Void
		
		- toString():String

	INHERIT
	
		BasicEvent
			|
			PanelEvent
		
	IMPLEMENTS
	
		IEvent

----------  */

import com.bourre.core.HashCodeFactory;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class neo.events.PanelEvent extends BasicEvent {

	// ----o Constructor
	
	public function PanelEvent(e:EventType, k, i, target) {
		super(e, target) ;
		key = k ;
		item = i ;
	}

	// ----o Public Properties
	
	public var item ;
	public var key:Number ;
	
	// ----o Public Methods

	public function toString() : String {
		return '[PanelEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';
	}
	
}
