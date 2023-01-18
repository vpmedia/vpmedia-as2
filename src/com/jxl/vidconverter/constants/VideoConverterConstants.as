/*
	VideoConverterConstants
    
	Constants mainly used for Flashcom related tasks with regards to namespaces.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

class com.jxl.vidconverter.constants.VideoConverterConstants
{
	public static function get className():String
	{
		return "VideoConverter";
	}
	
	public static function get defaultInstanceName():String
	{
		return "_DEFAULT_";
	}
	
	public static function getNameSpace():String
	{
		return className + "." + defaultInstanceName + ".";
	}
	
	public static var FFMPEG_EXE:String = "ffmpeg.exe";
}