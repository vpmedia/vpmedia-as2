import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplay;
import com.bourre.transitions.BasicTweenFLV;
import com.bourre.transitions.ITween;
import com.bourre.transitions.ITweenListener;
import com.bourre.transitions.TweenEvent;
import com.bourre.transitions.TweenEventType;

class com.bourre.transitions.TweenFLV 
	extends BasicTweenFLV
	implements ITween
{
	//-------------------------------------------------------------------------
	// Events definition
	//-------------------------------------------------------------------------
	
	/**
	 * Broadcasted to listeners when tween starts.<br>
	 */
	[Event("onStart")]
	public static var onStartEVENT:TweenEventType = TweenEventType.onStartEVENT;
	
	/**
	 * Broadcasted to listeners when tween stops.<br>
	 */
	[Event("onStop")]
	public static var onStopEVENT:TweenEventType = TweenEventType.onStopEVENT;
	
	/**
	 * Broadcasted to listeners when tween is finished.<br>
	 */
	[Event("onMotionFinished")]
	public static var onMotionFinishedEVENT:TweenEventType = TweenEventType.onMotionFinishedEVENT;
	
	/**
	 * Broadcasted to listeners when property value is updated.<br>
	 */
	[Event("onMotionChanged")]
	public static var onMotionChangedEVENT:TweenEventType = TweenEventType.onMotionChangedEVENT;
	
	private var _oEB:EventBroadcaster;

	private var _eOnMotionChangedEvent : TweenEvent;
	private var _eOnMotionFinishedEvent : TweenEvent;
	private var _eOnMotionStartEvent : TweenEvent;
	private var _eOnMotionStopEvent : TweenEvent;
	
	public function TweenFLV( vd : VideoDisplay, offset : Number, oT, sP, nEnd:Number, nMs:Number, nStart:Number, fE:Function)
	{
		super(vd, offset, oT, sP, nEnd, nMs, nStart, fE);
		_oEB = new EventBroadcaster( this );
		
		_eOnMotionStartEvent = new TweenEvent(onStartEVENT, this);
		_eOnMotionStopEvent = new TweenEvent(onStopEVENT, this);
		_eOnMotionChangedEvent = new TweenEvent(onMotionChangedEVENT, this);
		_eOnMotionFinishedEvent = new TweenEvent(onMotionFinishedEVENT, this);
	}
	
	/**
	 * Adds listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   t.addListener(myListener);
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function addListener(oL:ITweenListener) : Void
	{
		_oEB.addListener(oL);
	}
	
	/**
	 * Removes listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   t.removeListener(myListener);
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function removeListener(oL:ITweenListener) : Void
	{
		_oEB.removeListener(oL);
	}
	
	/**
	 * Adds listener for specifical event.
	 * 
	 * <p>Example
	 * <code>
	 *   t.addEventListener( TweenFLV.onMotionFinishedEVENT, myListener );
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function addEventListener(e:TweenEventType, oL) : Void
	{
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	/**
	 * Removes listener for specifical event.
	 * 
	 * <p>Example
	 * <code>
	 *   t.removeEventListener( TweenFLV.onMotionFinishedEVENT, myListener );
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function removeEventListener(e:TweenEventType, oL) : Void
	{
		_oEB.removeEventListener(e, oL);
	}
	
	/**
	 * Starts tweening.
	 * 
	 * <p>{@link AbstractTween#start} overridding
	 */
	public function start() : Void
	{
		execute();
	}
	
	/**
	 * Stops tweening.
	 * 
	 * <p>{@link AbstractTween#stop} overridding
	 */
	public function stop() : Void
	{
		super.stop();
		_oEB.broadcastEvent( _eOnMotionStopEvent );
	}
	
	/**
	 * Starts tweening
	 * 
	 * <p>{@link com.bourre.commands.Command} polymorphism.
	 * 
	 * @see com.bourre.commands.Command
	 */
	public function execute( e : IEvent ) : Void
	{
		super.execute();
		_oEB.broadcastEvent( _eOnMotionStartEvent );
	}
	
	/**
	 *	Implemented to add tween as listener to another tween.
	 */
	public function onMotionFinished() : Void
	{
		execute();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _onMotionEnd() : Void
	{
		super._onMotionEnd();
		_oEB.broadcastEvent( _eOnMotionChangedEvent );
		_oEB.broadcastEvent( _eOnMotionFinishedEvent );
	}
	
	private function _onUpdate() : Void
	{
		super._onUpdate();
		_oEB.broadcastEvent( _eOnMotionChangedEvent );
	}
}