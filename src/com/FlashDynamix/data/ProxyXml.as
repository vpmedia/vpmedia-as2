//
import com.FlashDynamix.types.Parse;
import com.FlashDynamix.types.String2;
import com.FlashDynamix.types.Object2;
//
class com.FlashDynamix.data.ProxyXml {
	//
	/**
	When data is parsed to always puts the value of node items always into an Array ie.
	<data><item><value>label1</value></item></data>
	Can be accessed data.item[0].value[0]
	Rather than traditionally accessed by data.item.value
	*/
	public static var alwaysArray:Boolean = false;
	public static var protectAttributes:Boolean = true;
	/**
	Converts an XMLNode or XML class to an XML Proxy Class
	*/
	public static function create(xml) {
		function allow(xml):Boolean {
			return (!Object2.isEmpty(xml.attributes) || (xml.childNodes.length>=1 && xml.childNodes != undefined) || xml instanceof Array);
		}
		if (allow(xml)) {
			// 
			ProxyXml.resolve(xml);
			//
			var nodes:Array = (xml instanceof XMLNode) ? xml.childNodes : xml;
			//
			for (var i = 0; i<nodes.length; i++) {
				var node:XMLNode = nodes[i];

				if (allow(node)) {
					if (nodes[i] == null) {
						nodes[i] = new Object();
					}
					nodes[i][0] = nodes[i]=ProxyXml.resolve(node);
					nodes[i].length = nodes.length;
				} else if (node.nodeValue) {
					var value = Parse.value(node.nodeValue);
					if (alwaysArray) {
						xml[0] = value;
						return xml;
					} else {
						xml = value;
						return xml;
					}
				}
			}
			//          
		} else {
			var value = Parse.value(xml.nodeValue);
			if (alwaysArray) {
				xml[0] = value;
				return xml;
			} else {
				xml = value;
				return xml;
			}
		}
		return xml;
	}
	/**
	@ignore
	*/
	private static function resolve(xml:XMLNode) {
		xml.__resolve = function(id:String) {
			if (id != "childNodes") {
				if (id != "nodes") {
					var path = ProxyXml.path(this, id);
					if (path == "") {
						if (id == "value" && this.firstChild.nodeValue != null) {
							return Parse.value(this.firstChild.nodeValue);
						}
						return undefined;
					}
					var node = eval("this"+path);
					//
					if (!protectAttributes && id.indexOf("@") != -1) {
						id = id.substr(1);
					}
					//     
					if (node instanceof Array) {
						node = ProxyXml.getNodesByName(node, id);
					}
					//  
					if (node != undefined) {
						this[id] = ProxyXml.create(node);
						return this[id];
					}
				} else {
					this.nodes = ProxyXml.getNodeNames(this);
					return this.nodes;
				}
			}
		};
		_global.ASSetPropFlags(xml,"__resolve",1,1);
		return xml;
	}
	/**
	@ignore
	*/
	public static function parse(xml) {
		//
		function setValue(data, name, value) {
			if (name == null) {
				return;
			}
			if (data[name] == undefined) {
				data[name] = (alwaysArray) ? [value] : value;
				return data[name];
			} else {
				if (!(data[name] instanceof Array)) {
					data[name] = [data[name]];
				}
				data[name].push((alwaysArray) ? [value] : value);
				return data[name][data[name].length-1];
			}
		}
		//
		var data:Object = new Object();
		for (var i = 0; i<xml.childNodes.length; i++) {
			//
			var node:XMLNode = xml.childNodes[i];
			var name:String = node.nodeName;
			var attribs = node.attributes;
			var hasAttribs = !Object2.isEmpty(attribs);
			var item;
			//
			if (node.nodeValue != null) {
				item = setValue(data, "value", Parse.value(node.nodeValue));
			}
			var parsed = parse(node);
			if (node.childNodes.length == 1 && !hasAttribs && parsed.value != undefined) {
				item = setValue(data, name, parsed.value);
			} else {
				var val = (hasAttribs) ? new Object() : "";
				item = setValue(data, name, Object2.isEmpty(parsed) ? val : parsed);
			}
			//
			for (var n in attribs) {

				if (protectAttributes) {
					item["@"+n] = Parse.value(attribs[n]);
				} else {
					item[n] = Parse.value(attribs[n]);
				}
			}
		}
		return data;
	}
	/*
	* Decodes a proxy XML Array into a standard Array important when needing to
	do Array methods like sortOn. This is a safe gaurd in case all the elements have
	not been accessed yet.
	*/
	public static function decode(items:Array, fields:Array):Void {
		for (var i = 0; i<items.length; i++) {
			var item:Object = items[i];
			if (fields != undefined) {
				for (var j = 0; j<fields.length; j++) {
					item[fields[j]];
				}
			} else {
				for (var j in item) {
					item[j];
				}
			}
		}
	}
	/**
	@ignore
	*/
	private static function pathSet(path:String):Array {
		//
		var result:Array = new Array();
		var index:Number;
		var nodeName:String;
		var fltrIndx:Number;
		var fltr:String;
		//
		while (path.length>0) {
			//
			index = path.lastIndexOf("/");
			nodeName = path.substring(index+1);
			fltrIndx = nodeName.indexOf("[", 0);
			fltr = fltrIndx>=0 ? nodeName.substring(fltrIndx+1, nodeName.length-1) : "";
			nodeName = fltrIndx>=0 ? nodeName.substring(0, fltrIndx) : nodeName;
			result.splice(0,0,{nodeName:nodeName, filter:fltr});
			path = path.substring(0, index);
			//
		}
		//
		return result;
	}
	/**
	@ignore
	*/
	private static function path(node:XMLNode, path:String):String {
		//
		var pathSet:Array = ProxyXml.pathSet(path);
		var cNode = node;
		var chldNode;
		var result:String = "";
		//
		for (var i = 0; i<pathSet.length; i++) {
			//
			var nodeName:String = pathSet[i].nodeName;
			var attrIndx:Number;
			if (!protectAttributes) {
				attrIndx = 0;
			} else {
				attrIndx = nodeName.indexOf("@")+1;
			}
			//
			if (attrIndx>=0) {
				//
				nodeName = nodeName.substr(attrIndx);
				if (cNode instanceof Array) {
					for (var j:Number = 0; j<cNode.length; j++) {
						chldNode = cNode[j];
						if (chldNode.attributes[nodeName] != undefined) {
							result += "."+j+".attributes."+nodeName;
							break;
						}
					}
				} else if (cNode.attributes[nodeName] != undefined) {
					result += ".attributes."+nodeName;
					break;
				}
				//    
			}
			if (result.length == 0) {
				//
				if (cNode.childNodes != undefined) {
					//
					var checkNode = cNode.childNodes;
					var matches:Number = 0;
					var idx:Number;
					for (var j:Number = 0; j<checkNode.length; j++) {
						chldNode = checkNode[j];
						if (chldNode.nodeName == nodeName) {
							idx = j;
							matches++;
						}
					}
					//
				}
				//                                                             
				if (matches == 1) {
					cNode = cNode.childNodes[idx];
					result += ".childNodes."+idx;
				} else if (matches>1) {
					result += ".childNodes";
					cNode = cNode.childNodes;
				}
				//                                                                                  
			}
		}
		return result;
	}
	/**
	@ignore
	*/
	private static function getNodeNames(xml:XMLNode):Object {
		var nodes = new Object();
		for (var i = 0; i<xml.childNodes.length; i++) {
			nodes[xml.childNodes[i].nodeName] = null;
		}
		return nodes;
	}
	/**
	@ignore
	*/
	private static function getNodesByName(nodes:Array, id:String):Array {
		var n:Array = new Array();
		for (var i = 0; i<nodes.length; i++) {
			if (nodes[i].nodeName == id) {
				n.push(nodes[i]);
			}
		}
		return n;
	}
	/**
	@ignore
	*/
	public static function getAllNodesByName(nodes:XML, name:String):XML {
		//
		var str:String = nodes.toString();
		var nStr:String = "";
		//
		var start:String = "<"+name;
		var end:String = "</"+name+">";
		var startIdx:Number = str.indexOf(start);
		//
		while (startIdx != -1) {
			var endIdx:Number = str.indexOf(end)+end.length;
			var xStr:XML = new XML(str.slice(startIdx, endIdx));
			if (xStr.firstChild.childNodes.length>1) {
				nStr += xStr.toString();
				xStr = getAllNodesByName(new XML(xStr.firstChild.childNodes.toString()), name);
			}
			nStr += xStr.toString();
			//
			str = str.slice(endIdx, -1);
			startIdx = str.indexOf(start);
		}
		return new XML(nStr);
	}
}