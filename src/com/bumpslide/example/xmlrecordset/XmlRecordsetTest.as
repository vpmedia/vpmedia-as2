 
import com.bumpslide.util.*;
import com.bumpslide.services.Service;
import com.bumpslide.services.ServiceEvent;
import com.bumpslide.services.XmlRecordSetService;
import com.bumpslide.example.xmlrecordset.TestService;

import mx.remoting.RecordSet;
import mx.controls.DataGrid;

/**
*  XmlRecordset test app
* 
*  Copyright © 2006 David Knape (http://bumpslide.com)
*  Released under the open-source MIT license. 
*  http://www.opensource.org/licenses/mit-license.php
*  See LICENSE.txt for full license terms. 
* 
*/

class com.bumpslide.example.xmlrecordset.XmlRecordsetTest extends MovieClip
{
	// list box
	var dgrid : DataGrid;
	
	// xml service
	var testService	: TestService;
	
	// resulting recordset will becomes the list box dataProvider
	var test_rs		: RecordSet;
	
	// called from timeline root (or from MTASC)
	// makes root MC an instance of this class
	static function main( root ) {
		ClassUtil.applyClassToObj( XmlRecordsetTest, root );
	}
	
	function XmlRecordsetTest() {		
		
		// stop playback
		stop();
		
		// init stage and listen to resize events
		Stage.scaleMode = "noScale";
		Stage.align = "TL";	
		Stage.addListener(this);
		onResize();
						
		testService = new TestService();		
		testService.prefetchPages = 2;
		testService.pageSize = 10;		
		testService.addEventListener( Service.EVENT_COMPLETE, Delegate.create( this, recordsetCreated));	
		testService.addEventListener( Service.EVENT_ERROR, Delegate.create( this, serviceError));	
		testService.load();			
	}
	
	// when stage size changes, update the size of the data grid
	function onResize() {
		dgrid.setSize(Stage.width-20, Stage.height-100);
	}
	
	
	// after the recordset is first created by the test service
	// we make it the data provider for the list box
	// the list box knows how to populate itself using the PageableData 
	// interface that we have implemented by extending the mx.remoting.RecordSet class
	function recordsetCreated( evt ) {
		dgrid.dataProvider = evt.result;
		dgrid.addEventListener( 'change', Delegate.create(this, onItemSelected));		
	}	
	
	function serviceError(e:ServiceEvent) {
		Debug.error( e.message );
	}
	
	
	// when an item in the list is selected, we trace the item contents for testing
	function onItemSelected(evt) {
		var item = evt.target.selectedItem;
		Debug.trace('Item Selected:');
		Debug.trace( item );
	}	
	
	
	
	
	
	
	
	
}