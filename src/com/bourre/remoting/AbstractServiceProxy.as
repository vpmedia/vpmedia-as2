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
 
import com.bourre.events.EventBroadcaster;
import com.bourre.log.PixlibStringifier;
import com.bourre.remoting.BasicFaultEvent;
import com.bourre.remoting.BasicResultEvent;
import com.bourre.remoting.IServiceProxyListener;
import com.bourre.remoting.RemotingConnection;
import com.bourre.remoting.ServiceMethod;
import com.bourre.remoting.ServiceResponder;
import com.bourre.utils.ClassUtils;

class com.bourre.remoting.AbstractServiceProxy 
{
	private var _oEB : EventBroadcaster;
	private var _sURL : String;
	private var _sServiceName : String;
	
	public function AbstractServiceProxy( sURL : String, serviceName:String ) 
	{
		_oEB = new EventBroadcaster( this );
		setURL( sURL );
		_sServiceName = serviceName ? serviceName : ClassUtils.getFullyQualifiedClassName( this );
	}
	
	public function setURL( url : String ) : Void
	{
		_sURL = url;
	}
	
	public function getURL() : String
	{
		return _sURL;
	}
	
	public function getRemotingConnection() : RemotingConnection
	{
		return RemotingConnection.getRemotingConnection( _sURL );
	}
	
	public function setCredentials( sUserID : String, sPassword : String ) : Void
	{
		getRemotingConnection().setCredentials( sUserID, sPassword );
	}
	
	/*
	 * event system
	 */
	public function addListener( oL : IServiceProxyListener ) : Void
	{
		_oEB.addListener(oL);
	}
	
	public function removeListener( oL:IServiceProxyListener ) : Void
	{
		_oEB.removeListener(oL);
	}
	
	public function addEventListener( e:ServiceMethod, oL, f:Function ) : Void
	{
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	public function removeEventListener( e:ServiceMethod, oL ) : Void
	{
		_oEB.removeEventListener(e, oL);
	}
	
	/*
	 * ServiceResponder callbacks
	 */
	public function onResult( e : BasicResultEvent ) : Void
	{
		e.redirectType();
		_oEB.broadcastEvent( e );
	}
	
	public function onFault( e : BasicFaultEvent ) : Void
	{
		_oEB.broadcastEvent( e );
	}
	
	/*
	 * abstract calls
	 */
	public function callServiceMethod( oServiceMethodName : ServiceMethod, responder : ServiceResponder ) : Void
	{
		arguments.splice(0, 2);
		var o : ServiceResponder = responder? responder : getServiceResponder();
		o.setServiceMethodName( oServiceMethodName );
		
		var a : Array = [_sServiceName + "." + oServiceMethodName, o ].concat(arguments);
		
		var connection : RemotingConnection = getRemotingConnection();
		connection.call.apply( connection, a );
	}
	
	public function callServiceWithResponderOnly( oServiceMethodName : ServiceMethod, o : ServiceResponder ) : Void
	{
		arguments.splice(0, 2);
		var a : Array = [_sServiceName + "." + oServiceMethodName, o ].concat(arguments);
		
		var connection : RemotingConnection = getRemotingConnection();
		connection.call.apply( connection, a );
	}
	
	public function getServiceResponder( fResult : Function, fFault : Function) : ServiceResponder
	{
		return new ServiceResponder( this, fResult, fFault );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}