import com.bumpslide.util.*;
import com.bumpslide.services.*;
import com.bumpslide.data.*;

/**
 *  Xml RecordSet Service Base Class
 *  
 *  <p>This is the base class for services that return CustomRecordSets
 *  build from data retrieved from an Xml service
 * 
 *  <p>Some services allow you to pass in paging parameters that work 
 *  exactly like the RecordSet class.  That is, ideally, we can just 
 *  call our xml url with params like ?id=someid&start=3&num=20  where 
 *  start (3) is the  firstNum parameter passed to this function, and 
 *  num (20) is the numRequested parameter in actionscript land. It is 
 *  up to the buildUrl method to determine how to format the URL for 
 *  a specific service by pulling from the currentRequest.
 *   
 *  <p>Because RecordSets stick around in memory, it is good to keep a 
 *  static reference to the current XmlRecordsetService instance so that
 *  it can be properly cleaned up when new requests are made. 
 *  
 *  <p>Things to override in implementation sub-classes
 *  <br>- buildUrl()
 *  <br>- handleResult()
 *  <br>- getTotalCount() (if necessary)
 *  <br>- getPageData()  (if necessary)
 * 
 *  @see com.bumpslide.example.xmlrecordset.TestService 
 * 
 *  @author David Knape
 * 
 *  Copyright © 2006 David Knape (http://bumpslide.com)
 *  Released under the open-source MIT license. 
 *  http://www.opensource.org/licenses/mit-license.php
 *  See LICENSE.txt for full license terms. 
 * 
 */
class com.bumpslide.services.XmlRecordSetService extends XmlService {

	var name = 'XmlRecordSetService';
	
	// _result is a reference to this (for the sake of clarity in code)
	var myRecordSet :CustomRecordSet = null;
	
	// whether or not we should still be working	
	var stale = false;
	
	// show trace messages
	var debug = false;
	
	// default page size 
	private var _pageSize :Number = 30;  	
	
	// number of pages to read ahead (default is 0, only read current page) 
	private var _prefetchPages :Number = 1;
	
	// Internal request queue for paged data
	private var requestQueue :Array;	
	
	// reference to current item (shifted off of queue)
	private var currentRequest :PageRequest;	
	
	
	function XmlRecordSetService() {
		super();
		dTrace( 'CTOR');
		requestQueue = new Array();	
		currentRequest = null;
	}
	
	function get pendingRequest () : PageRequest {
		return currentRequest;
	}
	
	/**
	* Constructs URL from service parameters
	* 
	* This should be overrided in every RS service implementation
	*/
	private function buildUrl () {
		//var urlTemplate = 'http://server/xml.cgi?n=%d&count=%d&pg=%d'; // 
		//return Sprintf.format(urlTemplate, _args[0], currentRequest.pageSize, currentRequest.pageNum);		
		notifyError('URL is not defined in XML Recordset Service '+this);	
		return undefined;
	}
	
	/**
	* Get record total from XML (optional override)
	* 
	* Recordset Services need to know how many records are in the recordset.
	* The server-side code should include this somewhere, and here we
	* determine where that is.
	*/
	private function getTotalCount() {
		return parseInt( xmlLoader.xml.firstChild.attributes.total );
	}
	
	/**
	* Get page data (optional override)
	* 
	* Once XML Loads, this should return an array of objects corresponding to 
	* the current page request.
	*/
	private function getPageData() {
		//return XPath.selectNodes(xml, xpathToData)
		return nodesToObjects( xml.firstChild.childNodes );		
	}	
	
	/**
	* Recordset page size (delivery mode)
	* @param	pgSize
	*/
	public function set pageSize( pgSize : Number  ) {
		dTrace('setting page size to '+pgSize);
		_pageSize = pgSize;
		if(myRecordSet!=null) {
			myRecordSet.setDeliveryMode( 'page', _pageSize, _prefetchPages );
		}
	}
	
	/**
	* Recordset pages to prefetch (delivery mode)
	* @param	pgSize
	*/
	public function set prefetchPages( numPrefetchPages:Number ) {
		dTrace('setting prefetchPages to '+numPrefetchPages);
		_prefetchPages = numPrefetchPages;
		if(myRecordSet!=null) {
			myRecordSet.setDeliveryMode( 'page', _pageSize, _prefetchPages );
		}
	}
	
	/**
	* Recordset page size (delivery mode)
	*/
	public function get pageSize() : Number {
		return _pageSize;
	}
	
	/**
	* Recordset pages to prefetch (delivery mode)
	*/
	public function get prefetchPages() : Number {
		return _prefetchPages;
	}
	
	/**
	* Recordset ID
	* 
	* defaults to request ID
	*/
	public function get recordsetId () {
		return requestId;
	}
	
	/**
	* Cancels any pending request
	*/
	function cancel() {
		super.cancel();
		destroy();
	}
	
	/**
	* Releases service from recordset
	* 
	* called by recordset when all data has been loaded
	*/
	function release() {
		clearQueue();
	}
	
	/**
	* Clears the queue and the recordset
	*/
	function destroy() {
		dTrace('destroy');
		
		// clear request queue and destroy xml loader
		clearQueue(); 
		
		// clear the recordset
		myRecordSet.clear();
		myRecordSet.mRecordSetService = null;
		myRecordSet = null;
		stale = true;		
	}
	
	
	
	/**
	* XmlLoader callback
	* 
	* <p>This is called every time we receive XML data.
	* 
	* <p>If there is no recordset created yet, then we know we have just received the first 
	* 
	* <p>Data is ignored if the service request was cancelled.
	*/
	private function onXmlLoaderSuccess() 
	{		
		
		
		isXmlLoading = false;
		
		if(cancelled) {			
			dTrace('Service was cancelled before XML arrived.');
			clearTimer();
		} else if (stale) { 			
			dTrace('XML Result is stale. We\'ve moved on to a new request already.');
			clearTimer();
			return;				
		} else {	
			
			if(myRecordSet==null) {	
				dTrace('First Page XML Loaded');
				createRecordset();
				if(false===onRecordSetLoaded( myRecordSet )) {
					handleResult( myRecordSet );
				}
				clearTimer();
				notifyComplete();
			} else {				
				if(currentRequest==null) {
					dTrace('Current Request is null, must be stale.');
					return;
				}
				dTrace('Received XML for request '+currentRequest);
				myRecordSet.getRecords_Result( new PageResponse(currentRequest, getPageData()) );
			}					
			loadNext();				
		}		
	}
	
	
	/**
	* Override to save rs to app-wide model locator
	* @param	rs
	* @deprecated use handleResult instead
	*/
	private function onRecordSetLoaded( rs:CustomRecordSet ) {
		return false
	}
	
	
	/** 
	 * Runs the service
	 * 
	 * <p>This is called by the service loader (or from within service.load)
	 * from here, we are starting a fresh recordset
	 */
	function run() {	
		dTrace( 'Run' );
		requestQueue.push( new PageRequest( recordsetId, 1, pageSize) );
		loadNext();
	}	
	
	/**
	* Clears Xml Request queue.
	*/
	private function clearQueue() {		
		//dTrace('Clearing XML Queue');
		requestQueue = new Array();	
		currentRequest = null;
		xmlLoader.destroy();
	}
		
	/** 
	 * Loads next page request
	 *
	 * Checks Xml Request queue, and loads next page of data when needed
	 */ 
	private function loadNext() {		
		
		if(isXmlLoading) return;
		
		dTrace('loadNext');
		
		xmlLoader.destroy();
		
		// If we're at the end of the line, set currentService to null.
		if(!requestQueue.length) {
			dTrace('queue is clear');
			currentRequest = null;
			clearTimer();
			return;
		}		
		
		// load next request in the queue 
		// (pageRequest will be deleted from front of the requestQueue array)
		currentRequest = PageRequest( requestQueue.shift() );	
		dTrace('Loading next Page Request... '+currentRequest);
		doLoadXml();
	}
	
	/**
	* Creates recordset
	*
	* In real Flash remoting, recordsets are returned by the server.  
	* With XML, we need to turn our XML into a recordset.  We use XPath to get
	* and array of node objects that represent items in the recordset.  Those 
	* item objects will be filled using the names attributes in these nodes.
	*/	
	private function createRecordset() {
		dTrace('Creating new RecordSet');
		var initialCursor = 1;		
		result = myRecordSet = CustomRecordSet.create( this, currentRequest.id, getPageData(), initialCursor, getTotalCount());
		myRecordSet.setDeliveryMode( 'page', _pageSize, _prefetchPages );
		if(debug) Debug.info(myRecordSet.items);		
	}
	

		
	/** 
	 * Returns record data to RecordSet class
	 *  
	 * This is the function that the RecordSet calls when it needs more records.
	 * Paging logic is now in the PageRequest class.
	 */	
	function getRecords(recordSetId, firstNum, numRequested) {			
		
		dTrace( "Recordset is requesting items "+firstNum+"-"+(firstNum+numRequested-1));

		var page = Math.ceil( numRequested / pageSize );
		
		while(page--) {
			var first = firstNum + page * pageSize;
			var last  = first + pageSize - 1;
			//dTrace( "Enqueuing recordset request for items "+first+"-"+last);		
			requestQueue.unshift( new PageRequest( recordSetId, first, pageSize ) );
		}
						
		if(!isXmlLoading && requestQueue.length) loadNext();	
	}
	
	function dTrace(s) {
		if(debug) Debug.info( '[XmlRsService] '+s );
	}
	
	
}