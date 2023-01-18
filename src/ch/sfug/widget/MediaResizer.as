import ch.sfug.events.Event;
import ch.sfug.net.loader.MediaLoader;
import ch.sfug.widget.BaseWidget;

/**
 * with the mediaresizer class you can load media with the builtin medialoader and display it with different resize modes. <br>
 * the MediaResizer it self has a width and a height and will resize the loaded content depending on the resizemode. there are three different resize modes:<br/>
 * MediaResizer.NONE will not scale the image at all and just crop the image parts that bigger than the width and height of the of the MediaResizer.<br/>
 * MediaResizer.FIT will excactly fit the loaded content into the MediaResizer width and height with no aspect of the ratio
 * MediaResizer.RATIO will resize the image into the MediaResizer with respect of the ratio. the loaded content will be on one side smaller if it doesnt excactly fit.</br>
 * MediaResizer.MASK will respect the ratio but cut the parts that are to big to display.<br/> 
 * 
 * <pre>
 * // simple usage example
 * 
 * var mr:MediaResizer = new MediaResizer( mc/to/display/media, MediaResizer.MASK )
 * mr.loader.load( "url/to/image" );
 * 
 * </pre> *
 * @see ch.sfug.net.loader.MediaLoader
 * @author loop
 */
class ch.sfug.widget.MediaResizer extends BaseWidget {

	private var _loader:MediaLoader;
	private var rmode:String;

	public static var NONE:String = "none";
	public static var FIT:String = "fit";
	public static var RATIO:String = "ratio";
	public static var MASK:String = "mask";

	public function MediaResizer( mc:MovieClip, mode:String ) {
		super( mc );

		mc.createEmptyMovieClip( "holder", 1 );
		mc.holder.createEmptyMovieClip( "image", 1 );

		// create default sized mask for maskmode.
		var cut:MovieClip = mc.createEmptyMovieClip( "cutter", 2 );
		var w:Number = ( super.width != 0 ) ? super.width : 100;
		var h:Number = ( super.height != 0 ) ? super.height : 100;
		cut.beginFill( 0 );
		cut.lineTo( w, 0 );
		cut.lineTo( w, h );
		cut.lineTo( 0, h );
		cut.lineTo( 0, 0 );
		cut.endFill();

		mc.holder.setMask( cut );

		this.resizemode = ( mode != undefined ) ? mode : MediaResizer.RATIO;

		_loader = new MediaLoader( "", mc.holder.image );
		_loader.addEventListener( Event.INIT, onInit, this );
	}

	/**
	 * returns the media loader
	 */
	public function get loader(  ):MediaLoader {
		return this._loader;
	}

	/**
	 * will set the resize mode.
	 * @param mode one of the possible resize types: MediaResizer.NONE, MediaResizer.FIT, MediaResizer.RATIO, MediaResizer.MASK
	 */
	public function set resizemode( mode:String ):Void {
		if( mode == MediaResizer.NONE || mode == MediaResizer.FIT || mode == MediaResizer.RATIO || mode == MediaResizer.MASK || mode != undefined ) {
			this.rmode = mode;
			align();
		}
	}


	/**
	 * abstract getter/setter functions function
	 */
	public function set width( num:Number ):Void {
		super.width = num;
		mc.cutter._width = num;
		align();
	}
	public function set height( num:Number ):Void {
		super.height = num;
		mc.cutter._height = num;
		align();
	}

	/**
	 * aligns the image inside the size box specified by the widget width, height properies
	 */
	private function align(  ):Void {

		var holder:MovieClip = mc.holder;

		var rw:Number = 1;
		var rh:Number = 1;
		var orgH:Number = originalHeight;
		var orgW:Number = originalWidth;
		var w:Number = super.width;
		var h:Number = super.height;

		holder._x = 0;
		holder._y = 0;

		switch ( rmode) {
			case MediaResizer.FIT :
				rw = w/orgW;
				rh = h/orgH;
				break;
			case MediaResizer.MASK :
				rw = ( h/orgH > w/orgW ) ? ( h/orgH ) : ( w/orgW );
				rh = ( h/orgH > w/orgW ) ? ( h/orgH ) : ( w/orgW );
				holder._x = Math.round( ( w - ( orgW * rw ) ) / 2 );
				holder._y = Math.round( ( h - ( orgH * rh ) ) / 2 );
				break;
			case MediaResizer.RATIO :
				rw = ( h/orgH < w/orgW ) ? ( h/orgH ) : ( w/orgW );
				rh = ( h/orgH < w/orgW ) ? ( h/orgH ) : ( w/orgW );
				holder._x = Math.round( ( w - ( orgW * rw ) ) / 2 );
				holder._y = Math.round( ( h - ( orgH * rh ) ) / 2 );
				break;
		}
		holder._xscale = 100*rw;
		holder._yscale = 100*rh;
	}

	private function onInit():Void {
		mc.cutter._height = height;
		mc.cutter._width = width;
		align();
	}

	/**
	 * returns the original ( no scaling ) width and height of the loaded image.
	 */
	public function get originalHeight(  ):Number {
		var holder:MovieClip = mc.holder;
		var orgs:Number = holder._yscale;
		holder._yscale = 100;
		var h:Number = holder._height;
		holder._yscale = orgs;
		return h;
	}
	public function get originalWidth(  ):Number {
		var holder:MovieClip = mc.holder;
		var orgs:Number = holder._xscale;
		holder._xscale = 100;
		var w:Number = holder._width;
		holder._xscale = orgs;
		return w;
	}

}