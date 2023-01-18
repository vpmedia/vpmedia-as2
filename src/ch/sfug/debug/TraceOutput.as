import ch.sfug.debug.DebugOutput;

/**
 * a logger class for flash trace <br>
 *
 * @author $LastChangedBy: $
 * @version $LastChangedRevision: $
 */
class ch.sfug.debug.TraceOutput implements DebugOutput {

	public function TraceOutput() {

	}

	/**
	 * implements interface
	 */
	public function append( txt:String ):Void {
		trace( txt );
	}

	/**
	 * implements interface
	 */
	public function clear(  ):Void {
		// cant clear output window - nothing to do
	}

}