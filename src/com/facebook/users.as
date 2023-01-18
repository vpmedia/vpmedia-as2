
import com.facebook.FacebookXML;

/**
 * 
 */
class com.facebook.users extends Object {
	
	/**
	 * Short cut method to "facebook.users.getInfo"
	 * @param String 
	 */
	static function getInfo( uids:Array, fields:Array ):FacebookXML {
		if( typeof uids !== 'object' ){
			uids = [ uids ];
		}
		if( typeof fields !== 'object' ){
			fields = [ fields ];
		}
		var fb_xml:FacebookXML = new FacebookXML( );
		fb_xml.setRequestArgument( 'uids', uids.join(',') );
		fb_xml.setRequestArgument( 'fields', fields.join(',') );
		fb_xml.post( 'facebook.users.getInfo' );
		return fb_xml;
	}
	
}
