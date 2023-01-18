import ch.sfug.anim.AbstractAnimation;
import ch.sfug.events.AnimationEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.utils.Timer;

/**
 * @author loop
 */
class ch.sfug.anim.Break extends AbstractAnimation {

	private var timer:Timer;

	/**
	 * creates a break for the animation chain
	 */
	public function Break( delay:Number ) {
		super();
		this.timer = new Timer( delay, 1 );
		timer.addEventListener( TimerEvent.TIMER_COMPLETE, stop, this );
	}

	public function start( ):Void {
		_run = true;
		timer.start();
	}

	public function stop():Void {
		_run = false;
		timer.reset();
		dispatchEvent( new AnimationEvent( AnimationEvent.STOP ) );
	}

	/**
	 * starts the break with a new delay
	 */
	public function delay( msec:Number ):Void {
		timer.delay = msec;
		start();
	}

	/**
	 * sets/gets the duration of the break
	 */
	public function set duration( d:Number ):Void {
		timer.delay = d;
	}
	public function get duration(  ):Number {
		return timer.delay;
	}
}