import com.blitzagency.util.FlashVersion;

class com.blitzagency.flash.extensions.mtasc.AssetLocator 
{
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.AssetLocator;
// Public Properties:
// Private Properties:


// Public Methods:
	public static function getFileLocation():Object
	{
		var path:String = MMExecute("fl.browseForFileURL(\"select\", \"Select file\");");

		if(path == "null") return null;
		var obj:Object = new Object();
		obj.URI = path;
		obj.path = cleanPath(path);
		obj.cleanName = getFileName(path);
		return obj;
	}
	
	public static function getFolderLocation():Object
	{
		var path:String = "null";
		if(FlashVersion.majorVersion == 8) path = MMExecute("fl.browseForFolderURL(\"Select folder\");");
		if(FlashVersion.majorVersion == 7 && FlashVersion.OS.toLowerCase().indexOf("win") > - 1) path = MMExecute("FileSystem.browseForFolder(\"Select folder\");");
		if(path == "null") return null;
		var obj:Object = new Object();
		obj.URI = path;
		obj.path = cleanPath(path);
		obj.cleanName = getFileName(path);
		return obj;
	}
	
	public static function cleanPath(p_path:String):String
	{
		//file:///D|/Blitz/Components/MTASC_Panel/DEV_Source/classes/Main.as
		p_path = p_path.split("file:///").join("");
		p_path = p_path.split("|").join(":");
		return unescape(p_path); 
	}
	
	public static function getURI(p_path:String):String
	{
		//file:///D|/Blitz/Components/MTASC_Panel/DEV_Source/classes/Main.as
		p_path = p_path.split(":").join("|");
		p_path = "file:///" + p_path;
		
		return p_path;
	}
	
	private static function getFileName(p_path:String):String
	{
		// they've chosen where the files are located, now use the last folder as the mainFolderName
		var cleanName:String = String(p_path.split("/").pop());
		return cleanName;
	}
// Semi-Private Methods:
// Private Methods:

}