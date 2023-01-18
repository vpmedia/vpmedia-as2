import ch.sfug.lang.ILanguageSource;
import ch.sfug.utils.XPath;

/**
 * @author loop
 */
class ch.sfug.lang.XMLSource implements ILanguageSource {

	private var _node:XMLNode;

	public function XMLSource( xml:XMLNode ) {
		this.node = xml;
	}

	/**
	 * returns the content of a xml node
	 * @param xpath an xpath string that addresses a xml node
	 */
	public function get( xpath:String ):String {
		return XPath.getValue( xpath, _node );
	}

	/**
	 * sets/gets the xml node where the xpath command will be called on
	 */
	public function set node( xml:XMLNode ):Void {
		if( xml != undefined ) {
			this._node = xml;
		}
	}
	public function get node(  ):XMLNode {
		return this._node;
	}

}