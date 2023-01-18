import com.bumpslide.services.Service;
import com.bumpslide.util.Delegate;

/**
 * Basic service implementation for Load vars, JSON, or custom text-based services
 * 
 */

class com.bumpslide.services.TextService extends Service{

	var lv:LoadVars;
	
	public function loadUrl( url ) {
		return load( [url] );
	}
	
	// url definition
	function buildUrl () {
		var url = args[0];
		if( url==null ) {
			notifyError('URL is not defined in Text Service '+this);
			return undefined;
		} else {
			return url;
		}
	}
	
	// Service.run implementation
	public function run() {
		lv = new LoadVars();
		lv.onData = Delegate.create(this, onLvLoad);
		lv.load(buildUrl());	
	}
	
	private function onLvLoad(str:String) {
		clearTimer();		
		if(str == null) {
			//That was actually an error			
			notifyError( "Failed to load service.");
			return;
		}		
		try {
			result = deserialize( str );
			handleResult( result )
			notifyComplete();	
		} catch(error:Error) {
			notifyError(error.toString());
		}
	}
	
	// override this in base class if necesary
	private function deserialize( resultString:String ) {
		return resultString;
	}
	
}