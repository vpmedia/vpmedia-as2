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

import asgard.events.LoaderEvent;
import asgard.net.URLLoader;

/**
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.events.URLLoaderEvent extends LoaderEvent 
{

	/**
	 * Creates a new URLLoaderEvent instance.
	 */
	public function URLLoaderEvent(
	
		type:String	, loader:URLLoader
		, nCode:Number
		, sError:String
		, context
		, bubbles:Boolean
		, eventPhase:Number
		, time:Number
		, stop:Number 
	) 
	
		{
		
		super(type, loader, nCode, sError, context, bubbles, eventPhase, time, stop) ; 
		
		}
	
	public function clone() 
	{
		return new URLLoaderEvent( getType(), URLLoader( getTarget() ) ) ;
	}
	
	public function getDataFormat():String 
	{
		return URLLoader(getTarget()).getDataFormat() ;
	}

}