import flash.external.ExternalInterface;
import mx.events.EventDispatcher;
// Start
class com.hermesz.econtent.EFI_Wrapper extends EventDispatcher
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static var className:String = "EFI_Wrapper";
	public static var classPackage:String = "com.hermesz.econtent";
	public static var version:String = "1.0.0";
	public static var author:String = "András Csizmadia";

	public static var showCursor:Boolean = true;
	public static var interfaceVersion:Number = 100;
	/**
	 * <p>Description: Constructor</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function EFI_Wrapper ()
	{
		EventDispatcher.initialize (this);
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function initEFI ():Boolean
	{
		trace ("[EFI_Wrapper] initEFI");

		if (ExternalInterface.available)
		{
			ExternalInterface.call ("EFI_Initialize",interfaceVersion,showCursor);
			return true;
		}
		return false;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */

	public static function switchToBrowserEFI (startupURI:String, timeOut:Number, showAddressBar:Boolean):Boolean
	{
		trace ("[EFI_Wrapper] switchToBrowserEFI");

		if (ExternalInterface.available)
		{
			ExternalInterface.call ("EFI_Browser_SwitchToBrowser",startupURI,timeOut,showAddressBar);
			return true;
		}
		return false;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function createEFI (url:String, x:Number, y:Number, w:Number, h:Number):Boolean
	{
		trace ("[EFI_Wrapper] createEFI: " + arguments);
		if (ExternalInterface.available && url)
		{
			ExternalInterface.call ("EFI_Browser_Create",url,x,y,w,h);
			return true;
		}
		return false;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function navigateEFI (url:String):Boolean
	{
		trace ("[EFI_Wrapper] navigateEFI: " + url);
		if (ExternalInterface.available && url)
		{
			ExternalInterface.call ("EFI_Browser_Navigate",url);
			return true;
		}
		return false;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function closeEFI ():Boolean
	{
		trace ("[EFI_Wrapper] closeEFI");
		if (ExternalInterface.available)
		{
			ExternalInterface.call ("EFI_Browser_Close");
			return true;
		}
		return false;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function reloadEFI ():Boolean
	{
		trace ("[EFI_Wrapper] reloadEFI");
		if (ExternalInterface.available)
		{
			ExternalInterface.call ("EFI_Browser_ReloadPage");
			return true;
		}
		return false;
	}

	

	// END CLASS
}