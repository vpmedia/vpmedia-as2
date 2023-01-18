import ch.sfug.events.MessageEvent;

/**
 * @author mich
 */
class ch.sfug.events.ErrorEvent extends MessageEvent {

	public static var ERROR:String = "error";

	public function ErrorEvent( type:String, message:String ) {
		super( type, message );
	}
}