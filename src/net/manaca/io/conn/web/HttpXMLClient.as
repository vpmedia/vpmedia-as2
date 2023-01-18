import net.manaca.lang.BObject;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-3-28
 */
class net.manaca.io.conn.web.HttpXMLClient extends BObject {
	private var className : String = "net.manaca.io.conn.web.HttpXMLClient";
	private var _xml:XML;
	public function HttpXMLClient() {
		super();
		_xml = new XML();
	}
	public function send(url:String) : Boolean{
		return null;
	}

}