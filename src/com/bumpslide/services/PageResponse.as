import com.bumpslide.services.PageRequest;
import com.bumpslide.util.Debug;

/**
 * value object designed to be passed back to the RecordSet.getRecords_Result function
 * 
 * <p>also takes care of removing records that were not requested before handing them back to 
 * the recordset class
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
*/

class com.bumpslide.services.PageResponse
{
	
	var id:String;
	var Cursor:Number;	
	var Page:Array;
	
	function PageResponse(request:PageRequest, pageData:Array) {
		
		id=request.id;
		Page = pageData;			

		// remove redundant records we don't need	
		if(Page.length > request.numberRequested) {			
			if(request.Cursor < request.firstRequested) {
				while(++request.Cursor < request.firstRequested) {
					//Debug.warn('[PageResponse] Redundant Data Request cursor='+currentRequest.Cursor);
					Page.shift();				
				}	
			}				
			Cursor = request.Cursor;
		} else {
			Cursor = request.firstRequested;
		}
		//Debug.info( this.toString() );
	}
	
	function toString() : String  {		
		return "PageResponse: [ rsid:"+id+", Cursor="+Cursor+", Page.lenth="+Page.length+" ]";		
	}
}
