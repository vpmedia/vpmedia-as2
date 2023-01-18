import ch.sfug.events.EventDispatcher;
/**
 * @author loop
 */
class ch.sfug.anim.AbstractAnimation extends EventDispatcher {

	private var _run:Boolean = false;

	/**
	 * starts the animation
	 */
	public function start(  ):Void {
		// abstract
	}

	/**
	 * stops the animation
	 */
	public function stop(  ):Void{
		// abstract
	}

	/**
	 * returns if the animation is running
	 */
	public function get running(  ):Boolean {
		return _run;
	}
}