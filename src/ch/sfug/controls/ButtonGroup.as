import ch.sfug.controls.EventButton;
import ch.sfug.events.ButtonEvent;
import ch.sfug.events.ButtonGroupEvent;
import ch.sfug.events.EventDispatcher;

/**
 * will group different eventbuttons so only on can be active.
 * @author loop
 */
class ch.sfug.controls.ButtonGroup extends EventDispatcher {

	private var _active:EventButton;
	private var _buttons:Array;

	public function ButtonGroup() {
		super();
		_buttons = new Array();
	}

	/**
	 * adds a button to the group of buttons
	 */
	public function addButton( but:EventButton ):Void {
		but.addEventListener( ButtonEvent.RELEASE, onButtonRelease, this );
		_buttons.push( but );
	}

	/**
	 * will be called if a button of the group is pressed
	 */
	private function onButtonRelease( e:ButtonEvent ):Void {
		var but:EventButton = e.target;
		// deactive the active one
		deactivate();
		//activate the current
		but.enabled = false;
		_active = but;
		dispatchEvent( new ButtonGroupEvent( ButtonGroupEvent.ACTIVATE, but ) );
	}

	/**
	 * deactivate the active button
	 */
	public function deactivate(  ):Void {
		_active.enabled = true;
		dispatchEvent( new ButtonGroupEvent( ButtonGroupEvent.DEACTIVATE, _active ) );
		_active = undefined;
	}

	/**
	 * activates the passed button
	 */
	public function activate( eb:EventButton ):Void {
		for (var i : Number = 0; i < _buttons.length; i++) {
			var b:EventButton = EventButton( _buttons[ i ] );
			if( b == eb ) _active = eb;
		}

		if( _active != eb ) {
			trace( "button: " + eb + " should be in the buttongroup to activate" );
		} else {
			_active.dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE ) );
		}
	}

	/**
	 * overwrite super function
	 */
	public function set enabled( state:Boolean ):Void {
		for (var i : Number = 0; i < _buttons.length; i++) {
			var b:EventButton = EventButton( _buttons[ i ] );
			if( b != active ) b.enabled = state;
		}
		super.enabled = state;
	}

	/**
	 * returns all the eventbuttons in the buttongroup
	 */
	public function get buttons(  ):Array {
		return _buttons;
	}

	/**
	 * returns the active button
	 */
	public function get active(  ):EventButton {
		return _active;
	}
}