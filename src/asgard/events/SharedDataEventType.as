/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/** SharedDataEventType

	AUTHOR

		Name : SharedDataEventType
		Package : asgard.events
		Version : 1.0.0.0
		Date :  2005-05-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
	
	CONSTANT SUMMARY

		- CHANGE:SharedDataEventType
		
			Invoque un événement pour informer "les utilisateurs" d'un changement au niveau du SharedData.
		
		- CLEAR:SharedDataEventType
		
		- CLOSE:SharedDataEventType
		
		- DELETE:SharedDataEventType
		
		- REJECT:SharedDataEventType
		
		- SUCCESS:SharedDataEventType
		
			Invoqué pour informer "l'utilisateur qu'il vient de changer une propriété du SharedData" que tout c'est bien passé. 
		
		- SYNCHRONISED:SharedDataEventType

**/

/**
 * @author eKameleon
 * @version 1.0.0.0
 **/	
class asgard.events.SharedDataEventType extends String {

	// ----o Constructor
	
	public function SharedDataEventType(s:String) {
		super(s) ;
	}

	// ----o Static Properties

	static public var CHANGE:SharedDataEventType = new SharedDataEventType("onChanged") ;

	static public var CLEAR:SharedDataEventType = new SharedDataEventType("onClear") ;
	
	static public var CLOSE:SharedDataEventType = new SharedDataEventType("onClosed") ;
	
	static public var DELETE:SharedDataEventType = new SharedDataEventType("onDeleted") ;

	static public var FIRE:SharedDataEventType = new SharedDataEventType("onFired") ;
	
	static public var REJECT:SharedDataEventType = new SharedDataEventType("onRejected") ;
	
	static public var SUCCESS:SharedDataEventType = new SharedDataEventType("onSuccess") ;

	static public var SYNCHRONISED:SharedDataEventType = new SharedDataEventType("onSynchronised") ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(SharedDataEventType, null , 7, 7) ;
	
}
