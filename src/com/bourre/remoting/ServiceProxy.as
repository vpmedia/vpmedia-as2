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
 
import com.bourre.log.PixlibStringifier;
import com.bourre.remoting.AbstractServiceProxy;
import com.bourre.remoting.RemotingConnection;
import com.bourre.remoting.ServiceResponder;

dynamic class com.bourre.remoting.ServiceProxy 
	extends AbstractServiceProxy
{
	public var __KEY : Number = null;	public var __fullyQualifiedClassName : String = null;
	
	public function ServiceProxy ( sURL : String, serviceName:String )
	{
		super( sURL, serviceName );
	}
	
	public function __resolve( sServiceMethodName : String, o : ServiceResponder ) : Function 
	{
		var connection : RemotingConnection = getRemotingConnection();
		var aFullServiceName = [_sServiceName + "." + sServiceMethodName];
		return function (){ return connection.call.apply( connection, aFullServiceName.concat(arguments) ); };
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