
/**
 * Exception lancé si le controlleur ne trouve pas un Forward.
 */
class com.liguo.core.ForwardNotFoundException extends Error{
	
	public static var className:String = "ForwardNotFoundException";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	public function ForwardNotFoundException (action:String, forward:String){
		super("[ERROR] Forward '"+forward+"' not found for action '"+action+"'");		
		name = "ForwardNotFoundException";
	}	
}
