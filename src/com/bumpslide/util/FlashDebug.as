import com.bumpslide.util.ArrayUtil;
import com.bumpslide.util.Debug;
import com.bumpslide.util.Delegate;
import com.bumpslide.util.Dump;

/**
* This class is a mix-in that forces bumpslide Debug output into 
* the flash trace panel (or the flash tracer firefox plugin)
*/
class com.bumpslide.util.FlashDebug {

	public function FlashDebug() {
		
	}
	
	/**
	* Makes bumsplide.util.Debug class output to flash trace panel
	*/
	static function init() {
		Debug.trace 	= Dump.trace
		Debug.log 		= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'LOG   - ' );
		Debug.debug 	= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'DEBUG - ' );
		Debug.info 		= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'INFO  - ' );
		Debug.warn 		= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'WARN  - ' );
		Debug.error 	= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'ERROR - ' );
		Debug.fatal 	= Debug.trace ;//Delegate.create( FlashDebug, FlashDebug.trace, 'FATAL - ' );
	}
	
}