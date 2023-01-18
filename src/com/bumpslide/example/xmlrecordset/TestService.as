import com.bumpslide.util.Debug;

 
/**
 *  Test XmlRecordSetservice 
 * 
 *  @author David Knape
 * 
 *  Copyright © 2006 David Knape (http://bumpslide.com)
 *  Released under the open-source MIT license. 
 *  http://www.opensource.org/licenses/mit-license.php
 *  See LICENSE.txt for full license terms. 
 * 
 */
class com.bumpslide.example.xmlrecordset.TestService extends com.bumpslide.services.XmlRecordSetService
{
	var debug= true;
		
	function buildUrl() {				
		// it's handy to pull the url root from flashvars
		// (even handier to store it in an app-wide config setting somewhere)
		var urlRoot = (_root.urlRoot!=null) ? _root.urlRoot : 'http://bumpslide.sourceforge.net/test/';		
		
		// build and return the url be pulling data from the current PageRequest
		var url = urlRoot + 'xmlrecordset.php';		
		url+='?start='+currentRequest.firstRequested;
		url+='&count='+currentRequest.numberRequested;
		
		return url;
	}
	
	
	function handleResult( rs ) {
		
		// save to model locator here
		
		Debug.warn( "RecordsetLoaded:");
		Debug.warn( rs.items );
		
	}
	
	//-------------------------------------------------------------------
	// Below are default implementations. Change to meet your needs.
	//-------------------------------------------------------------------
	
	/**
	* Get record total from XML
	* 
	* Recordset Services need to know how many records are in the recordset.
	* The server-side code should include this somewhere, and here we
	* determine where that is.
	*/
	function getTotalCount() {
		return parseInt( xmlLoader.xml.firstChild.attributes.total );
	}
	
	/**
	* Get page data
	* 
	* Once XML Loads, this should return an array of objects corresponding to 
	* the current page request.
	*/
	function getPageData() {
		//return XPath.selectNodes(xml, xpathToData)
		return nodesToObjects( xml.firstChild.childNodes );		
	}
	
}
