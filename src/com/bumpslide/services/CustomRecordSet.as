import mx.remoting.RecordSet;
import com.bumpslide.util.*;
import com.bumpslide.services.*;

/**
 * Paged Recordset implementation designed to work with the XmlRecordSetService
 * 
 * <p>The MX Recordset class includes a nice bit of functionality 
 * that is quite useful even when we aren't getting a real "recordset" 
 * directly from the server.  This class extends Recordset and gives us hooks
 * that allow us to create a recordset from an array of objects.  
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
 */

class com.bumpslide.services.CustomRecordSet extends RecordSet {
	
	var mRecordSetService : XmlRecordSetService;
	var recordsetId; // public (for reference)
	
	/**
	* Factory Method
	* 
	* Use this to create recordset from data
	* 
	* @param	service
	* @param	rsId
	* @param	initialData
	* @param	nCursor
	* @param	nTotalCount
	* @return
	*/
	// 
	static function create( service, rsId, initialData:Array, nCursor:Number,  nTotalCount:Number ) : CustomRecordSet {
				
		//Debug.info('Creating custom recordset '+rsId);
		//Debug.info( arguments );
		if(nCursor==null) nCursor = 1;		
		if(nTotalCount==null) nTotalCount=initialData.length;
		if(rsId==null) rsId=Math.round(Math.random()*Number.MAX_VALUE);
		
		// get column names from initialData
		var aColumnNames = [];
		for( var prop in initialData[0]) {
			aColumnNames.push(prop);
		}		
		
		// create an 'initObj' for our recordset
		var rsObj = {
			recordsetId: rsId,
			mRecordSetService:service,
			serverInfo: {
				id: rsId,  // --> mRecordSetID
				version: 1, 
				columnNames: aColumnNames, 
				cursor: nCursor, 
				initialData: initialData, // --> items
				totalCount: nTotalCount //--> mTotalCount
			}
		}

		ClassUtil.applyClassToObj( CustomRecordSet, rsObj );		
		rsObj.mRecordsAvailable = initialData.length; 
		return rsObj;
	}
		
	
	
	
	// RecordSet OVERRIDE
	//
	// No need here for all the fancy checks to find the service.  The service will always be
	// available as it was passed in during the factory create process.
	private function getRecordSetService() {
		return  mRecordSetService;
	}
	
	
	
	// RecordSet OVERRIDE
	//
	// In a real recordset, data comes in as arrays of arrays which need to be 
	// converted to objects.  We have no need for this conversion, so we just
	// do an object copy using our arrayTools dCopy (no arrays here, though)
	private function arrayToObject(obj) {
		if(obj instanceof Array) {
			return super.arrayToObject( obj );
		} else {
			return ArrayUtil.dCopy(obj);
		}		
	}
	
	// RecordSet OVERRIDE
	//
	// this function is where all our data comes in from the RecordSet service
	// We've altered the snippet that updates mOutstandingRecordCount
	// to account for the case when the Page length might happen to include
	// more records that we've asked for.
	function getRecords_Result(info:Object):Void {
		
		
		//trace("RecordSet.getRecords_Result(), start=" + info.Cursor +
		//	", id=" + info.id + ", data=" + info.Page);
			
		setData(info.Cursor - 1, info.Page);
		
		// we may be getting more than we requested, so don't rely on page.length
		//mOutstandingRecordCount -= info.Page.length;
		mOutstandingRecordCount -= info.numberRequested; 
		
		updateViews("updateItems", info.Cursor - 1, info.Cursor - 1 + info.Page.length - 1);
	
		Debug.trace("Records Available: "+mRecordsAvailable+"/"+mTotalCount);
		
		if ((mRecordsAvailable == mTotalCount) && !mAllNotified) {
			Debug.trace( "ALL ROWS LOADED");
			updateViews("allRows");
			mRecordSetService.release();
			mAllNotified = true;
			mRecordSetID = null;
			mRecordSetService = null;
		}
	}
	
	// RecordSet OVERRIDE
	//
	// We've put the items[index] update code inside the else block at the bottom.
	// This is really an error in the Macromedia recordset implementation as it 
	// relies on the assumption that the dataArray contains no duplicate data.
	// Why do the the duplcate record check if you're still going to put wrong 
	// data in your items array?  Tsk, Tsk.
	private function setData(start:Number, dataArray:Array):Void {
		//trace("[RecordSet] setData " + start + "," +dataArray.length);
		var datalen:Number = dataArray.length;
		var index:Number;
		var rec:Object
		for (var i:Number = 0; i < datalen; i++) {
			index = i + start;
			rec = items[index];
			if ((rec != null) && (rec != 1)) {
				
				// This should never happen, but depending on how 
				// smart our server-side code is, sometimes this does happen
				
				Debug.warn( '[XmlRecordSet] duplicate record ID '+i+' in setData()');
				
				// why are we getting this data! we already have it
				//NetServices.trace("RecordSet", "warning", 106, "Already got record # " + index);
			} else {
				
				// DK put item update code in side this block, 
				// otherwise the uniqueID gets out of sync if we accidentally load
				// duplicate records.				
				mRecordsAvailable += 1;
				items[index] = arrayToObject(dataArray[i]);
				items[index].__ID__ = uniqueID++;
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
}