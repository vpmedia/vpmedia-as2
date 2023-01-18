import ch.sfug.controls.EventButton;
import ch.sfug.events.Event;
/**
 * @author loop
 */
class ch.sfug.events.ButtonGroupEvent extends Event {

	public static var ACTIVATE:String = "activate";
	public static var DEACTIVATE:String = "deactivate";

	private var _button:EventButton;

	public function ButtonGroupEvent( type:String, button:EventButton ) {
		super( type );
		this._button = button;
	}

	/**
	 * returns the button that is deactivated or activated
	 */
	public function get button(  ):EventButton {
		return this._button;
	}

}