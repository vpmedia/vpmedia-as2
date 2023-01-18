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

import vegas.core.CoreObject;
import vegas.errors.Warning;
import vegas.events.BasicEvent;
import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.FrontController;
import vegas.util.TypeUtil;

/**
 * The NetSeverGateway create a gateway between the Flash client and the FMS server.
 * @author eKameleon
 * @see NetServerConnection
 */
class asgard.net.NetServerGateway extends CoreObject 
{
	
	/**
	 * Creates a new NetServerGateway instance.
	 */
	public function NetServerGateway() 
	{
		_controller = initController() ;
	}

	/**
	 * Returns {@code true] if the eventName is registered in the Gateway Controller.
	 * @param eventName the name of the event type in the internal controller.
	 */
	public function contains( eventName:String ):Boolean 
	{
		return _controller.contains(eventName) ;
	}
 
 	/**
	 * Returns the NetConnection reference of this instance.
	 * @return the NetConnection reference of this instance.
	 */
	public function getConnection():NetServerConnection 
	{
		return _connection ;
	}
 
	/**
	 * Returns the FrontController reference of this instance.
	 * @return the FrontController reference of this instance.
	 */
	public function getController():FrontController 
	{
		return _controller ;
	}

	/**
	 * Returns the singleton instance of class.
	 * @return singleton instance of class.
	 */
	public static function getInstance():NetServerGateway 
	{
		if ( _instance == null )
		{
			_instance = new NetServerGateway() ;
		}
		return _instance ;
	}

	/**
	 * Inits the NetServerGateway controller reference in the constructor of this instance.
	 * Overrides this method to customize initial Gateway controller.
	 */
	public function initController():FrontController 
	{
		return new vegas.events.FrontController() ;
	}

	/**
	 * Adds a new entry into the Gateway controller.
	 * @param eventName:String
	 * @param listener:EventListener
	 */
	public function insert( eventName:String , listener:EventListener ) 
	{
		_controller.insert(eventName, listener) ;
	}

	/**
	 * Invoqued when the NetServerConnection receive from the server a shared event.
	 * You must use class mapping in the server to register the BasicEvent or the 
	 * @see BasicEvent
	 */
	public function receiveSharedEvent( e ):Void
	{
		if (_controller != null)
		{
			if ( e instanceof BasicEvent)
			{
				_controller.fireEvent(e) ;
			}
			else if (TypeUtil.typesMatch(e, String) && e.length > 0)
			{
				_controller.fireEvent(new BasicEvent(e)) ;
			}
			else
			{
				throw new Warning(this + " receive a shared event or event type from the server but you can't propagate this event, the object isnt' an Event object or a String.") ;
			}
		}
		else
		{
			throw new Warning(this + " receive a shared event or event type from the server but you can't propagate this event with a FrontController 'null' or 'undefined'.") ;	
		}		
	}

	/**
	 * Remove an entry into the Gateway controller.
	 * @param eventName:String
	 */
	public function remove( eventName:String ):Void 
	{
		_controller.remove(eventName) ;
	}

	/**
	 * Set the NetServerGateway controller reference.
	 * @param NetServerConnection the AMF connector reference. 
	 */
	public function setConnection( connection:NetServerConnection ):Void 
	{
		if (_connection != null)
		{
			_connection.receiveSharedEvent = null ;
		}
		_connection = connection ;
		_connection.receiveSharedEvent = Delegate.create(this, receiveSharedEvent) ;
	}

	/**
	 * Sets the NetServerGateway controller reference.
	 */
	public function setController( controller:FrontController ):Void 
	{
		_controller = controller ;
	}

	private var _connection:NetServerConnection ;
	
	private var _controller:FrontController ;

	/**
	 * The internal singleton reference of this class.
	 */
	private static var _instance : NetServerGateway;
	
}