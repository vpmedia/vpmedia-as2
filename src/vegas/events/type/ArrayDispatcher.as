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

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.events.EDispatcher;
import vegas.events.IDispatcher;

class vegas.events.type.ArrayDispatcher extends Array implements IDispatcher, IFormattable, IHashable 
{

	private function ArrayDispatcher() 
	{
		splice.apply(this, [0, 0].concat(arguments));
		EDispatcher.initialize(this) ; 
	}

	static private var _initHashCode:Boolean = HashCode.initialize(ArrayDispatcher.prototype) ;
	
	public function addEventListener(eventName:String, obj, func):Void 
	{
		//
	}
	
	public function dispatchEvent(ev):Void 
	{
		//
	}

	public function hashCode():Number 
	{
		return null ;
	}
	
	public function eventListenerExists(eventName:String, obj , func):Boolean 
	{ 
		return undefined ;
	}
	
	public function removeAllEventListeners(eventName:String):Void 
	{
		//
	}
	
	public function removeEventListener(eventName:String, obj, func):Void 
	{
		//
	}
	
	public function updateEvent(eventName:String, oInit):Void 
	{
		//
	}

}