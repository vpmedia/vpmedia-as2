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

import asgard.net.NetServerConnection;
import asgard.net.NetServerInfo;
import asgard.net.NetServerStatus;

import vegas.events.DynamicEvent;

/**
 * This Event contains the NetServerConnection and status of a connection in the application.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.events.NetServerEvent extends DynamicEvent 
{

	/**
	 * Creates a new NetServerEvent instance.
	 */
	public function NetServerEvent( type:String, connection:NetServerConnection, status:NetServerStatus, info, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number )
	{
		super(type, connection, context, bubbles, eventPhase, time, stop) ;
		setInfo(info) ;
		setStatus(status) ;
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new NetServerEvent( getType(), NetServerConnection(getTarget()), getStatus(), getInfo(), getContext()) ;
	}

	/**
	 * Returns the NetServerInfo reference of this event.
	 * @return the NetServerInfo reference of this event.
	 */
	public function getInfo():NetServerInfo 
	{
		return _info ;	
	}
	
	/**
	 * Returns the NetServerStatus reference of this event.
	 * @return the NetServerStatus reference of this event.
	 */
	public function getStatus():NetServerStatus 
	{
		return _status ;	
	}

	/**
	 * Sets the NetServerInfo reference of this event.
	 * @param oInfo the info {@code Object} used to define the NetServerInfo reference.
	 */
	public function setInfo( oInfo ):Void 
	{
		if (oInfo instanceof NetServerInfo) 
		{
			_info = oInfo ;
		} 
		else if (typeof(oInfo) == "object") 
		{
			_info = new NetServerInfo(oInfo) ;	
		} 	
		else
		{
			_info = null ;
		}
	}
	
	/**
	 * Sets the NetServerStatus reference of this event.
	 * @param status the NetServerStatus of this event.
	 */
	public function setStatus(status:NetServerStatus):Void 
	{
		_status = NetServerStatus.validate(status) ? status : null ;
	}
	
	private var _info:NetServerInfo ;
	private var _status:NetServerStatus ;

	/**
	 * Internal method used in the toSource() method.
	 */
	/*protected*/ private function _getParams():Array 
	{
		var ar:Array = super._getParams() ;
		ar.splice(2, null, getStatus().toSource()) ;
		ar.splice(3, null, getInfo().toSource()) ;
		return ar ;
	}

}
