import com.bumpslide.util.*;
import com.bumpslide.services.*;
import com.bumpslide.ui.ResizableImage;

import mx.controls.*;
import mx.remoting.RecordSet;

/**
*  Flickr Recordset Test app 
* 
*  This class is a MovieClip class associated with the root timeline.
* 
*  Copyright © 2007 David Knape (http://bumpslide.com)
*  Released under the open-source MIT license. 
*  http://www.opensource.org/licenses/mit-license.php
*  See LICENSE.txt for full license terms. 
*/

class com.bumpslide.example.xmlrecordset.FlickrRecordsetTest extends com.bumpslide.core.BaseClip
{
	// timeline clips
	var grid_mc : DataGrid;
	var input_txt : TextInput;
	var search_btn : Button;
	var status_txt :TextField;
	var msg_txt :TextField;
	
	// dynamically created clips
	var image_mc:ResizableImage;
		
	// stage
	private var stage : StageProxy;
	
	// xml service
	private var service: FlickrServiceProxy;
	
	// resulting recordset that will become the list box dataProvider
	private var results_rs : CustomRecordSet;
	
	/**
	* Constructor - called via static function main 
	*/
	function FlickrRecordsetTest() {	
		super();
		init();		
		//XrayDebug.init();
	}
	
	/**
	* sets up stage and service as well as various event delegates
	*/
	private function init() {
				
		// allow smooth stage resize events
		stage.eventMode = StageProxy.PASS_THRU;
		
		// service
		service = FlickrServiceProxy.getInstance();
		service.addEventListener( FlickrServiceProxy.EVENT_TAG_SEARCH_COMPLETE, d( onRecordsetCreated ) );
		
		
		// resizable image
		image_mc = ResizableImage.create( 'image_mc', this );
		image_mc.addEventListener( ResizableImage.EVENT_IMAGE_LOADED, d( onImageLoaded )  );
		
		// we can't apply smoothing to images loaded from remote domains 
		// so, disabled smoothing if on the web
		// see http://chattyfig.figleaf.com/pipermail/flashcoders/2006-July/169887.html
		if(_url.substring(0,4)=='http') {
			image_mc.applySmoothing = false;
			
		}
		image_mc.allowStretching = false;
		
		// component events
		search_btn.addEventListener('click', d( search ) );
		grid_mc.addEventListener( 'change', d( onItemSelected ));
		
		// configure grid
		grid_mc.columnNames = ['id', 'title'];
		grid_mc.getColumnAt(0).width = 110;
		grid_mc.getColumnAt(0).headerText = "ID";
		grid_mc.getColumnAt(1).headerText = "Title";
		
		// default search...
		input_txt.text = "macromedia";
		search();
	}
	
	/**
	* when stage size changes, update the size of the data grid and image
	*/ 
	private function onStageResize() {
		
		var w = (stage.width-30)/2;		
		var h = stage.height-120
		
		grid_mc.setSize(w, h);		
		image_mc.setSize( w, h);
		
		// center image in remaining space
		image_mc._y = 110 + Math.round( (h-image_mc.height)/2 );
		image_mc._x = w + 20 + Math.round( (w-image_mc.width)/2 );
				
	}
	
	/**
	* runs the flickr photo search
	*/
	private function search() {
		
		results_rs.mRecordSetService.removeEventListener( ServiceEvent.EVENT_BUSY, this );
		results_rs.mRecordSetService.removeEventListener( ServiceEvent.EVENT_CLEAR, this );
		
		service.tagSearch( input_txt.text );
		
		status_txt.text = "";
		msg_txt.text = "Loading...";
		
		grid_mc.dataProvider = null;
	}
	
	/**
	* After the recordset is first created by the test service,
	* we make it the data provider for the grid.  The grid knows 
	* how to populate itself using the PageableData interface that 
	* we have implemented by extending the mx.remoting.RecordSet 
	* class.  
	* 
	* @param service complete event
	*/
	private function onRecordsetCreated( evt:ServiceEvent ) {
		
		results_rs = evt.result;
		
		// listen for busy and clear events on the recordset service
		results_rs.mRecordSetService.addEventListener( ServiceEvent.EVENT_BUSY, this );
		results_rs.mRecordSetService.addEventListener( ServiceEvent.EVENT_CLEAR, this );
		
		if(results_rs.length) {
			status_txt.text = results_rs.length + " Results";
			grid_mc.dataProvider = results_rs;	
			stage.update();
		} else {
			status_txt.text = "No Results";
		}
		
		if(results_rs.isFullyPopulated) {
			msg_txt.text = "Complete.  (now you can sort)";
		} else {
			msg_txt.text = "";
		}
	}	
	
	function onServiceBusy( evt:ServiceEvent ) {
		var request:PageRequest = evt.target.pendingRequest;
		msg_txt.text = 'Loading items '+request.firstRequested+'-'+(request.firstRequested+request.numberRequested-1) + '... ';
	}
	function onServiceClear( evt:ServiceEvent ) {		
		
		if(results_rs.getNumberAvailable() == results_rs.length) {
			msg_txt.text = "Complete.  (now you can sort)";
		} else {
			msg_txt.text = 'Records Loaded: ' + results_rs.getNumberAvailable();
		}
	}
	
	/**
	* when an item in the list is selected, we trace the item contents for testing
	* @param	evt
	*/ 
	private function onItemSelected(evt) {
		var item = evt.target.selectedItem;
		Debug.trace('Selected Item '+evt.target.selectedIndex);
		Debug.trace( item );
		
		image_mc.reset();
		image_mc._alpha = 0;
		image_mc.loadImage( item.urlSmall );
	}	
	
	/**
	* When image is loaded, update layout via onStageResize 
	* event handler, and fade in the image.
	*/
	private function onImageLoaded() {
		onStageResize();
		FTween.ease( image_mc, '_alpha', 100 );
	}
			
	/**
	* called from timeline root (or from MTASC)
	* 
	* makes root MC an instance of this class and calls the constructor
	*/
	static function main( timeline:MovieClip ) {
		ClassUtil.applyClassToObj( FlickrRecordsetTest, timeline );
	}
	
}