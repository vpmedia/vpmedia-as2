
/**
 * Exception lancé si la requête recoit une URL invalide.
 */
class com.liguo.core.InvalidURLException extends Error {		
	
	public static var className:String = "InvalidURLException";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	public function InvalidURLException (url:String) {
		super("[ERROR] Invalid URL : " + url);
		name = "InvalidURLException";
	}
}
