/**
* @see com.vpmedia.Javascript
*/
class com.vpmedia.javascript.Javascript {
	/**
	* Executes the specified script.
	*/
	public static function execute (script:String):Void {
		getURL ("javascript:" + script + "void(0);");
	}
	/**
	* Alerts the user with the specified message.
	*/
	public static function alert (message:String):Void {
		execute ("alert('" + message + "');");
	}
	/**
	* Closes the current window.
	*/
	public static function closeWindow ():Void {
		execute ("window.close();");
	}
	/**
	* Bookmarks the specified page. Internet Explorer specific.
	*/
	public static function bookmark (link:String, title:String):Void {
		execute ("window.external.AddFavorite('" + link + "','" + title + "');");
	}
	/**
	* Moves the current window. Either to or by.
	*/
	public static function moveWindow (width:Number, height:Number, method:Boolean) {
		var script:String;
		if (method)
		{
			script = "window.moveBy(Number(" + width + "),Number(" + height + "));";
		}
		else
		{
			script = "window.moveTo(Number(" + width + "),Number(" + height + "));";
		}
		execute (script);
	}
	/**
	* Resizes the current window. Either to or by.
	*/
	public static function resizeWindow (width:Number, height:Number, method:Boolean):Void {
		var script:String;
		if (method)
		{
			script = "window.resizeBy(Number(" + width + "),Number(" + height + "));";
		}
		else
		{
			script = "window.resizeTo(Number(" + width + "),Number(" + height + "));";
		}
		execute (script);
	}
	/**
	* Shakes the current window.
	*/
	public static function shakeWindow (amount:Number):Void {
		var script:String = "for(i=10;i>0;i--){for(j=Number(" + amount + ");j>0;j--){parent.";
		script += "moveBy(0,i);parent.moveBy(i,0);parent.moveBy(0,-i);parent.moveBy(-i,0);}}";
		execute (script);
	}
	/**
	* Opens a new popup window with specified arguments.
	*/
	public static function openPopup (link:String, width:Number, height:Number, args:String) {
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
	public static function changeBackgroundColor (bgcolor:String):Void {
		execute ("document.bgColor='" + bgcolor + "';");
	}
	/**
	* Sets the status message. Note that special characters may cause an error.
	*/
	public static function setStatusMessage (message:String):Void {
		execute ("window.status='" + message + "';");
	}
}
