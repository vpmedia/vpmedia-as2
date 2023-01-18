import mx.utils.Delegate
import it.gotoandplay.smartfoxserver.http.*

/**
 * HttpConnection class.
 * 
 * @version	1.0.0
 * 
 * @author	The gotoAndPlay() Team
 * 			{@link http://www.smartfoxserver.com}
 * 			{@link http://www.gotoandplay.it}
 * 
 * @exclude
 */
class it.gotoandplay.smartfoxserver.http.HttpConnection
{
	private static var HANDSHAKE:String = "connect"
	private static var DISCONNECT:String  = "disconnect"
	private static var CONN_LOST:String = "ERR#01"
	
	public static var HANDSHAKE_TOKEN:String = "#"
	
	private static var servletUrl:String = "BlueBox/HttpBox.do"
	private static var paramName:String = "sfsHttp"
	
	public static var onHttpData:String = "onHttpData"
	public static var onHttpError:String = "onHttpError"
	public static var onHttpConnect:String = "onHttpConnect"
	public static var onHttpClose:String = "onHttpClose"
	
	private var sessionId:String
	private var connected:Boolean = false
	private var ipAddr:String
	private var port:Number
	private var webUrl:String
	private var handlers:Array
	private var loaderFactory:LoaderFactory

	private var codec:IHttpProtocolCodec

	function HttpConnection(httpConnectHandler:Function, httpCloseHandler:Function, httpDataHandler:Function, httpErrorHandler:Function)
	{
		codec = new RawProtocolCodec()
		
		handlers = []
		handlers[onHttpConnect] = httpConnectHandler
		handlers[onHttpClose] = httpCloseHandler
		handlers[onHttpData] = httpDataHandler
		handlers[onHttpError] = httpErrorHandler
	}
	
	public function getSessionId():String
	{
		return this.sessionId
	}
	
	public function isConnected():Boolean
	{
		return this.connected
	}
	
	public function connect(addr:String, port:Number):Void
	{
		// Set default port
		if (port == undefined)
			port = 8080
			
		this.ipAddr = addr
		this.port = port
		this.webUrl = "http://" + this.ipAddr + ":" + this.port + "/" + servletUrl
		this.sessionId = null
		
		// Instantiate loaderFactory
		loaderFactory = new LoaderFactory(this, handleResponse, webUrl, paramName)
		
		// Send handshake
		send( HANDSHAKE )	
	}
	
	public function close():Void
	{
		send( DISCONNECT )
	}
	
	public function send(message:String):Void
	{
		if (connected || (!connected && message == HANDSHAKE) || (!connected && message == "poll"))
		{
			if (message != "poll")
				trace("[ Send ]: " + codec.encode(this.sessionId, message))
			
			loaderFactory.sendAndLoad(codec.encode(this.sessionId, message))
		}
	}
	
	private function handleResponse(data:String):Void
	{
		var classRef = this["_classRef"]

		if (data != undefined)
		{
			var params:Object = {}

			// handle handshake
			if (data.charAt(0) == HttpConnection.HANDSHAKE_TOKEN)
			{
				// Init the sessionId
				if (classRef.sessionId == null)
				{
					classRef.sessionId = classRef.codec.decode(data)
					classRef.connected = true
				
					params.sessionId = classRef.sessionId
					params.success = true
					
					classRef.dispatchEvent(HttpConnection.onHttpConnect, params)
				}
				else
				{
					// Error, session already exist and cannot be redefined!
					trace("**ERROR** SessionId is being rewritten")
				}
			}
		
			// handle data
			else
			{
				// fire disconnection
				if (data.indexOf(HttpConnection.CONN_LOST) == 0)
				{
					params.data = {}
					classRef.dispatchEvent(HttpConnection.onHttpClose, params)
				}
			
				// fire onHttpData
				else
				{
					params.data = data
					classRef.dispatchEvent(HttpConnection.onHttpData, params)
				}
			}
		}
		
		else
		{
			// If not already connected -> BlueBox connection failure.
			if (!classRef.connected)
				classRef.handleIOError("I/O error: null response from server")
		}
		
	}
	
	private function handleIOError(error:String):Void
	{
		var params:Object = {}
		params.message = error
		
		dispatchEvent(onHttpError, params)
	}
	
	private function dispatchEvent(type:String, params:Object):Void
	{
		handlers[type](params)
	}
}