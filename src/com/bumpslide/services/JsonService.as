import com.bumpslide.services.TextService;
import com.bumpslide.util.Delegate;
import com.bumpslide.util.JSON;

/**
* JSON Service
* 
* @code{
* 	var json:JsonService = new JsonService();
*   json.addEventListener( 'onServiceComplete', this );
* 	json.loadUrl( 'myservice.php' );
*   
*   function onServiceComplete(e:ServiceEvent) {
* 	   traceObj( e.result );
*   }
* }
* 
* @author David Knape
*/

class com.bumpslide.services.JsonService extends TextService {

	private function deserialize( resultData ) {
		return JSON.parse( resultData );
	}
	
}