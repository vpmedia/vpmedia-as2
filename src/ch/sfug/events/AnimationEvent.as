import ch.sfug.events.Event;

/**
 * @author loop
 */
class ch.sfug.events.AnimationEvent extends Event {

	public static var START:String = "anim_start";
	public static var STOP:String = "anim_stop";
	public static var UPDATE:String = "anim_update";

	public function AnimationEvent(type : String) {
		super(type);
	}

}