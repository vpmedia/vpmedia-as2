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

import asgard.system.Lang;

import vegas.events.DynamicEvent;

/**
 * The {@code LangEvent} to dispatch an event with a Lang object inside.
 * @author eKameleon
 */
class asgard.events.LangEvent extends DynamicEvent 
{
	
	/**
	 * Creates a new LangEvent instance.
	 */
	public function LangEvent(type:String, lang:Lang, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		
		super(type, target, context, bubbles, eventPhase, time, stop);
		_lang = lang ;
		
	}

	/**
	 * Creates and returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone() 
	{
		return new LangEvent(getType(), getLang(), getTarget(), getContext()) ;
	}
	
	/**
	 * Returns the {@code Lang} instance.
	 * @return the {@code Lang} reference.
	 */
	public function getLang():Lang
	{
		return _lang ;	
	}
	
	/**
	 * Sets the Lang reference.
	 */
	public function setLang( lang:Lang ):Void
	{
		_lang = lang ;	
	}
	
	/**
	 * The internal Lang instance.
	 */
	private var _lang:Lang ;

}