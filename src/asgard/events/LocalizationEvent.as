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

import asgard.system.Localization;

import vegas.events.BasicEvent;

/**
 * The LocalizationEvent is used in the Localization singleton to notify a change.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.events.LocalizationEvent extends BasicEvent 
{

	/**
	 * Creates a new LocalizationEvent instance.
	 */
	public function LocalizationEvent(type : String, localization:Localization, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, localization, context, bubbles, eventPhase, time, stop) ;
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new LocalizationEvent( getType (), Localization.getInstance() ) ;
	}
	
	/**
	 * Returns the current Lang of the Localization singleton.
	 * @return the current Lang of the Localization singleton.
	 */
	public function getCurrent() 
	{
		return Localization.getInstance().getCurrent() ;
	}

	/**
	 * Returns the current {@code Local} reference or the internal value of the Local property passed in argument with the string in argument.
	 * @return the current {@code Local} reference or the internal value of the Local property passed in argument with the string in argument.
	 */
	public function getLocale(sID:String)
	{
		return Localization.getInstance().getLocale(sID) ;
	}

}