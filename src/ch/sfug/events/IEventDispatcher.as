import ch.sfug.events.Event;
/**
 * @author mich
 */
interface ch.sfug.events.IEventDispatcher {

	public function dispatchEvent( e:Event ):Void;
	public function addEventListener( type:String, func:Function, obj:Object ):Void;
	public function removeEventListener( type:String, func:Function, obj:Object ):Void;

}