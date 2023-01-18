/**
Component Base
@version 1.0
@since 27/11/2005
@author Shane McCartney - shanem@flashdynamix.com
@description  Used for dispatching events model with FlashDynamix components
*/
import com.FlashDynamix.events.Event;
import com.FlashDynamix.core.Dispatcher;
//
dynamic class com.FlashDynamix.core.Base extends MovieClip {
	private var caller:Dispatcher;
	/**
	@ignore
	*/
	private function Base() {
		caller = new Dispatcher();
		init();
		this.onEnterFrame = function () {
			draw();
			delete this.onEnterFrame;
		};
	}
	/**
	* A class init event
	*/
	private function init():Void {
	}
	/**
	* A draw event which may be used by MovieClip extended classes
	*/
	private function draw():Void {
	}
	public function removeListeners() {
		caller.removeListeners();
	}
	public function addListener(t:String, e:Object) {
		caller.addListener(t, e);
	}
	public function addListeners(e:Object) {
		caller.addListeners(e);
	}
	public function removeListener(t:String) {
		caller.removeListener(t);
	}
	public function dispatchEvent(e:Event) {
		caller.dispatchEvent(e);
	}
}
