
import com.facebook.FacebookXML;




/**
 * 
 */
class com.facebook.auth extends Object {
	
	
	/**
	 * Short cut method to "facebook.auth.createToken"
	 * @param String 
	 */
	static function createToken( ):FacebookXML {
		var fb_xml:FacebookXML = new FacebookXML( );
		fb_xml.post( 'facebook.auth.createToken' );
		return fb_xml;
	}
	
	
	/**
	 * Short cut method to "facebook.auth.getSession"
	 * @param String 
	 */
	static function getSession( auth_token:String ):FacebookXML {
		var fb_xml:FacebookXML = new FacebookXML( );
		fb_xml.setRequestArgument( 'auth_token', auth_token );
		fb_xml.post( 'facebook.auth.getSession' );
		return fb_xml;
	}
	
	
}
