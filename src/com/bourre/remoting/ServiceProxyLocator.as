/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.data.collections.Map;
import com.bourre.remoting.AbstractServiceProxy;
import com.bourre.remoting.RemotingConnection;
import com.bourre.remoting.RemotingDebug;
import com.bourre.remoting.ServiceProxy;

class com.bourre.remoting.ServiceProxyLocator 
{
	public var gatewayURL : String;
	private var _m : Map;
	
	private function ServiceProxyLocator()
	{
		_m = new Map();
	}
	
	public function setCredentials( sUserID : String, sPassword : String, sURL : String ) : Void
	{
		RemotingConnection.getRemotingConnection( gatewayURL ).setCredentials( sUserID, sPassword );
	}
	
	public function push( sServiceName : String, service : AbstractServiceProxy ) : Void
	{
		if (!gatewayURL) 
		{
			RemotingDebug.ERROR("**Error** GatewayURL is undefined in " + this );
			return;
			
		} else if ( _m.containsKey( sServiceName ) )
		{
			RemotingDebug.ERROR( "A service instance is already registered with '" + sServiceName + "' name." );
			return;
			
		} else
		{
			if (service)
			{
				if (service.getURL() == undefined) service.setURL(gatewayURL);
				_m.put( sServiceName, service );
				
			} else
			{
				_m.put( sServiceName, new ServiceProxy( gatewayURL, sServiceName) );
			}
		}
	}
	
	public function getService( sName : String  ) : ServiceProxy
	{
		if (!_m.containsKey( sName ) ) 
		{
			RemotingDebug.ERROR( "Can't find Service instance with '" + sName + "' name." );
		}
		return _m.get( sName );
	}
}