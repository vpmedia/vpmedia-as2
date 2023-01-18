/**
 * is a wrapper for slideshow images. stores the url and the delay of the image.
 * @author loop
 */
class ch.sfug.widget.slideshow.SlideshowImage {

	public static var DELAY:Number = 3000;

	private var d:Number;
	private var _url:String;

	public function SlideshowImage( url:String, delay:Number ) {
		if( url == undefined ) trace( "you have to specify an url for a slideshow image" );
		d = ( delay == undefined ) ? DELAY : delay;
		this._url = url;
	}


	/**
	 * returns the url of the image
	 */
	public function get url(  ):String {
		return _url;
	}

	/**
	 * returns the delay of the image
	 */
	public function get delay(  ):Number {
		return d;
	}


}