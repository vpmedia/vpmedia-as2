import ch.sfug.events.EventDispatcher;
/**
 * combines the Timer and EnterFrame eventdispatcher to a common interface
 * @author loop
 */
class ch.sfug.utils.AbstractTimer extends EventDispatcher {

	private var current:Number;
	private var count:Number;
	private var r:Boolean;

	public function AbstractTimer( repeatCount:Number ) {
		this.count = ( repeatCount >= 0 && repeatCount != undefined && !isNaN( repeatCount ) ) ? repeatCount : 0;
		r = false;
		reset();
	}

	/**
	 * starts the timer to fire the timer events
	 * @param startNow if false the timer waits the first delay to evoke the first event. if true the first event will be fired before the first delay.
	 */
	public function start( ):Void {
		this.r = true;
		// abstract
	}

	/**
	 * stops the timer to fire the events. will not reset the currentCount to 0
	 */
	public function stop(  ):Void {
		this.r = false;
		// abstract
	}

	/**
	 * resets the counter of the events to 0
	 */
	public function reset(  ):Void {
		current = 0;
	}

	/**
	 * returns true if the timer is running otherwise false
	 */
	public function get running(  ):Boolean {
		return r;
	}

	/**
	 * returns the number of times the timer fires the event
	 */
	public function get currentCount(  ):Number {
		return this.current;
	}

	/**
	 * returns the number of times the timer has to fire the event
	 */
	public function get repeatCount(  ):Number {
		return this.count;
	}

	/**
	 * sets the number of times the timer has to fire the event
	 */
	public function set repeatCount( num:Number ) {
		if( num > -1  && !isNaN( num ) ) {
			this.count = num;
		} else {
			trace( "wrong number of repeatCount: " + num );
		}
	}
}