import com.bourre.events.BasicEvent;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplay;
import com.bourre.medias.video.VideoDisplayEvent;
import com.bourre.transitions.IFrameBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.FLVBeacon 
	implements IFrameBeacon
{
	private var _oEB : EventBroadcaster;
	private var _bIsP:Boolean;
	private var _vd : VideoDisplay;
	private var _e : IEvent;

	public static var onEnterFrameEVENT:EventType = new EventType('onEnterFrame');
	public static var onChangeVideoDisplayEVENT:EventType = new EventType('onChangeVideoDisplay');

	public function FLVBeacon( vd : VideoDisplay )
	{
		_oEB = new EventBroadcaster( this );
		_bIsP = false;
		
		setVideoDisplay( vd );
	}

	public function onPlayHeadTimeChange(e : VideoDisplayEvent) : Void
	{
		_oEB.broadcastEvent( _e );
	}

	public function getVideoDisplay() : VideoDisplay
	{
		return _vd;
	}
	
	public function setVideoDisplay( vd : VideoDisplay ) : Void
	{
		stop();
		
		_vd = vd;
		_e = new VideoDisplayEvent( FLVBeacon.onEnterFrameEVENT, _vd );
		_oEB.broadcastEvent( new BasicEvent( FLVBeacon.onChangeVideoDisplayEVENT ) );
		
		start();
	}

	public function start() : Void
	{
		_vd.addEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
		_bIsP = true;
	}

	public function stop() : Void
	{
		_vd.removeEventListener( VideoDisplay.onPlayHeadTimeChangeEVENT, this );
		_bIsP = false;
	}
	
	public function isPlaying() : Boolean
	{
		return _bIsP;
	}

	public function addFrameListener( oL : IFrameListener ) : Void
	{
		_oEB.addListener( oL );
	}

	public function removeFrameListener( oL : IFrameListener ) : Void
	{
		_oEB.removeListener( oL );
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