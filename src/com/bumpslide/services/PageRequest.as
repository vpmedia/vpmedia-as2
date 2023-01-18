import com.bumpslide.util.Debug;

/**
 * Encapsulates some of the page request details for XmlRecordSetService
 * 
 * <p>some systems want starting num and ending number, some want page num and count
 * this class starts with a recordset getData request, and gives us enough info to 
 * pass to various types of pages result set systems
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
 * 
 */
 
class com.bumpslide.services.PageRequest
{
	
	
	// recordset id
	var id:String;	
	var firstRequested:Number;
	var numberRequested: Number;
	
	var pageSize:Number;
	var pageNum:Number;
	var Cursor:Number;	
	
	
	function PageRequest(recordsetId:String, firstNum:Number, numRequested:Number)
	{
		/**
		* The recordset class (mx.remoting.recordset) requests page results as a range.
		* However, many backend services ask for a pageSize and a page number.
		* 
		* We need to find out what the correct page number is for this request.
		* 
		* Then, we need to save all this info so that we can use it to build our url.
		*/	
		pageSize = numRequested;
		pageNum = Math.floor( (firstNum-1)/ pageSize) + 1;
		Cursor = (pageNum-1) * pageSize + 1;
		
		if(firstNum>Cursor) {
			pageSize*=2;
			pageNum = Math.floor( (firstNum-1)/ pageSize) + 1;
			Cursor = (pageNum-1) * pageSize + 1;
		}
			
		id = recordsetId;
		firstRequested = firstNum;
		numberRequested = numRequested;
						
		
		//Debug.info( "New Page request...");		
		//Debug.info( this );
		
	}
	
	function toString() : String  {		
		return "[PageRequest] { id:"+id+", firstRequested:"+firstRequested+", numberRequested:"+numberRequested+", actualStartingIndex:"+Cursor+", actualPagesize:"+pageSize+"}";		
	}
		
}
