class jxl.flashcom.core.Responder
{
	
	private var resultHandler:String;
	private var resultObject:Object;
	private var statusHandler:String;
	private var statusObject:Object;
	
	function Responder()
	{
	}
	
	public function setResultHandler(s:String, o:Object):Void
	{
		resultHandler = s;
		resultObject = o;
	}
	
	public function setStatusHandler(s:String, o:Object):Void
	{
		statusHandler = s;
		statusObject = o;
	}
	
	private function onResult(o:Object):Void
	{
		resultObject[resultHandler](o);
	}
	
	private function onStatus(o:Object):Void
	{
		statusObject[statusHandler](o);
	}
	
}