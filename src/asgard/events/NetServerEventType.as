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
 * This enumeration static class defined all NetServer event types.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.events.NetServerEventType extends String 
{

	/**
	 * Creates a new NetServerEventType instance.
	 */
	public function NetServerEventType(s:String) 
	{
		super(s) ;
	}

	/**
	 * The name of the NetServerEvent when the connection is accepted.
	 */
	static public var ACCEPTED:NetServerEventType = new NetServerEventType("onAccepted") ;

	/**
	 * The name of the NetServerEvent when the connection is closed.
	 */
	static public var CLOSE:NetServerEventType = new NetServerEventType("onClosed") ;
	
	/**
	 * The name of the NetServerEvent when the connection is finished.
	 */
	static public var FINISH:NetServerEventType = new NetServerEventType("onFinished") ;
	
	/**
	 * The name of the NetServerEvent when the connection is started.
	 */
	static public var START:NetServerEventType = new NetServerEventType("onStarted") ;

	/**
	 * The name of the NetServerEvent when the connection status is changed.
	 */
	static public var NET_STATUS:NetServerEventType = new NetServerEventType("onStatus") ;

	/**
	 * The name of the NetServerEvent when the connection is out of time.
	 */
	static public var TIMEOUT:NetServerEventType = new NetServerEventType("onTimeOut") ;
	
}
