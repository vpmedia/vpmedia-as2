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

/* ------- 	ModelChangedEvent

	AUTHOR

		Name : ModelChangedEvent
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR

	

		Private.


	CONSTANT SUMMARY

		- ADD_ITEMS:ModelChangedEventType
		
		- CLEAR_ITEMS:ModelChangedEventType
		
		- MODEL_CHANGED:ModelChangedEventType
			
		- REMOVE_ITEMS:ModelChangedEventType
			
		- SORT_ITEMS:ModelChangedEventType
		
		- UPDATE_ALL:ModelChangedEventType
		
		- UPDATE_FIELD:ModelChangedEventType
		
		- UPDATE_ITEMS:ModelChangedEventType
	

	INHERIT

	

		EventType
	
----------  */


import com.bourre.events.EventType;



class neo.events.ModelChangedEventType extends EventType {

	// ----o Constructor
	
	public function ModelChangedEventType(s:String) {

		super(s) ;

	}

	// ----o Constant
	
	static public var ADD_ITEMS:ModelChangedEventType = new ModelChangedEventType("addItems") ; 

	static public var CLEAR_ITEMS:ModelChangedEventType = new ModelChangedEventType("clearItems") ;

	static public var MODEL_CHANGED:ModelChangedEventType = new ModelChangedEventType("modelChanged") ;

	static public var REMOVE_ITEMS:ModelChangedEventType = new ModelChangedEventType("removeItems") ;

	static public var SORT_ITEMS:ModelChangedEventType = new ModelChangedEventType("sortItems") ;

	static public var UPDATE_ALL:ModelChangedEventType = new ModelChangedEventType("updateAll") ;

	static public var UPDATE_FIELD:ModelChangedEventType = new ModelChangedEventType("updateField") ;

	static public var UPDATE_ITEMS:ModelChangedEventType = new ModelChangedEventType("updateItems") ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(ModelChangedEventType, null , 7, 7) ;
	
}
