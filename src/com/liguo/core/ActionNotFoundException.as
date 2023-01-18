
/**
 * Exception lancé si le controlleur ne trouve pas une action.
 */
class com.liguo.core.ActionNotFoundException extends Error {
	
	public static var className:String = "ActionNotFoundException";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	public function ActionNotFoundException (action:String) {
		super("[ERROR] Action not found for mapping : " + action );
		name = "ActionNotFoundException";
	}
}
