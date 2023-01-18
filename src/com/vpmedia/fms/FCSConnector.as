class com.vpmedia.fms.FCSConnector extends NetConnection
{
	//EventDispatcher needs these
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	// Internal data
	var handleClose:Boolean = true;
	//
	var ncs = new Array (8);
	var count = 0;
	var timer = null;
	function FCSConnector ()
	{
		super ();
		mx.events.EventDispatcher.initialize (this);
	}
	function connectionClosed (type, info)
	{
		if (handleClose)
		{
			dispatchEvent ({target:this, type:type, info:info});
		}
		handleClose = false;
	}
	function onStatus (info)
	{
		var code = info.code.substring (info.code.indexOf (".") + 1);
		switch (code)
		{
		case "Connect.Success" :
			dispatchEvent ({target:this, type:"onConnect", info:info});
			break;
		case "Connect.Rejected" :
			connectionClosed ("onReject", info);
			break;
		case "Connect.Closed" :
			connectionClosed ("onClose", info);
			break;
		case "Connect.Failed" :
			connectionClosed ("onFail", info);
			break;
		case "Connect.AppShutdown" :
			connectionClosed ("onClose", info);
			break;
		case "Connect.InvalidApp" :
			connectionClosed ("onReject", info);
			break;
		case "Call.Failed" :
			dispatchEvent ({target:this, type:"onCall", info:info});
			break;
		}
	}
	function connect ()
	{
		handleClose = true;
		return super.connect.apply (super, arguments);
	}
	function close ()
	{
		handleClose = false;
		super.close ();
	}
}
