/**
* Singleton class that observes the user's interaction with
* the <code>_root</code> MovieClip and dispatches an <code>IdleEvent</code>
* instance for every 5 seconds during which the user has not performed any
* interaction. It also dispatches an event as soon as a user interaction was
* perceived after an idle period. In that case <code>IdleEvent.getIdleSeconds()</code>
* returns a number < 0.
* @author Stefan Thurnherr
*/
import ch.sfug.events.EventDispatcher;
import ch.sfug.events.IdleEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.utils.Timer;

class ch.sfug.utils.IdleWatcher extends EventDispatcher{

	private static var instance:IdleWatcher;
	private static var IDLEINTERVAL:Number = 5000; // milliseconds.
	private static var CHECKINTERVAL:Number = 1000; // milliseconds;

	private var countdown:Number;
	private var totalIdleTime:Number;
	private var myTimer:Timer;

	private function IdleWatcher(){
		super();
		this.totalIdleTime = -1;
		this.myTimer = new Timer(CHECKINTERVAL, 0); // 0 means no repeat limit.
		this.myTimer.addEventListener(TimerEvent.TIMER, onTimedOut, this);
		//trace("IdleWatcher::constructor: Instance created.");
	}

	/**
	* Get the Singleton instance.
	* @return the Singleton instance.
	*/
	public static function getInstance():IdleWatcher {
		if (instance == undefined){
			instance = new IdleWatcher();
		}
		return instance;
	}

	/**
	* Check whether or not the <code>IdleWatcher</code> instance
	* has already been started.
	* @return A <code>bool</code> value that is <code>true</code>
	* iif the <code>IdleWatcher</code> instance is already running
	* and dispatching <code>IdleEvent</code> instances.
	*/
	public function get isRunning():Boolean {
		return this.myTimer.running;
	}

	/**
	* Start the <code>IdleWatcher</code>. Once started it will
	* dispatch <code>IdleEvent</code> instances.
	*/
	public function start():Void {
		//trace("IdleWatcher::start().");
		this.countdown = IDLEINTERVAL;
		this.totalIdleTime = 0;
		this.myTimer.start(false);
		Mouse.addListener(this);
		Key.addListener(this);
	}

	/**
	* Used class-internally; called regularly, checks whether
	* <code<IDLEINTERVAL</code> has elapsed. If yes dispatches
	* an <code>IdleEvent</code>.
	*/
	private function onTimedOut():Void {
		//trace("IdleWatcher::onTimedOut().");
		this.countdown -= CHECKINTERVAL;
		if (this.countdown <= 0){
			this.totalIdleTime += IDLEINTERVAL;
			//trace("\n   dispatching IDLEEVENT - idle since [" + (this.totalIdleTime) + "] seconds.");
			this.dispatchEvent(new IdleEvent( IdleEvent.IDLE, this.totalIdleTime ) );
			this.countdown = IDLEINTERVAL;
		}
	}

	/**
	* Stops the <code>IdleWatcher</code> instance. No more
	* <code>IdleEvent</code> instances will be dispatched until
	* <code>IdleWatcher</code> the instance is started again.
	*/
	public function stop():Void {
		this.myTimer.stop();
		Mouse.removeListener(this);
		Key.removeListener(this);
	}


	/**
	* Used internally: Called by all event handlers (onMouseMove etc.) to indicate
	* that the user has performed an interaction with the application and is thus
	* not idle anymore.
	*/
	private function resetIsIdle():Void {
		this.countdown = IDLEINTERVAL;
		if (this.totalIdleTime > 0){
			//trace("IdleWatcher::resetIsIdle(): dispatching an IdleEvent for 0 seconds (idle since >[" + this.totalIdleTime + "] seconds).");
			this.dispatchEvent(new IdleEvent(IdleEvent.IDLE, -1));
		}
		this.totalIdleTime = 0;
	}

	/** Partial implementations of the (for AS2 non-existing) MouseListener and KeyListener interfaces. */

	public function onMouseMove():Void {
		this.resetIsIdle();
	}

	public function onMouseDown():Void {
		this.resetIsIdle();
	}

	public function onKeyDown():Void {
		this.resetIsIdle();
	}
}