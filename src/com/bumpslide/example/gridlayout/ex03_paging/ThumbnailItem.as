import com.bumpslide.core.BaseClip;
import com.bumpslide.util.Align;
import com.bumpslide.util.Debug;
import com.bumpslide.util.FTween;
import com.bumpslide.util.QueuedLoader;

/**
* Simple Grid Item 
* 
* _gridItemData and _gridItemIndex are given to us via 
* the initObj when this clip is attached by the GridLayout class
* 
* @author David Knape
*/
class ThumbnailItem extends BaseClip {
		
	// our grid item index and data
	private var _gridIndex:Number;
	private var _gridItemData:Object;
		
	// currently loaded image
	private var imageURL:String = undefined;
	
	// timeline clips
	public var bg_mc:MovieClip;
		
	public var image_mc:MovieClip;
	
	private var mcl:MovieClipLoader;
	
	static private var qloader:QueuedLoader;
	
	/**
	* onload, update our display
	*/ 
	private function onLoad() : Void {
		super.onLoad();
		
		if(qloader==undefined) qloader = new QueuedLoader();
		
		//mcl = new MovieClipLoader();
		//mcl.addListener( this );
		
		createEmptyMovieClip('image_mc', 1);
		image_mc._alpha = 0;
		
		update();
	}
	
	/**
	* updates the display for this clip
	*/ 
	public function update() : Void {
		
		// only reload if the URL really changed
		if( _gridItemData.urlThumb!=imageURL) {
						
			destroy();			
			
			// load current
			onEnterFrameCall( loadThumbnail );
		}
	}
	
	public function destroy() {
		
		FTween.stopTweening( image_mc );
		
		qloader.unloadItem( image_mc.holder_mc );
		
		image_mc._alpha = 0;
		image_mc.createEmptyMovieClip('holder_mc', 1);	
		
		// unload previous
		//mcl.unloadClip( image_mc.holder_mc );			
						
		imageURL = undefined;
		
		//image_mc.holder_mc.removeMovieClip();
		//delete image_mc.holder_mc;
		//image_mc.createEmptyMovieClip('holder_mc', 1);
		
	}
	
	/**
	* loads thumbnail into image holder
	*/
	public function loadThumbnail() {
		
		// save currently loaded URL
		imageURL = _gridItemData.urlThumb;
		
		image_mc._alpha = 0;
		image_mc.createEmptyMovieClip('holder_mc', 1);	
				
		if( imageURL!=undefined ) {
			//mcl.loadClip( imageURL, image_mc.holder_mc  );
			qloader.loadItem( image_mc.holder_mc, imageURL, null, onComplete, this );
		}
	}
	
	private function onComplete() {
		//if(imageURL==undefined) return;
		onEnterFrameCall( onLoadInit );
	}
	
	/**
	* Once image is loaded, center it
	*/
	private function onLoadInit() {
		
		// see if we've been destroyed
		//if(imageURL==undefined) return;
		
		Align.center( image_mc, 104 );
		Align.middle( image_mc, 104 );
				
		FTween.ease( image_mc, '_alpha', 100 );
	}
}