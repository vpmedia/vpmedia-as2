import ch.sfug.events.TimerEvent;
import ch.sfug.utils.AbstractTimer;

/**
 * this is a class to control repeating events. you can specify the delay between the events as the number of calls.
 * example:
 *
 * <pre>
 * import ch.sfug.utils.Timer;
 * import ch.sfug.events.TimerEvent;
 *
 * var t:Timer = new Timer(  );
 * t.addEventListener( TimerEvent.TIMER, count, this );
 * t.addEventListener( TimerEvent.TIMER_COMPLETE, count, this );
 *
 * function count( e:TimerEvent ):Void {
 * 	var timer = Timer( e.target );
 * 	trace( timer.currentCount );
 * }
 *
 * t.start( true ); // will start the timer and execute the first event immediately
 * t.stop(); // stops the timer without reseting the execution counter
 * t.reset(); // will reset the number of executions
 *
 * </pre>
 *
 * @author mich
 */
class ch.sfug.utils.Timer extends AbstractTimer {

	private var d:Number;
	private var id:Number;

	public function Timer( delay:Number, repeatCount:Number ) {
		super( repeatCount );
		if( delay != undefined && !isNaN( delay ) ) {
			this.delay = delay;
		} else {
			trace( "you have to specify a delay time for the Timer" );
		}
	}

	/**
	 * starts the timer to fire the timer events
	 * @param startNow if false the timer waits the first delay to evoke the first event. if true the first event will be fired before the first delay.
	 */
	public function start( startNow:Boolean ):Void {
		if( !this.r ) {
			if( current < count || count == 0 ) {
				this.id = setInterval( this, "fire", d );
				super.start();
				if( startNow ) this.fire();
			} else {
				dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) );
			}
		}
	}

	/**
	 * stops the timer to fire the events. will not reset the currentCount to 0
	 */
	public function stop(  ):Void {
		clearInterval( id );
		super.stop();
	}

	/**
	 * catch the event from the interval to dispatch the event
	 */
	private function fire(  ):Void {
		current++;
		if( current < count || count == 0 ) {
			dispatchEvent( new TimerEvent( TimerEvent.TIMER ) );
		} else {
			this.stop();
			dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) );
		}
	}

	/**
	 * returns the delay between the events in milliseconds
	 */
	public function get delay(  ):Number {
		return this.d;
	}


	/**
	 * sets the delay between the events in milliseconds
	 */
	public function set delay( dlay:Number ):Void {
		if( dlay > 0 ) {
			this.d = dlay;
		} else {
			trace( "the delay for the timer should be a number > 0 not: " + dlay );
		}
	}

}