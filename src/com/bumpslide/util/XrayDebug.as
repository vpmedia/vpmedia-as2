
import com.blitzagency.xray.logger.XrayLogger;
//import com.blitzagency.xray.util.XrayConnect;
import com.bumpslide.util.Debug;
import com.bumpslide.util.Delegate;

/**
* This class is a mix-in that forces bumpslide Debug output into 
* the xray logger instead of the luminic Flash Inspector 
*/
class com.bumpslide.util.XrayDebug
{

	/**
	* Makes bumsplide.util.Debug class output to Xray
	*/
	static function init() {		
		// first, make sure we are connected to Xray		
		//XrayConnect.getInstance( _root, false );
     
		Debug.trace 	= _global.tt;
		Debug.log 		= _global.tt;
		Debug.debug 	= _global.tt;
		Debug.info 		= _global.tt;
		Debug.warn 		= _global.tt;
		Debug.error 	= _global.tt;
		Debug.fatal 	= _global.tt;
	}
}
