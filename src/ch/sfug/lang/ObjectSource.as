import ch.sfug.lang.ILanguageSource;

/**
 * @author loop
 */
class ch.sfug.lang.ObjectSource implements ILanguageSource {

	private var _obj:Object;

	public function ObjectSource( obj:Object ) {
		this.object = obj;
	}

	/**
	 * returns variable value with the name keyword in the object
	 * @param keyword the name of the variable you need the value of
	 */
	public function get( keyword:String ):String {
		return String( _obj[ keyword ] );
	}

	/**
	 * sets/gets the object which variables acts as keyword sources
	 */
	public function set object( obj:Object ):Void {
		if( obj != undefined ) {
			this._obj = obj;
		}
	}
	public function get object(  ):Object {
		return this._obj;
	}

}