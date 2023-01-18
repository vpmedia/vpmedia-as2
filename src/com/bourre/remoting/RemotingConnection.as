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
import com.bourre.log.PixlibStringifier;
import com.bourre.remoting.RemotingDebug;

class com.bourre.remoting.RemotingConnection 
	extends NetConnection
{
	private static var _M : Map = new Map();
	
	public function RemotingConnection( sURL : String ) 
	{
		super();
		if (sURL)  connect( sURL );
	}
	
	public function connect( sURL : String ) : Void
	{
		RemotingDebug.DEBUG( this + ".connect('" + sURL + "')" );
		
		super.connect( sURL );
		RemotingConnection._addRemotingConnection( sURL, this );
	}
	
	public function setCredentials( username : String, password : String ):Void  
	{
		addHeader( "Credentials", false, {userid: username, password: password} );
	}
	
	public function runDebug() : Void
	{
		addHeader	("amf_server_debug", true, 
						{	amf:false, 
							error:true,
							trace:true,
							coldfusion:false, 
							m_debug:true,
							httpheaders:false, 
							amfheaders:false, 
							recordset:true/*,
							http:true,
							rtmp:true*/	}
					);
	}
	
	public function stopDebug() : Void
	{
		addHeader("amf_server_debug", true, undefined );
	}
	
	public static function getRemotingConnection( sURL : String ) : RemotingConnection
	{
		if ( !RemotingConnection._M.containsKey( sURL ) ) var o = new RemotingConnection( sURL );
		return RemotingConnection._M.get( sURL );
	}
	
	private static function _addRemotingConnection( sURL : String, o : RemotingConnection ) : Void
	{
		if ( !RemotingConnection._M.containsKey( sURL ) ) RemotingConnection._M.put( sURL, o );
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