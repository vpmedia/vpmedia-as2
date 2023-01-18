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

/**
 * Enumeration static class with the IValidator event types.
 * @author eKameleon
 */
class vegas.events.ValidatorEventType 
{

	/**
	 * The name of the event invoqued when the IValidator is invalid.
	 */
	static public var INVALID:String = "invalid" ;

	/**
	 * The name of the event invoqued when the IValidator is valid.
	 */
	static public var VALID:String = "valid" ;

	static private var __ASPF__ = _global.ASSetPropFlags(ValidatorEventType, null , 7, 7) ;
	
}
