/**
 * @author oolanoo
 */
class com.tPS.utils.ObjectUtil {
	public static var MOVIECLIP:String = "movieclip";
	public static var XML:String = "xml";
	public static var XMLNode:String = "xmlnode";
	public static var LOADVARS:String = "loadvars";
	public static var SOUND:String = "sound";
	public static var VIDEO:String = "video";
	public static var NETSTREAM:String = "netstream";
	public static var OBJECT:String = "object";
	public static var STRING:String = "string";

	public static function getType (obj:Object) : String {
		if(typeof obj ==MOVIECLIP) return ObjectUtil.MOVIECLIP;
		if(typeof obj =="string") return ObjectUtil.STRING;
		if(obj instanceof XML) return ObjectUtil.XML;
		if(obj instanceof XMLNode) return ObjectUtil.XMLNode;
		if(obj instanceof LoadVars) return ObjectUtil.LOADVARS;
		if(obj instanceof Sound) return ObjectUtil.SOUND;
		if(obj instanceof Video) return ObjectUtil.VIDEO;
		if(obj instanceof NetStream) return ObjectUtil.NETSTREAM;
		return ObjectUtil.OBJECT;
	}
}