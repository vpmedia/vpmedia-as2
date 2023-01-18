import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;
import com.bourre.visual.MovieClipHelper;

class com.bourre.visual.FPSLoggerUI 
	extends MovieClipHelper 
	implements IFrameListener
{

	private var _ms : Number;
	private var _fps : Number;
	private var _tf : TextField;
	private var _fmt : TextFormat;
	
	public static var DEFAULT_ID : String = "FPSLoggerUI";
	public static var DEFAULT_DEPTH : Number = 9995;
	public static var DEFAULT_MESSAGE : String = "Current FPS: ";
	public static var DEFAULT_TEXTCOLOR : Number = 0x000000;
	
	public function FPSLoggerUI ( target : MovieClip, depth : Number, id : String )
	{
		super( id?id:FPSLoggerUI.DEFAULT_ID, target? target:_level0 );
		
		view = view.createEmptyMovieClip( "__mc_FPSLoggerUI", depth?depth:FPSLoggerUI.DEFAULT_DEPTH );
		view.createTextField( "__tf_FPSLoggerUI", 0, 0, 0, 100, 22 );
		_tf = view.__tf_FPSLoggerUI;
		_tf.autoSize = "left";

		_init();
	}
	
	public function show() : Void
	{
		FPSBeacon.getInstance().addFrameListener( this );
		super.show();
	}
	
	public function hide() : Void
	{
		FPSBeacon.getInstance().removeFrameListener( this );
		super.hide();
	}
	
	public function setTextFormat( fmt : TextFormat ) : Void
	{
		_fmt = fmt;
		_tf.setTextFormat( _fmt );
	}
	
	private function _init() : Void
	{
		_ms = getTimer();
		_fps = 0;
		_display( 0 );
		setTextFormat( new TextFormat( "verdana", 12, FPSLoggerUI.DEFAULT_TEXTCOLOR ) );
		
		show();
	}
	
	private function _display( n : Number ) : Void
	{
		_tf.text = FPSLoggerUI.DEFAULT_MESSAGE + n.toString();
		_tf.setTextFormat( _fmt );
	}
	
	public function onEnterFrame() : Void
	{
		if( getTimer() - 1000 > _ms )
		{
			_ms = getTimer();
			_display(_fps);
			_fps = 0;
		}
		else
		{
			++_fps;
		}
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