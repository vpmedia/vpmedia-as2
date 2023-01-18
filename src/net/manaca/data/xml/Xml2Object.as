 /**
 * 功能：将XML转为Object
 * 使用：parseXML(xml);
 * 
 * @author Wersling
 * @version 1.0, 2005-8-29
 * @updatelist 2005-8-29, Wersling, 
*/
class net.manaca.data.xml.Xml2Object extends XML
{
	private var oResult:Xml2Object = new Xml2Object ();
	private var oXML:XML;

	/**
	* @method get xml
	* @description return the xml passed in the parseXML method
	* @usage theXML = XML2Object.xml
	*/
	public function get xml():XML{
		return oXML;
	}
	/**
	* @method public parseXML
	* @description return the parsed Object
	* @usage XML2Object.parseXML( theXMLtoParse );
	* @param sFile XML
	* @returns an Object with the contents of the passed XML
	*/
	public function parseXML (sFile:XML):Xml2Object {
		this.oResult = new Xml2Object ();
		this.oXML = sFile;
		this.oResult = this.translateXML();
		return this.oResult;
	}
	/**
	* @method private translateXML
	* @description core of the XML2Object class
	*/
	private function translateXML (from, path, name, position):Xml2Object {
		var nodes, node, old_path;
		if (path == undefined) {
			path = this;
			name = "oResult";
		}
		path = path[name];
		if (from == undefined) {
			from = new XML (this.xml.toString());
			from.ignoreWhite = true;
		}
		if (from.hasChildNodes ()) {
			nodes = from.childNodes;
			if (position != undefined) {
				var old_path = path;
				path = path[position];
			}
			while (nodes.length > 0) {
				node = nodes.shift ();
				if (node.nodeName != undefined) {
					var __obj__ = new Xml2Object ();
					__obj__.nodeName = node.nodeName;
					__obj__.attributes = node.attributes;
					__obj__.data = node.firstChild.nodeValue;
// 					if(__obj__.data == undefined) __obj__.data = "";
					if (position != undefined) {
						var old_path = path;
					}
					if (path[node.nodeName] != undefined) {
						if (path[node.nodeName].__proto__ == Array.prototype) {
							path[node.nodeName].push (__obj__);
							name = node.nodeName;
							position = path[node.nodeName].length - 1;
						} else {
							var copyObj = path[node.nodeName];
							path[node.nodeName] = new Array ();
							path[node.nodeName].push (copyObj);
							path[node.nodeName].push (__obj__);
							name = node.nodeName;
							position = path[node.nodeName].length - 1;
						}
					} else {
						path[node.nodeName] = __obj__;
						name = node.nodeName;
						position = undefined;
					}
				}
				if (node.hasChildNodes ()) {
					this.translateXML (node, path, name, position);
				}
			}
		}
		return this.oResult;
	}
}
