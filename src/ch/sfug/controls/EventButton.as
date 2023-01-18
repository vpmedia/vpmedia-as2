import ch.sfug.events.ButtonEvent;
import ch.sfug.events.EventDispatcher;

/**
 * simple wrappes a mc to a button where you can enable/disable the button ability
 *
 * <pre>
 * // to turn a movieclip into an eventbutton do the following
 * var but:EventButton = new EventButton( path.to.movieclip );
 *
 * // now you can add eventlisteners on button events:
 * but.addEventListener( ButtonEvent.RELEASE, onRelease, this );
 * // this will call the onRelease function in the same class as you write the code as soon as the button/specified mc will be released
 *
 * </pre>
 * @see ch.sfug.events.ButtonEvent
 * @author loop
 */
class ch.sfug.controls.EventButton extends EventDispatcher {

	private var mc:MovieClip;
	private var _cursor:Boolean = true;

	/**
	 * creates a buttons out of the movieclip
	 * @param mc the movieclip that has to be a button
	 * @param cur a boolean that defines if the button uses a handcursor or not.
	 */
	public function EventButton( mc:MovieClip, cur:Boolean ) {
		super();
		target = mc;
		cursor = cur;
	}

	/**
	 * enables the button
	 */
	public function set enabled( b:Boolean ):Void {
		super.enabled = b;
		if( b ) {
			var t:EventDispatcher = this;
			this.mc.onPress = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.PRESS ) );
			};
			this.mc.onRelease = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE ) );
			};
			this.mc.onReleaseOutside = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.RELEASEOUTSIDE ) );
			};
			this.mc.onDragOut = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.DRAGOUT ) );
			};
			this.mc.onDragOver = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.DRAGOVER ) );
			};
			this.mc.onRollOut = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.ROLLOUT ) );
			};
			this.mc.onRollOver = function() {
				t.dispatchEvent( new ButtonEvent( ButtonEvent.ROLLOVER ) );
			};
		} else {
			delete this.mc.onDragOut;
			delete this.mc.onDragOver;
			delete this.mc.onPress;
			delete this.mc.onRelease;
			delete this.mc.onReleaseOutside;
			delete this.mc.onRollOut;
			delete this.mc.onRollOver;
		}
	}


	/**
	 * sets/gets the target mc of the button
	 */
	public function get target(  ):MovieClip {
		return this.mc;
	}
	public function set target( mc:MovieClip ):Void {
		this.mc = mc;
		this.mc.useHandCursor = _cursor;
		if( enabled ) enabled = true;
		this.mc.stop();
	}

	/**
	 * sets/gets the useHandCursor settings
	 */
	public function get cursor(  ):Boolean {
		return this._cursor;
	}
	public function set cursor( useHandCursor:Boolean ):Void {
		if( useHandCursor != undefined ) this._cursor = useHandCursor;
		this.target.useHandCursor = _cursor;
	}

	public function toString():String {
		return "EventButton: " + target;
	}

}