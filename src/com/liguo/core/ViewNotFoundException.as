
/**
 * Exception lancé si le controlleur ne trouve pas une View.
 */
class com.liguo.core.ViewNotFoundException extends Error {
		
	public static var className:String = "ViewNotFoundException";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	public function ViewNotFoundException (view:String) {
		super("[ERROR] View not found for mapping : " + view);		
		name = "ViewNotFoundException";
	}	
}
