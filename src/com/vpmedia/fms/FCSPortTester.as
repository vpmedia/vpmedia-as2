//TODO: setTestConfig( {proto:"rtmp",port:1935}, {proto:"rtmpt",port:1935} )
import com.vpmedia.events.Delegate;
import com.vpmedia.events.DoLater;
class com.vpmedia.fms.FCSPortTester
{
	public var Host:String;
	public var Application:String;
	public var Timeout:Number = 15000;
	//msec
	public var Port:String = "";
	public var Proto:String = "";
	public var ConnectionString:String = "";
	public var CanConnect:Boolean = false;
	private var _refConnectionID:Number = -1;
	private var _netConnection:NetConnection;
	private var _acceptOnStatus:Boolean = false;
	private var _ncs:Array;
	private var _counter:Number = 0;
	//constructor
	public function FCSPortTester (_host, _application)
	{
		this.Host = _host;
		this.Application = _application;
	}
	/** PUBLIC EVENT onStatusChange( {level:"",code:""} ):
	 	level: error
	 	 code: "Init.HostError"
	   "Test.Failed"
	   "Test.Timeout"				
	   
	level: status
	 code: "Test.Start"
	 code: "Test.Success"
	 code: "Test.Remain"
	*/
	public function onStatusChange (infoObject:Object)
	{
		//infoObject = {level:"",code:""}
	}
	public function runTest ():Void
	{
		if (this._init () == false)
		{
			return;
		}
		this.onStatusChange ({level:"status", code:"Test.Start"});
		_global.__fcsPortTesterTimer = setInterval (Delegate.create (this, _ncStatusChange), this.Timeout, {level:"error", code:"NetConnection.Connect.Timeout"});
		this._connect ();
	}
	public function terminateTest()
	{
		clearInterval (_global.__fcsPortTesterTimer);
		_global.__fcsPortTesterTimer = null;
		_global.__fcsPortTestGhost = setInterval (onCloseNC, 1000);
		this.onStatusChange ({level:"error", code:"Test.Terminated"});
		this._acceptOnStatus = false;
	}
	//PRIVATE FUNCTIONS
	private function _connect ():Void
	{
		this._refConnectionID++;
		var i:Number = this._refConnectionID;
		this.onStatusChange ({level:"status", code:"Test.Remain", message:String (this._ncs.length - i)});
		this._netConnection = new NetConnection ();
		this._netConnection.onStatus = Delegate.create (this, _ncStatusChange);
		this._netConnection.timeout = 10;
		this._netConnection.connect (this._ncs[i].url);
	}
	private function onCloseNC(){
		this._netConnection.close ();
		clearInterval (_global.__fcsPortTesterGhost);
		_global.__fcsPortTesterGhost = null;
	}
	private function _ncStatusChange (infoObject:Object):Void
	{
		if (this._acceptOnStatus == false)
		{
			return;
		}
		var _triggerEnd:Boolean = false;
		if (infoObject.code == "NetConnection.Connect.Success")
		{
			this.CanConnect = true;
			_triggerEnd = true;
		}
		else if (infoObject.code == "NetConnection.Connect.Failed")
		{
			this._counter++;
		}
		else if (infoObject.code == "NetConnection.Connect.Timeout")
		{
			//DEBUG:
			//trace("Timeout");
			this.CanConnect = false;
			_triggerEnd = true;
		}
		//trigger end if all ports tested 
		if (this._counter >= this._ncs.length)
		{
			_triggerEnd = true;
		}
		if (_triggerEnd == false)
		{
			this._connect ();
		}
		if (_triggerEnd)
		{
			this._acceptOnStatus = false;
			clearInterval (_global.__fcsPortTesterTimer);
			_global.__fcsPortTesterTimer = null;
			_global.__fcsPortTestGhost = setInterval (Delegate.create (this, this.onCloseNC), 1000);
			//DEBUG:
			//trace("This is the END")
			//canConnect
			if (this.CanConnect)
			{
				this.Port = this._ncs[this._refConnectionID].port;
				this.Proto = this._ncs[this._refConnectionID].proto;
				this.ConnectionString = this._ncs[this._refConnectionID].url;
				this.onStatusChange ({level:"status", code:"Test.Success"});
			}
			else
			{
				this.Port = "";
				this.Proto = "";
				this.ConnectionString = "";
				this.onStatusChange ({level:"error", code:"Test.Failed"});
			}
			//can't connect on any port 
		}
	}
	private function _init ():Boolean
	{
		this.CanConnect = false;
		this.Port = "";
		this.Proto = "";
		this.ConnectionString = "";
		this._acceptOnStatus = true;
		this._refConnectionID = -1;
		this._counter = 0;
		var _hostname:String;
		if (this.Host.length != 0)
		{
			_hostname = "//" + this.Host;
		}
		else
		{
			this.onStatusChange ({level:"error", code:"Init.HostError"});
			return false;
		}
		//possible ports = [1935, 80, 443, 8080, 7070];
		this._ncs = new Array ();
		for (var i:Number = 0; i < 9; i++)
		{
			this._ncs[i] = new Object ();
		}
		var i:Number = -1;
		/*
		i++;
		this._ncs[i].url = "rtmp:" + _hostname + "/" + this.Application;
		this._ncs[i].port = "default";
		this._ncs[i].proto = "rtmp";
		*/
		i++;
		this._ncs[i].url = "rtmp:" + _hostname + ":11935/" + this.Application;
		this._ncs[i].port = "1935";
		this._ncs[i].proto = "rtmp";
		i++;
		this._ncs[i].url = "rtmp:" + _hostname + ":80/" + this.Application;
		this._ncs[i].port = "80";
		this._ncs[i].proto = "rtmp";
		i++;
		this._ncs[i].url = "rtmp:" + _hostname + ":443/" + this.Application;
		this._ncs[i].port = "443";
		this._ncs[i].proto = "rtmp";
		/*
		i++;
		this._ncs[i].url = "rtmpt:" + _hostname + "/" + this.Application;
		this._ncs[i].port = "default";
		this._ncs[i].proto = "rtmpt";
		*/
		i++;
		this._ncs[i].url = "rtmpt:" + _hostname + ":1935/" + this.Application;
		this._ncs[i].port = "1935";
		this._ncs[i].proto = "rtmpt";
		i++;
		this._ncs[i].url = "rtmpt:" + _hostname + ":80/" + this.Application;
		this._ncs[i].port = "80";
		this._ncs[i].proto = "rtmpt";
		i++;
		this._ncs[i].url = "rtmpt:" + _hostname + ":443/" + this.Application;
		this._ncs[i].port = "443";
		this._ncs[i].proto = "rtmpt";
		i++;
		//
		this._ncs[i].url = "rtmps:" + _hostname + ":1935/" + this.Application;
		this._ncs[i].port = "1935";
		this._ncs[i].proto = "rtmps";
		i++;
		this._ncs[i].url = "rtmps:" + _hostname + ":80/" + this.Application;
		this._ncs[i].port = "80";
		this._ncs[i].proto = "rtmps";
		i++;
		this._ncs[i].url = "rtmps:" + _hostname + ":443/" + this.Application;
		this._ncs[i].port = "443";
		this._ncs[i].proto = "rtmps";
		return true;
	}
}
