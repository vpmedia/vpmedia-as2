class janumedia.fms.FMSconnector extends NetConnection {
	// EventDispatcher needs these
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	// Internal data
	var handleClose:Boolean = true;
	function FMSconnector() {
		super();
		mx.events.EventDispatcher.initialize(this);
	}
	public function connect() {
		_global.tt("[FMSconnector] connect");
		handleClose = true;
		return super.connect.apply(super, arguments);
	}
	function connectionClosed(type, info) {
		_global.tt("[FMSconnector] connectionClosed", info);
		if (handleClose) {
			dispatchEvent({target:this, type:type, info:info});
		}
		handleClose = false;
	}
	function FMSuserID(id:Number) {
		_global.tt("[FMSconnector] FMSuserID", id);
		dispatchEvent({target:this, type:"onFMSuserID", id:id});
	}
	function WEBuserINFO(data:Object) {
		_global.tt("[FMSconnector] WEBuserINFO");
		dispatchEvent({target:this, type:"onWEBuserINFO", data:data});
	}
	private function onStatus(info) {
		_global.tt("[FMSconnector] onStatus", info.code);
		switch (info.code) {
		case "NetConnection.Connect.Success" :
			dispatchEvent({target:this, type:"onConnect", info:info});
			break;
		case "NetConnection.Connect.Closed" :
			connectionClosed("onClose", info);
			break;
		case "NetConnection.Connect.Rejected" :
			connectionClosed("onReject", info);
			break;
		case "NetConnection.Connect.Failed" :
			connectionClosed("onFail", info);
			break;
		}
	}
}
