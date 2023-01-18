class ascb.flashcom.Log {

  private static var _oInstances:Object;

  private var _ncServer:NetConnection;
  private var _nsLog:NetStream;
  private var _sLogName:String;

  private function Log(sURI:String, sLogName:String) {
    _ncServer = new NetConnection();
_ncServer.onStatus = function(oInformation:Object):Void {
  trace(oInformation.code);
};
    _ncServer.connect(sURI);
    _nsLog = new NetStream(_ncServer);
_nsLog.onStatus = function(oInformation:Object):Void {
  trace(oInformation.code);
};

    _nsLog.publish(sLogName, "append");
    _sLogName = sLogName;
_nsLog.send("logEvent", "starting log: " + (new Date()));
  }

  public static function getInstance(sURI:String, sLogName:String):Log {
    if(sLogName == undefined) {
      sLogName = "default";
    }
    if(_oInstances == undefined) {
      _oInstances = new Object();
    }
    if(_oInstances[sURI + "_" + sLogName] == undefined) {
      _oInstances[sURI + "_" + sLogName] = new Log(sURI, sLogName);
    }
    return _oInstances[sURI + "_" + sLogName];
  }

  public function write(oLogData:Object):Void {
trace(_nsLog);
trace(_nsLog.send);
trace(oLogData);
    _nsLog.send("logEvent", oLogData);
  }

  public function read():Void {
    var nsRead:Object = new NetStream(_ncServer);
    nsRead.onStatus = function(oInformation:Object):Void {
      trace(oInformation.code);
    };
    nsRead.logEvent = ascb.util.Proxy.create(this, logEvent);
    nsRead.play(_sLogName, -2, -1, 3);
  }

  private function logEvent():Void {
    trace(arguments);
  }


}