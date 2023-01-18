/**
 * an interface that defines an interface for all logger output class that writes the log somewhere *
 * @author $LastChangedBy: $
 * @version $LastChangedRevision: $
 */
interface ch.sfug.debug.DebugOutput {

	/**
	 * appends to the log
	 */
	public function append( txt:String ):Void;

	/**
	 * clears the logoutput
	 */
	public function clear(  ):Void;

}