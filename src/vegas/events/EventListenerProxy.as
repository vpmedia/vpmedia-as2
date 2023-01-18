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

import vegas.events.Delegate;
import vegas.events.Event;
import vegas.util.TypeUtil;

/**
 * This class extended the {@code Delegate} class and uses function or a string to defined the method to call by the virtual EventListener.
 * @author eKameleon 
 */
class vegas.events.EventListenerProxy extends Delegate 
{

	/**
	 * Creates a new EventListenerProxy instance.
	 * @param scope the scope of the method.
	 * @param method a {@code EventListener} or a string who represents the name of the scope method used to handle the events.
	 */
	public function EventListenerProxy(scope , method) 
	{
		this.__proto__.__constructor__.apply(this, [].concat(arguments)) ;
	}

	/**
	 * Returns a shallow copy of the object.
	 * @return a shallow copy of the object.
	 */  
	/*override*/ public function clone() {
		return new EventListenerProxy(getScope(), getMethod()) ;
	}
  
  	/**
  	 * Handles the event.
  	 */
	/*override*/ public function handleEvent(e:Event) 
	{ 
		if (_m instanceof Function) 
		{
			super.handleEvent(e) ;
		}
		else if (TypeUtil.typesMatch(_m, String)) 
		{
			var f:Function = _s[_m] ;
			if (f) 
			{
				return f.apply(_s || null, [e].concat(_a)) ;
			}
		}
    }
  
	private var _m ;
  
}