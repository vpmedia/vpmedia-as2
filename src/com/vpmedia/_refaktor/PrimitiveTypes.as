/**
 * Utility class for converting simple strings into various primitive types
*/
class com.vpmedia.PrimitiveTypes {
	public static var TYPE_STRING:String = "string";
	public static var TYPE_NUMBER:String = "number";
	public static var TYPE_FLOAT:String = "float";
	public static var TYPE_INT:String = "int";
	public static var TYPE_BOOL:String = "boolean";
	public static var TYPE_COLOR:String = "color";
	private static var BOOL_TRUE:String = "true";
	private static var BOOL_FALSE:String = "false";
	/**
	 * Parses the value string into the specified type
	 */
	public static function convert (value:String, type:String):Object {
		switch (type) {
		case TYPE_COLOR :
			return parseColor (value);
		case TYPE_NUMBER :
		case TYPE_FLOAT :
			return parseFloat (value);
		case TYPE_INT :
			return parseInt (value);
		case TYPE_BOOL :
			if (value == BOOL_TRUE) {
				return true;
			}
			if (value == BOOL_FALSE) {
				return false;
			}
			throw new Error ("Invalid arguments");
		case TYPE_STRING :
			return value;
		default :
			if (type == null) {
				return value;
			}
			throw new Error ("Unknown type: " + type);
		}
	}
	/**
	 * returns a 32bit color value in 0xRRGGBB format from a string in any of the following formats:
	 * 	- #RGB
	 * 	- #RRGGBB
	 * 	- RGB
	 * 	- RRGGBB
	 */
	private static function parseColor (value:String):Number {
		if (value.charAt (0) == "#") {
			value = value.substr (1);
		}
		if (value.length == 3) {
			var r:Number = parseInt (value.charAt (0), 16);
			var g:Number = parseInt (value.charAt (1), 16);
			var b:Number = parseInt (value.charAt (2), 16);
			return Math.round (r * 255 / 15) << 16 | Math.round (g * 255 / 15) << 8 | Math.round (b * 255 / 15);
		}
		else if (value.length != 6) {
			throw new Error ("Invalid Color");
		}
		return parseInt (value);
	}
}
