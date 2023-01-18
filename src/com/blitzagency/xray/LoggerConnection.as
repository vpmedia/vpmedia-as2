/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import mx.events.EventDispatcher;
import com.blitzagency.util.Delegate
import com.blitzagency.xray.XrayTrace;
/**
 * LoggerConnection extends LocalConnection and is responsible for logging communication with the
 * interface.  Since the amount of data transferred by the logger is much greater than the ControlConnection
 * data, I needed to make 2 connections to split up the amount transferred.
 *
 * @author John Grden :: John@blitzagency.com
 */
class com.blitzagency.xray.LoggerConnection extends LocalConnection
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	/**
     * @summary boolean value indicating if the connection was made successfully
	 */
	public var isConnected:Boolean;
	/**
     * @summary trace object for handling trace output back to the interface
	 */
	private var xrayTrace:XrayTrace;

	function LoggerConnection()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);
	}
	/**
     * @summary setViewInfo is reponsible for sending all trace information back to the interface.  it's
	 * called from the event dispatch of XrayTrace
	 *
	 * @param obj:Object info = the actual data, last:Boolean of whether or not it's the last packet to be sent
	 *
	 * @return nothing
	 */
	public function setViewInfo(obj:Object):Void
	{
		var bSent:Boolean = this.send("_xray_view_conn", "setViewInfo", obj.info, obj.last);
	}
	/**
     * @summary a request from the interface.  This is when someone types in a trace command in the trace panel
	 * of the interface.
	 *
	 * @param traceValue:String Command to be traced
	 *
	 * @return
	 */
	public function getTraceValue(traceValue:String):Void
	{
		// The XrayTrace class will take care of dispatching the event and sending the response
		var sInfo:String = this.xrayTrace.trace("getTraceValue",eval(traceValue));
	}
	public function allowDomain(sendingDomain:String):Boolean
	{
	  return true;
	}

	public function onStatus(infoObject:Object):Void
	{
		switch (infoObject.level)
		{
		case 'status' :
		  break;
		case 'error' :
			//this.trace("LocalConnection encountered an error.");
			break;
		}
	}

	/**
     * @summary makes the connection to listen on
	 *
	 * @return Boolean.  true if there's no other Fhash app using the LC name.
	 */
	public function initConnection():Boolean
	{
		// setup connection with the AdminToolTrace object
		this.xrayTrace = XrayTrace.getInstance();
		this.xrayTrace.addEventListener("onSendData", Delegate.create(this, this.setViewInfo));
		//this.xrayTrace.addEventListener("onSendData", this);

		this.isConnected = this.connect("_xray_view_remote_conn");
		return this.isConnected;
	}
}