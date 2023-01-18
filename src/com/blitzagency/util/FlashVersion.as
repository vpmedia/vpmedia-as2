class com.blitzagency.util.FlashVersion {
// Constants:
	public static var CLASS_REF = com.blitzagency.util.FlashVersion;
	public static var version:String = System.capabilities.version;
// Public Properties:
	public static var __majorVersion:Number;
	public static var __minorVersion:Number;
// Private Properties:

// Initialization:

// Public Methods:
	public static function get majorVersion():Number
	{
		return version.split(",")[0].split(" ")[1];
	}
	
	public static function get minorVersion():String
	{
		var list:Array = version.split(",");
		list[0] = majorVersion;
		var temp:String = list.join(",");
		return temp;
	}
	
	public static function get OS():String
	{
		return version.split(",")[0].split(" ")[0];
	}
// Semi-Private Methods:
// Private Methods:

}