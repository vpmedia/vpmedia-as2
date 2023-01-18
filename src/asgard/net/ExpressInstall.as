
/**
 * Use this class to invoke the Macromedia Flash Player Express Install functionality
 * ExpressInstall class based on the SWFObject implementation. 
 * This file is intended for use with the FlashObject embed script. You can download FlashObject 
 * and this class here: http://blog.deconcept.com/flashobject/
 * <p>Usage :</p>
 * <p>Launch this code in the first frame of your Flash movie :</p>
 * {@code
 * asgard.net.ExpressInstall.init() ;
 * }
 * You should not place any other code on the first frame of your movie, as the first frame needs to be playable in the Flash player v. 6.0.65.
 */
class asgard.net.ExpressInstall 
{

	/**
	 * Creates a new ExpressInstall instance.
	 */
	public function ExpressInstall() 
	{
		//
	}

	/**
	 * Returns the singleton instance of the ExpressInstall class.
	 * @return the singleton instance of the ExpressInstall class.
	 */
	static public function getInstance():ExpressInstall 
	{
		if (_instance == null) _instance = new ExpressInstall() ;
		return _instance ;
	}

	/**
	 * Initialize the Express Install. 
	 * if the flashvars 'MMplayerType' is not set, the var was not passed in from the SWFObject embed, so the upgrade is not needed.
	 */
	static public function init():Boolean 
	{
		if ( _root.MMplayerType == undefined ) 
		{
			return false ;
		}
		ExpressInstall.getInstance()._loadUpdater() ;
		return true ;
	}

	/**
	 * Start the loading.
	 */
	public function loadInit():Void 
	{
		_hold.redirectURL  = _root.MMredirectURL ;
		_hold.MMplayerType = _root.MMplayerType  ;
		_hold.MMdoctitle   = _root.MMdoctitle    ;
		_hold.startUpdate() ;
	}

	/**
	 * The allow domain of the Express install plugin.
	 */
	static public var ALLOW_DOMAIN:String = "fpdownload.macromedia.com" ;

	/**
	 * The end user chose "NO" when prompted to install the new player. 
	 * By default no User Interface is presented in this case. It is left up to  
	 * the developer to provide an alternate experience in this case 
	 * feel free to change this to whatever you want, js errors are sufficient for this example.
	 */ 
	static public var DOWNLOAD_CANCEL:String = "Download.Cancelled" ;

	/**
	 * Installation is complete. 
	 * In most cases the browser window that this SWF is hosted in will be closed 
	 * by the installer or manually by the end user 
	 */ 
	static public var DOWNLOAD_COMPLETE:String = "Download.Complete" ;
	
	/**
	 * The end user failed to download the installer due to a network failure 
	 * by default no User Interface is presented in this case. It is left up to 
	 * the developer to provide an alternate experience in this case 
	 * feel free to change this to whatever you want, js errors are sufficient for this example.
	 */
	static public var DOWNLOAD_FAILED:String = "Download.Failed" ;
	
	/**
	 * Invoqued when the status of the express install change.
	 */
   	public function installStatus( statusValue ):Void 
   	{
		switch(statusValue) 
		{
			case DOWNLOAD_COMPLETE :
			{
				getURL("javascript:window.opener=self;self.close()");
				break ;
			}
			case DOWNLOAD_CANCEL :
			{
				getURL("javascript:alert('This content requires a more recent version of the Macromedia Flash Player.')") ;
				break ;
			}
			case DOWNLOAD_FAILED :
			{
				getURL("javascript:alert('There was an error in downloading the Flash Player update. Please try again later, or visit macrmedia.com to download the latest version of the Flash plugin.')");
				break ;
			}
		}
	}

	private var _hold:MovieClip ;
	
	static private var _instance:ExpressInstall ;
	
	private var _updater:MovieClip ;

	/**
	 * Load the updater.
	 */
	private function _loadUpdater():Void 
	{
		
		System.security.allowDomain( ALLOW_DOMAIN ) ;
		_updater = _root.createEmptyMovieClip("expressInstallHolder", 10000000);
		// register the callback so we know if they cancel or there is an error
		_updater.installStatus = this.installStatus ;
		
		_hold = _updater.createEmptyMovieClip("hold", 1) ;
		
		_updater.onEnterFrame = function() 
		{
			if (typeof ( this.hold.startUpdate ) == 'function') 
			{
				ExpressInstall.getInstance().loadInit() ;
				delete this.onEnterFrame ;
			}
		} ;
		
		var cache:Number = Math.random() ;
		
		_hold.loadMovie("http://fpdownload.macromedia.com/pub/flashplayer/update/current/swf/autoUpdater.swf?" + cache ) ;
	
	}

}