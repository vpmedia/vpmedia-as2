import com.bumpslide.data.Model;
import com.bumpslide.data.HistoryTracker
import com.bumpslide.data.SWFAddress;
import com.bumpslide.util.Delegate;

/**
* This is a history tracker that uses SWFAddress 
* 
* 
* 
* 
*/

class com.bumpslide.data.SWFAddressTracker extends HistoryTracker
{
	
	var sep='&';
	
	/**
	* Replacing Local connectino with SWFAddress
	*/
	function initBrowserConnection() {
		
		SWFAddress.onChange = Delegate.create( this, onSwfAddressChange );
		
		// init to startup state
		//onSwfAddressChange();
	}
	
	/**
	* SWFAddress.onChange callback
	* 
	*/
	private function onSwfAddressChange() {		
		var addr = SWFAddress.getValue();
		
		debug("Address = " + addr );
		goto( addr );
	}
	
	/**
	* Passes serialized state to hidden frame for browser history tracking
	* 
	* Overridden to use SWFAddress instead of hidden frame trickery 
	*/
	private function doSendClickEvent() {
		clearInterval(_sendClickInt);	
		SWFAddress.setValue( getSerialized() );
	}
	
}