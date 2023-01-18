/**
 * com.sekati.data.XML2Object
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from it.sephiroth.XML2Object, Alessandro Crugnola, 1.0
 */

/**
 * return an object with the content of the XML translated<br/>
 * note: a node name with "-" will be replaced with "_" for flash compatibility.
 * for example <FIRST-NAME> will become FIRST_NAME
 * If a node has more than 1 child with the same name, an array is created with the children contents
 * 
 * {@code The object created will have this structure:
 * 	obj {
 * 		nodeName : {
 * 			attributes : an object containing the node attributes
 * 			data : an object containing the node contents
 * 		}
 * 	}	
 * 	Usage:
 * 		var data:Object = new XML2Object().parseXML(myXML);
 * }
 */
class com.sekati.data.XML2Object {
	private var oResult:Object = new Object( );
	private var oXML:XML;
	/**
	 * return the xml passed in the parseXML method
	 * {@code Usage: 
	 * 	theXML = XML2Object.xml
	 * }
	 */
	public function get xml():XML {
		return oXML;
	}
	/**
	 * parse an XMLObject
	 * @param sFile (XML)
	 * @return  Object - the contents of the parsed XML
	 * {@code Usage:
	 * 	XML2Object.parseXML( theXMLtoParse );
	 * }
	 */
	function parseXML(sFile:XML):Object {
		this.oResult = new Object( );
		this.oXML = sFile;
		this.oResult = this.translateXML( );
		return this.oResult;
	}
	/**
	 * core of the XML2Object class
	 */
	private function translateXML(from:Object, path:Object, name:Object, position:Object):Object {
		var xmlName:String;
		var nodes:Object, node:Object, old_path:Object;
		if (path == undefined) {
			path = this;
			name = "oResult";
		}
		path = path[name];
		if (from == undefined) {
			from = new XML( this.xml.toString( ) );
			from.ignoreWhite = true;
		}
		if (from.hasChildNodes( )) {
			nodes = from.childNodes;
			if (position != undefined) {
				old_path = path;
				path = path[position];
			}
			while (nodes.length > 0) {
				node = nodes.shift( );
				xmlName = node.nodeName;
				if (xmlName != undefined) {
					var __obj__:Object = new Object( );
					__obj__.attributes = node.attributes;
					__obj__.data = node.firstChild.nodeValue;
					if (position != undefined) {
						old_path = path;
					}
					if (path[xmlName] != undefined) {
						if (path[xmlName].__proto__ == Array.prototype) {
							path[xmlName].push( __obj__ );
							name = node.nodeName;
							position = path[xmlName].length - 1;
						} else {
							var copyObj:Object = path[xmlName];
							path[xmlName] = new Array( );
							path[xmlName].push( copyObj );
							path[xmlName].push( __obj__ );
							name = xmlName;
							position = path[xmlName].length - 1;
						}
					} else {
						path[xmlName] = __obj__;
						name = xmlName;
						position = undefined;
					}
				}
				if (node.hasChildNodes( )) {
					this.translateXML( node, path, name, position );
				}
			}
		}
		return this.oResult;
	}
}