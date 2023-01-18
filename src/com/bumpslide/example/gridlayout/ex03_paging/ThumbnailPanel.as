import com.bumpslide.core.BaseClip;
import com.bumpslide.services.FlickrServiceProxy;
import com.bumpslide.services.ServiceEvent;
import com.bumpslide.util.Align;
import com.bumpslide.util.StageProxy;
import mx.controls.Button;
import mx.controls.TextInput;

class ThumbnailPanel extends BaseClip {
	
	public var thumbnailgrid_mc:ThumbnailGrid;
	public var search_txt:TextInput;
	public var search_btn:Button;
	public var controls_mc:GridControls;
	
	
	private var mWidth:Number;
		
	/**
	* onLoad, initialize the controls
	* 
	*/
	function onLoad() {
		super.onLoad();		
		
		// use the smooth resize mode
		stage.eventMode = StageProxy.PASS_THRU;
		stage.minHeight = 200;
		
		// initialize service proxy
		flickr = FlickrServiceProxy.getInstance();
		flickr.addEventListener( FlickrServiceProxy.EVENT_TAG_SEARCH_COMPLETE, d( onSearchComplete ) );	
		
		// hook up the search button
		search_btn.onRelease = d( doSearch );
		search_txt.enterOnKeyDown = d( doSearch );
		
		// tell controls which gridLayout instance to control
		controls_mc.grid = thumbnailgrid_mc.grid;
		
		search_txt.text = "code";
	}
	
	/**
	* StageProxy resize handler 
	*/
	function onStageResize() {
		
		mWidth = stage.width - 20;
		
		// align controls to the right
		Align.right( controls_mc,  mWidth );
		
		// size the grid 
		thumbnailgrid_mc.setSize( mWidth, stage.height - 135 );		
	}
	
	
	function doSearch() {
		flickr.tagSearch( search_txt.text );
	}
	
	function onSearchComplete(e:ServiceEvent) {
		thumbnailgrid_mc.dataProvider = e.result;
	}
	
	private var flickr:FlickrServiceProxy;
	
}