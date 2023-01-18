import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplay;
import com.bourre.medias.video.VideoDisplayEvent;
import com.bourre.visual.MovieClipHelper;

class com.bourre.visual.VideoLoggerUI 
	extends MovieClipHelper 
{
	private var _tf : TextField;
	private var _fmt : TextFormat;
	private var _video : VideoDisplay;
	
	public static var DEFAULT_ID : String = "VideoLoggerUI";
	public static var DEFAULT_DEPTH : Number = 9994;
	public static var DEFAULT_MESSAGE : String = "Video Timestamp: ";	public static var DEFAULT_TEXTCOLOR : Number = 0x000000;

	public function VideoLoggerUI ( target : MovieClip, depth : Number, id : String )
	{
		super( id?id:VideoLoggerUI.DEFAULT_ID, target?target:_level0 );
		
		view = view.createEmptyMovieClip( "__mc_VideoLoggerUI", depth?depth:VideoLoggerUI.DEFAULT_DEPTH );
		view.createTextField( "__tf_VideoLoggerUI", 0, 0, 0, 100, 22 );
		_tf = view.__tf_VideoLoggerUI;
		_tf.autoSize = "left";
		
		_init();
	}
	
	private function _init() : Void
	{
		setTextFormat( new TextFormat( "verdana", 12, VideoLoggerUI.DEFAULT_TEXTCOLOR ) );
		_display(0);
	}
	
	public function setVideoDisplay( video : VideoDisplay ) : Void
	{
		if ( isVisible() ) _video.removeEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
		_video = video;
		if ( isVisible() ) _video.addEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
	}
	
	public function show() : Void
	{
		_video.addEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
		super.show();
	}
	
	public function hide() : Void
	{
		_video.removeEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
		super.hide();
	}
	
	public function setTextFormat( fmt : TextFormat ) : Void
	{
		_fmt = fmt;
		_tf.setTextFormat( _fmt );
	}
	
	private function _display( n : Number ) : Void
	{
		_tf.text = VideoLoggerUI.DEFAULT_MESSAGE + n.toString();
		_tf.setTextFormat( _fmt );
	}

	public function onPlayHeadTimeChange( e : VideoDisplayEvent ) : Void 
	{
		_display( e.getPlayheadTime() );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}