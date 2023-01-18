import com.bumpslide.util.Debug;
import com.bumpslide.util.Sprintf;

/**
 *  XmlRecordSetservice to retrieve flickr photos
 * 
 *  This class is an example of how to use the xml recordset functionality.
 *  Flickr photo search is a perfect example of an XML based service that
 *  returns data in pages.
 * 
 *  We just need to tell our service how to interpret and fetch these pages, 
 *  and it will return an mx.remoting.Recordset class with full paged 
 *  data loading and model updates.  
 * 
 *  @author David Knape
 * 
 *  Copyright © 2006 David Knape (http://bumpslide.com)
 *  Released under the open-source MIT license. 
 *  http://www.opensource.org/licenses/mit-license.php
 *  See LICENSE.txt for full license terms. 
 */
class com.bumpslide.services.FlickrPhotoService extends com.bumpslide.services.XmlRecordSetService
{
	// 
	var FLICKR_REST_ENDPOINT : String = "http://api.flickr.com/services/rest/";
	var FLICKR_API_KEY : String = "1a01abdc020efe076816318e0243af0c";
	
	// auto read ahead...
	var prefetchPages : Number = 2;
	var pageSize : Number = 100;	
	
	// pass 'onServiceBusy' events without any delay 
	// so we can display messages related to behind the scenes loading
	// of page requests
	var busyMs = 1;
	
	// show debug messages
	var debug = true;
		
	/**
	* STEP 1 - Parse arguments into named variables using getters
	*/
	function get tags () : String {
		return args[0];
	}
	
	/**
	* STEP 2 - Build the URL
	*/
	function buildUrl() {		
		
		var url:String = FLICKR_REST_ENDPOINT + '?';	
		var params:Object = getUrlParameters();		
		params['api_key'] = FLICKR_API_KEY;				
		for(var p in params) {
			if(params[p]!=undefined) {
				url += Sprintf.format( '%s=%s&', p, params[p] );
			}
		}		
		return url;
	}
	
	/**
	* a little helper for our flickr service
	* 
	* (we can easily override this later in a subclass if necessary)
	*/
	private function getUrlParameters () {
		return {
			method: 'flickr.photos.search',
			per_page: currentRequest.pageSize,
			page: currentRequest.pageNum,
			tags: tags	
		}
	}
	
	/**
	* Step 3 - Get record total from XML result
	*
	* Recordset Services need to know how many records are in the recordset.
	* The server-side code should include this somewhere, and here we
	* determine where that is.
	*/
	function getTotalCount() {
		return parseInt( xml.firstChild.firstChild.attributes.total );
	}
	
	/**
	* Step 4 - Get page data
	* 
	* Once XML Loads, this should return an array of objects corresponding to 
	* the current page request.
	*/
	function getPageData() {
		
		var data:Array = nodesToObjects( xml.firstChild.firstChild.childNodes );		
		
		// we could just return data directly, but now that we have it,
		// let's be nice, build the url's we need
		for( var n in data ) {
			var p = data[n];
			var photoUrl = "http://farm1.static.flickr.com/"+p.server+"/"+p.id+"_"+p.secret;			
			data[n].urlPhotoPage = "http://www.flickr.com/photos/"+p.owner+"/"+p.id+"/";			
			data[n].urlThumb = photoUrl + '_s.jpg';
			data[n].urlSmall = photoUrl + '_m.jpg';
			data[n].urlMedium = photoUrl + '.jpg';
			data[n].urlLarge = photoUrl + '_b.jpg';			
		}
		return data;		
	}
	
	/**
	* Step 5 - handle result
	* 
	* At this point, we should have a full-featured recordset.
	* Although, it may not be entirely loaded.
	*/
	function handleResult( rs ) {
		
		// you may want to save data to model locator here		
		Debug.warn( "RecordsetLoaded:");
		Debug.warn( rs.items );
		
	}
}
