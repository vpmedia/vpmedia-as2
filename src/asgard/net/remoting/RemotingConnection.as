/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.net.NetServerConnection;
import asgard.net.remoting.RemotingAuthentification;
import asgard.net.remoting.RemotingConnectionCollector;

/**
 * The NetServerConnection object used in the RemotingService class to connect the client with the server.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.net.remoting.RemotingConnection extends NetServerConnection 
{

	/**
	 * Creates a new RemotingConnection instance.
	 * @param sURL the url of the connection.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */	
	function RemotingConnection( sURL:String , bGlobal:Boolean , sChannel:String ) 
	{
		super( bGlobal , sChannel ) ;
		if ( sURL != null && sURL.length > 0 ) 
		{
			this.connect( sURL );
		}
	}

	/**
	 * The string value of the amf server debug attribut.
	 */
	static public var AMF_SERVER_DEBUG:String = "amf_server_debug" ;
	
	/**
	 * The string representation of the Credentials namespace.
	 */
	static public var CREDENTIALS:String = "Credentials" ;
	
	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new RemotingConnection( uri ) ;	
	}
	
	/**
	 * Returns the RemotingConnection reference defines with the specified url representation.
	 * @return the RemotingConnection reference defines with the specified url representation.
	 */
	static public function getConnection( sUrl:String ):RemotingConnection 
	{
		if ( ! RemotingConnectionCollector.contains(sUrl) ) 
		{
			RemotingConnectionCollector.insert(sUrl, new RemotingConnection( sUrl ));
		}
		return RemotingConnectionCollector.get(sUrl) ;
	}

	/**
	 * Sets the credentials authentification value of this connection.
	 */
	public function setCredentials( authentification:RemotingAuthentification ):Void  
	{
		var o:Object = (authentification == null) ? null : authentification.toObject() ;
		addHeader( RemotingConnection.CREDENTIALS , false, o);
	}

	/**
	 * Start the debug mode of this connection.
	 */
	public function startDebug():Void 
	{
		var oDebug:Object = {
			amf:false, 
			error:true,
			trace:true,
			coldfusion:false, 
			m_debug:true,
			httpheaders:false, 
			amfheaders:false, 
			recordset:true
		};
		addHeader( RemotingConnection.AMF_SERVER_DEBUG, true, oDebug) ;
	}

	/**
	 * Stop the debug mode of this connection.
	 */
	public function stopDebug():Void 
	{
		addHeader( RemotingConnection.AMF_SERVER_DEBUG, true, undefined) ;
	}
	
}