	/**
	* deprecated
	* @see com.vpmedia.javascript.Javascript
	*/
class com.vpmedia.CustomJavascript
{
	public var className:String = "CustomJavascript";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "0.1";
	public var author:String = "András Csizmadia";
	function CustomJavascript()
	{
	}
	/**
	* Executes the specified script.
	*/
	public static function execute (script:String):Void
	{
		getURL ("javascript:" + script + "void(0);");
	}
	/**
	* Alerts the user with the specified message.
	*/
	public static function alert (message:String):Void
	{
		execute ("alert('" + message + "');");
	}
	/**
	* Closes the current window.
	*/
	public static function closeWindow ():Void
	{
		execute ("window.close();");
	}
	/**
	* Bookmarks the specified page. Internet Explorer specific.
	*/
	public static function bookmark (link:String, title:String):Void
	{
		execute ("window.external.AddFavorite('" + link + "','" + title + "');");
	}
	/**
	* Moves the current window. Either to or by.
	*/
	public static function moveWindow (width:Number, height:Number, method:Boolean)
	{
		if (method)
		{
			var script:String = "window.moveBy(Number(" + width + "),Number(" + height + "));";
		}
		else
		{
			var script:String = "window.moveTo(Number(" + width + "),Number(" + height + "));";
		}
		execute (script);
	}
	/**
	* Resizes the current window. Either to or by.
	*/
	public static function resizeWindow (width:Number, height:Number, method:Boolean):Void
	{
		if (method)
		{
			var script:String = "window.resizeBy(Number(" + width + "),Number(" + height + "));";
		}
		else
		{
			var script:String = "window.resizeTo(Number(" + width + "),Number(" + height + "));";
		}
		execute (script);
	}
	/**
	* Shakes the current window.
	*/
	public static function shakeWindow (amount:Number):Void
	{
		var script:String = "for(i=10;i>0;i--){for(j=Number(" + amount + ");j>0;j--){parent.";
		script += "moveBy(0,i);parent.moveBy(i,0);parent.moveBy(0,-i);parent.moveBy(-i,0);}}";
		execute (script);
	}
	/**
	* Opens a new popup window with specified arguments.
	*/
	public static function openPopup (link:String, width:Number, height:Number, args:String)
	{
		var screenWidth:Number = System.capabilities.screenResolutionX;
		var screenHeight:Number = System.capabilities.screenResolutionY;
		if (screenWidth > 2048)
		{
			screenWidth /= 2;
		}
		/* split the width if we have a double display */ 
		args += ",width=" + width + ",height=" + height + ",top=" + (screenHeight / 2 - height / 2) + ",left=" + (screenWidth / 2 - width / 2);
		execute ("function o(u,w,f){window.open(u,w,f);}o('" + link + "','popup','" + args + "');");
	}
	/**
	* Changes the background color of the current page.
	*/
	public static function changeBackgroundColor (bgcolor:String):Void
	{
		execute ("document.bgColor='" + bgcolor + "';");
	}
	/**
	* Sets the status message. Note that special characters may cause an error.
	*/
	public static function setStatusMessage (message:String):Void
	{
		execute ("window.status='" + message + "';");
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
