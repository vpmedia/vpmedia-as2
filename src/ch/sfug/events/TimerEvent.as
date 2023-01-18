import ch.sfug.events.Event;

/**
 * @author mich
 */
class ch.sfug.events.TimerEvent extends Event {

	public static var TIMER:String = "timer";
	public static var TIMER_COMPLETE:String = "timercomplete";

	public function TimerEvent( type:String ) {
		super(type);
	}

}