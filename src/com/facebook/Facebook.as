
/**
 * Facebook API top level class. 
 * Provides internal configuration with login and authentication helpers.
 * @see http://developers.facebook.com/documentation.php
 * @author Tim Whitlock <tim at white interactive dot com>
 */


import com.facebook.FacebookXML;
import com.facebook.auth;

/**
 *
 */
class com.facebook.Facebook extends Object {
	
	#include "version.as"
	
	/** 
	 * URL of Facebook api server or proxy/redirect script 
	 * May be passed in as flashvar "resturl" in the root
	 */
	private static var restURL:String;
	static function get REST_URL():String {
		if( restURL == null ){
			if( _root.resturl ){
				restURL = _root.resturl;
				delete _root.resturl;
			}
			else {
				restURL = 'http://api.facebook.com/restserver.php';
			}
		}
		return restURL;
	}
	
	/** 
	 * Your applications registred API key - obtained from Facebook 
	 */
	private static var apiKey:String;
	static function get API_KEY():String {
		if( apiKey == null ){
			if( _root.fb_sig_api_key ){
				apiKey = _root.fb_sig_api_key;
			}
			else {
				apiKey = '00000000000000000000000000000000';
			}
		}
		return apiKey;
	}
	
	/**
	 * The secret that is paired with your API key - obtained from Facebook.
	 * For security you should not embed it, rather use a backend proxy to relay your calls
	 * once you've established that the flash app's call to the proxy is authentic.
	 */
	static function get SECRET():String {
		return '';
	}
	
	/** HTTP User Agent to send in api requests */
	private static var userAgent:String;
	static function get USER_AGENT():String {
		if( Facebook.userAgent == null ){
			var fvers:String = _root.$version.split(' ').join('-').split(',').join('.');
			Facebook.userAgent = 'ActionScript/2.0 (http://whiteinteractive.com/facebook/asclient.php) Flash/'+fvers;	
		}
		return Facebook.userAgent;
	}
	
	/** session key set by initial login call */
	private static var sessionKey:String = '';
	static function get SESSION_KEY():String {
		return Facebook.sessionKey;
	}
	
	/** user id set by initial login call */
	private static var userID:String = '0';
	static function get UID():String {
		return Facebook.userID;
	}
	
	
	
	/** public callbacks for session initialization */
	public static var onSessionStart:Function;
	public static var onSessionFail:Function;
	public static var onSessionTimeout:Function;
	
	
	
	/**
	 * Start session with userID and sessionKey.
	 * These values will be globally available as pseudo constants Facebook.SESSION_KEY & Facebook.UID
	 * @param String session key, leave null to use fb_sig_session_key passed into root
	 * @param String user id of logged in user for this session, leave null to use fb_sig_user passed into root
	 * @param Number session expiry timestamp (seconds), leave null to use fb_sig_expires passed into root
	 */
	static function startSession( key:String, uid:String, expires:Number ):Void {
		// look for canvas flashvars where arguments unspecified
		if( key == null ){
			key = _root.fb_sig_session_key;
		}
		if( uid == null ){
			uid = _root.fb_sig_user;
		}
		if( expires == null ){
			expires = Number( _root.fb_sig_expires );
		}
		// set timeout function for expiry of current session
		if( expires && !isNaN(expires) ){
			var now:Number = new Date().getTime();
			var exp:Number = expires * 1000;
			var ttl:Number = exp - now;
			if( ttl <= 0 ){
				Facebook.onSessionTimeout();
				return;
			}
			// create anonymous timeout function which calls onSessionTimeout
			// temporary facebook sessions are 24 hours, so this situation is unlikely
			var timeoutID:Number = setInterval(
				function():Void {
					clearInterval( timeoutID );
					delete timeoutID;
					Facebook.sessionKey = '';
					Facebook.userID = '0';
					Facebook.onSessionTimeout();
				},
				ttl
			);
		}
		// set current session params
		Facebook.sessionKey = key;
		Facebook.userID = uid;
		// invoke session start handler
		Facebook.onSessionStart();
	}



	/**
	 * Log into Facebook using a remote wrapper script of your own design.
	 * The script at this URL must return the XML resonse from the Facebook api call to "Facebook.auth.getSession"
	 * @param string url of wrapper script
	 * @return Boolean whether post was successfuly sent
	 */
	static function login( url:String ):Boolean {
		var fb_xml:FacebookXML = new FacebookXML();
		fb_xml.onLoad = function():Void{
			var u:String = this.getResponseArgument('uid');
			var s:String = this.getResponseArgument('session_key');
			var t:Number = Number( this.getResponseArgument('expires') );
			if( u == null || s == null ){
				Facebook.onSessionFail('Bad response from remote login script');
			}
			else {
				Facebook.startSession( s, u, t );
			}
		}
		fb_xml.onError = function( detail:String ):Void{
			Facebook.onSessionFail( detail );
		}
		// compile fb_sig* args
		for( var s:String in _root ){
			if( s.indexOf('fb_sig') === 0 ){
				fb_xml.setRequestArgument( s, _root[s] );
			}
		}
		return fb_xml.post( null, url );
	}
	
	
	
	
	
	/**
	 * Log into Facebook with an auth token already obtained outside of Flash.
	 * @param string auth token obtained from Facebook application login
	 * @return Boolean whether post was successfuly sent
	 */
	static function authenticate( token:String ):Boolean {
		var fb_xml:FacebookXML = auth.getSession();
		if( !fb_xml ){
			return false;
		}
		fb_xml.onLoad = function():Void{
			var u:String = fb_xml.getResponseArgument('uid');
			var s:String = fb_xml.getResponseArgument('session_key');
			var t:Number = Number( fb_xml.getResponseArgument('expires') );
			if( u == null || s == null ){
				Facebook.onSessionFail('Failed to authenticate with token:' + token );
			}
			else {
				Facebook.startSession( s, u, t );
			}
		}
		fb_xml.onError = function( detail:String ):Void{
			Facebook.onSessionFail( 'Failed to authenticate with token:' + token + newline + detail );
		}
		return true;
	}
	
	
	
	
	
	
	
}