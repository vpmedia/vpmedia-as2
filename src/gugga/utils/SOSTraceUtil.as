import gugga.collections.HashTable;
/**
 * @author Todor Kolev
 */
class gugga.utils.SOSTraceUtil 
{
	private static var mSOSTraceSocket : XMLSocket;
	private static var mSOSCommandSocket : XMLSocket;
	
	private static var mSocketsInitialized : Boolean = false;
	private static var mKeyColors : HashTable;
	
	
	private static function initializeSockets()
	{
		if(!mSocketsInitialized)
		{
			mSOSTraceSocket = new XMLSocket();
			mSOSTraceSocket.connect("localhost", 4444);
			
			mSOSCommandSocket = new XMLSocket();
			mSOSCommandSocket.connect("localhost", 4445);
			
			mSocketsInitialized = true;
		}
	}
	
	public static function traceMessageWithKey(aMessage : String, aKeyName : String) : Void
	{
		initializeSockets();
		mSOSCommandSocket.send("<showMessage key='" + aKeyName + "'><![CDATA[" + aMessage + "]]></showMessage>");
	}
	
	public static function trace(aMessage : String) : Void
	{
		initializeSockets();
		mSOSCommandSocket.send("<showMessage><![CDATA[" + aMessage + "]]></showMessage>");
	}
	
	public static function traceFoldedMessage(aTitle : String, aMessage : String) : Void
	{
		initializeSockets();
		
		mSOSCommandSocket.send(
			"<showFoldMessage>" +
			"	<title><![CDATA[" + aTitle + "]]></title>" +
			"	<message><![CDATA[" + aMessage + "]]></message>" +
			"</showFoldMessage>" 
		);
	}

	public static function traceFoldedMessageWithKey(aTitle : String, aMessage : String, aKeyName : String) : Void
	{
		initializeSockets();
		
		mSOSCommandSocket.send(
			"<showFoldMessage key='" + aKeyName + "'>" +
			"	<title><![CDATA[" + aTitle + "]]></title>" +
			"	<message><![CDATA[" + aMessage + "]]></message>" +
			"</showFoldMessage>" 
		);
	}
		
	public static function setKeyColor(aKeyName : String, aColor:Number) : Void
	{
		mKeyColors[aKeyName] = aColor;
		
		mSOSCommandSocket.send(
			"<setKey>" +
			"	<name>" + aKeyName + "</name>" +
			"	<color>" + aColor + "</color>" +
			"</setKey>\n"
		);
	}
	
	public static function isKeyColorSet(aKeyName : String) : Boolean
	{
		return mKeyColors.containsKey(aKeyName);
	}

	public static function getKeyColor(aKeyName : String) : Number
	{
		return mKeyColors[aKeyName];
	}
}