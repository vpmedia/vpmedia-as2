/**
* Base Class for maintaining persistent local storage 
* 
* @author David Knape
*/
class com.bumpslide.data.FlashCookie
{
	
	private var mCookieName : String = '_eat_more_cookies';
	private var mLSO : SharedObject;
	
	// SharedObject version num - useful if we need to change formats in future versions
	// upping this number will reset the shared object in all clients
	private var mVersion : Number = .01;
	
	static private var instance:FlashCookie;
		
	private function FlashCookie() {
		init();
	}
	
	static public function getInstance():FlashCookie {
		if(instance==undefined) instance = new FlashCookie();
		return instance;
	}	
	
	/**
	* Initialize cookie
	*/
	private function init() {
		
		mLSO = SharedObject.getLocal(mCookieName, '/');
		
		// make sure we are not dealing with an older version of our flash cookie
		// if old version or not defined, set it up
		if(mLSO.data.version==undefined || mLSO.data.version<mVersion) {
			reset();
		}		
		
		trace( mLSO );
		// secret shortcut key
		Key.addListener( this );
	}
	
	/**
	* Implement secret key codes to reset cookies
	*/
	private function onKeyDown() {		
		if(	Key.isDown(Key.CONTROL) &&
			Key.isDown(Key.ALT) &&
			Key.isDown(Key.SHIFT) ) 
		{
			if(Key.isDown(70)) reset();	
			
			if(Key.isDown(71)) { trace( "Cookiedata:"); trace(mLSO.data ); }
			
		}
	}	
	
	/**
	* Reset cookie var 
	* 
	* Override this and add necessary default values here
	*/
	public function reset() {
		trace( 'Resetting Shared Object');
		mLSO.data.version = mVersion;
	}

	/**
	* Flush the cookies to disk
	*/
	public function flush() {
		return mLSO.flush();
	}
	
	/**
	* return cookie data
	* 
	* @return
	*/
	public function get data () : Object {
		return mLSO.data;
	}
	
	
}

