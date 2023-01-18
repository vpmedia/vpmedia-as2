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
import com.bourre.log.LogEvent;
import com.bourre.log.LogLevel;
import com.bourre.log.LogListener;
import com.bourre.log.PixlibStringifier;

class com.bourre.utils.NetDebuggerTracer 
	implements LogListener
{
	private static var _oI : NetDebuggerTracer;
		public static var TYPE_ADDHEADER:String = "AddHeader";	public static var TYPE_CALL:String = "Call";	public static var TYPE_CLOSE:String = "Close";	public static var TYPE_CONNECT:String = "Connect";
	public static var TYPE_DEBUGEVENT:String = "DebugEvent";	public static var TYPE_ERROR:String = "Error";
	public static var TYPE_NETSERVICESTRACE:String = "NetServicesTrace";	public static var TYPE_RECEIVECALL:String = "ReceivedCall";	public static var TYPE_RESULT:String = "Result";	public static var TYPE_STATUS:String = "Status";
	public static var TYPE_TRACE:String = "Trace";
	
	public static var SOURCE_CLIENT:String = "Client";	public static var SOURCE_NCD:String = "NCD";	public static var SOURCE_FMS:String = "Flash Communication Server";
	
	public static var PROTOCOL_NONE = "none";
	public static var PROTOCOL_HTTP = "http";
	public static var PROTOCOL_RTMP = "rtmp";
	
	public static var CONNECTION_CONTROLLER : String = "_NetDebugLocalToController";	public static var CONNECTION_MOVIE : String = "_NetDebugLocalToDebugMovie";
		public static var METHOD_ONDATA : String = "onData";	public static var METHOD_ONCOMMAND : String = "onCommand";

	private var _lc : LocalConnection;
	private var _oDebug : Object;
	private var _m:Map;
	
	/**
	 * @return singleton instance of NetDebuggerTracer
	 */
	public static function getInstance() : NetDebuggerTracer 
	{
		if (!_oI) _oI = new NetDebuggerTracer();
		return _oI;
	}
	
	private function NetDebuggerTracer()
	{
		_lc = new LocalConnection();
		_m = new Map();
		_init();
	}
	
	private function _init() : Void
	{
		_m.put( LogLevel.DEBUG, NetDebuggerTracer.TYPE_DEBUGEVENT);		_m.put( LogLevel.INFO, NetDebuggerTracer.TYPE_TRACE);		_m.put( LogLevel.WARN, NetDebuggerTracer.TYPE_STATUS);		_m.put( LogLevel.ERROR, NetDebuggerTracer.TYPE_ERROR);		_m.put( LogLevel.ERROR, NetDebuggerTracer.TYPE_ERROR);
		
		_oDebug = new Object();
		_oDebug.source = NetDebuggerTracer.SOURCE_CLIENT;
		_oDebug.movieUrl = unescape(_root._url);
		_oDebug.protocol = NetDebuggerTracer.PROTOCOL_NONE;
		_oDebug.debugId = 0;
		
	}
	
	public function _getDebugEvent( e : LogEvent ) : Object
	{
		var now:Date = new Date();
		_oDebug.date = now;
		_oDebug.time = now.getTime();
		_oDebug.eventType = _m.get( e.level );
		_oDebug.trace = e.content.toString();
		return _oDebug;
	}
	
	public function onLog( e : LogEvent ) : Void 
	{
		_lc.send( 	NetDebuggerTracer.CONNECTION_CONTROLLER, 
					NetDebuggerTracer.METHOD_ONDATA, 
					_getDebugEvent( e ) );
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