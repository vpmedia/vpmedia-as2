
import com.bumpslide.services.*;

/**
* This is an example Service proxy that uses the FlickrPhotoService
*/
class com.bumpslide.services.FlickrServiceProxy extends ServiceProxy
{	
	// onServiceComplete_* events
	public static var EVENT_TAG_SEARCH_COMPLETE : String = "onServiceComplete_tagSearch";
			
	
	// public interfaces
	function tagSearch( tags:String ) : com.bumpslide.services.ServiceRequest {		
		return requestService( 'tagSearch', FlickrPhotoService, arguments );
	}
	
	
		
	// singleton instance
	private static var instance:FlickrServiceProxy;
	
	/**
	* returns singleton instance 
	*/
	public static function getInstance() : FlickrServiceProxy {
		if (instance == null) instance = new FlickrServiceProxy ();
		return instance;
	}
}
