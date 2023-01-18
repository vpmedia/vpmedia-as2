import ch.sfug.debug.DebugOutput;

import flash.external.ExternalInterface;

/**
 * @author loop
 */
class ch.sfug.debug.FirebugOutput implements DebugOutput {

	public function append( txt:String ):Void {
		callFirebug( "console.log", txt );
	}

	/**
	 * starts a timer
	 */
	public function startTimer( name:String ):Void {
		if( name == undefined ) name = "flashtimer";
		callFirebug( "console.time", name );
	}

	/**
	 * stops a timer
	 */
	public function stopTimer( name:String ):Void {
		if( name == undefined ) name = "flashtimer";
		callFirebug( "console.timeEnd", name );
	}

	/**
	 * calls the firebug javascript
	 */
	private function callFirebug( func:String, para:String ):Void {
		ExternalInterface.call( func, para );
	}



	public function clear() : Void {
		// nothing to clear - no api found for that
	}

}