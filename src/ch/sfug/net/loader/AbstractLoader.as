import ch.sfug.events.EventDispatcher;
/**
 * @author loop
 */
class ch.sfug.net.loader.AbstractLoader extends EventDispatcher {

	private var _url:String;

	/**
	 * creates a loader that stores the url to load from
	 */
	public function AbstractLoader( url:String ) {
		this.url = url;
	}

	/**
	 * sets the url to load from
	 */
	public function set url( u:String ):Void {
		if( u != undefined && u.length > 0 ) {
			this._url = u;
		}
	}

	/**
	 * returns the url
	 */
	public function get url(  ):String {
		return this._url;
	}

	/**
	 * ABSTRACT function that starts the load progress
	 *
	 */
	public function load( url:String ):Void {
		// abstract
	}

}