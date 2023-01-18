/**
 * com.sekati.net.NetBase
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.validate.StringValidation;

/**
 * static class wrapping various Network utilities
 */
class com.sekati.net.NetBase {

	/**
	 * return the URL Path swf is running under
	 * @return String
	 * {@code Usage:
	 * 	// run from http://localhost/myProject/site.swf
	 * 	trace(NetBase.getPath()); // returns "http://localhost/myProject/"
	 * }
	 */
	public static function getPath():String {
		return( _root._url.substr( 0, _root._url.lastIndexOf( '/' ) + 1 ) );
	}

	/**
	 * check if we are online the swf is being executed over http.
	 * @return Boolean
	 */
	public static function isOnline():Boolean {
		return StringValidation.isURL( _root._url );
	}

	/**
	 * add a cache killing querystring to url
	 * @param url (String)
	 * @return String
	 * {@code Usage:
	 * 	var ckUrl = NetBase.noCacheUrl("http://localhost/page.html"); // returns: http://localhost/page.html?030533
	 * }
	 */
	public static function noCacheUrl(url:String):String {
		return url + "?" + new Date( ).getTime( );	
	}

	private function NetBase() {	
	}
}