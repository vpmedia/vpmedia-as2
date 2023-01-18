/*---------------------------------------------------------------------------
XMLSA for Flash MX v1.4
-----------------------------------------------------------------------------
	Created by
		Max Ziebell (ziebell@worldoptimizer.com)

	Version History:
		06/2003 - Added Mixed-Node notation
				  Added optional sessionID and onStartSession, onEndSession-Events
				  Added load, send and sendAndLoad
				  Added noCache with autodetection if online or local
				  changed dump to return the output so you can trace or assign it
				  Added dumpHtml
				  Added search

		04/2003 - Added insertBefore and removeNode
				  removed support for Flash 5! sorry but this was causing problems!

		03/2003 - Added the known methodes of XML to work with XMLSA
		          Now you can use: appendChild, cloneNode
				  Added removeChildByIndex
	
		01/2003 - Added support for direct access of attributes

		12/2002 - Added support for Flash 5 but in this case I recommend
		          to use XMLNitro with it.

		11/2002 - First release
---------------------------------------------------------------------------*/

dynamic class XMLSA
{
	
	private var xmlobj;
	
	// Constructor
	public function XMLSA( watchXML ) {
		this.xmlobj = watchXML;
		
		this.$xml = this.$root = this.$parent = new Object();
		_global.ASSetPropFlags(this,null,1,1);
		if (watchXML != undefined) {this._parse.apply (this,arguments)};
		
		// hidde all functions to for..in loops
		_global.ASSetPropFlags(XMLSA.prototype,null,1,1);
	}
	
	// load
	public function load() {
		this._cleanup();
		var loader = this._makeLoader(this);
		arguments[0] = this._makeURL(arguments[0]);
		loader.load.apply(loader,arguments);
	}
	
	// send
	public function send() {
		this._cleanup();
		arguments[0] = this._makeURL(arguments[0]);
		if(arguments.length==2) {
			this.$root.send.apply(this.$root, arguments);
		} else {
			this.$root.sendAndLoad.apply(this.$root, arguments[0], new XML());
		}
	}
	
	// toString
	public function toString() {
		return this.$xml.toString();
	}
	
	// sendAndLoad
	public function sendAndLoad(host, target, method) {
		this._cleanup();
		var loader = this._makeLoader(target);
		this.$root.sendAndLoad(this._makeURL(host),loader,method);
	}
	
	// search
	public function search(criteria, recursive) {
		XMLNode.prototype.$criteria = criteria;
		arguments.shift();
		var result = this._search.apply(this,arguments);
		delete (XMLNode.prototype.$criteria);
		return result;
	}
	
	//return a reference to XML
	public function getXML() {
		return  this.$xml;
	}
	
	// return the value of the firstChild if its a textElement
	public function getValue() {
		return  (this.$xml.firstChild.nodeType == 3 ? this.$xml.firstChild.nodeValue : undefined);
	}
	
	// set a textNode
	public function setValue( text ) {
		// check if the node has a textElement?
		if (this.$xml.firstChild.nodeType == undefined) {
			// seems like we have to create one...
			this.$xml.appendChild(new XML().createTextNode(text));
			return true;
		// else check if firstChild is a textElement and set it...
		}else if (this.$xml.firstChild.nodeType == 3) {
			this.$xml.firstChild.nodeValue = text;
			return true;  // retrun success on setValue
		// seams like it ain't possible
		} else {
			return false; // retrun failed on setValue
		}
	}
	
	//return the nodeName
	public function getNodeName() {
		return  this.$xml.nodeName;
	}
	
	// append a child
	public function appendChild(element) {
		if (element instanceof XML) {
			element = element.firstChild;
		}
		this.$xml.appendChild (element);//XML
		this._reParse ();//XMLSA
	}
	
	// return a XML object with cloneNode
	public function cloneNode(rekursiv) {
		return this.$xml.cloneNode (rekursiv);//XML
	}
	
	// this one I added as it's sometimes simpler just want
	// to add a new member...
	public function appendElement(name,value,attribs) {
		var temp = new XML();
		this.$xml.appendChild(temp.createElement(name));
		if (value != null) {
			this.$xml.lastChild.appendChild (temp.createTextNode(value));
		}
		if (typeof(attribs) == "object" ) {
			// there is a bug in Flash MX so we got to do this...
			// a direct assignment would add __proto__ and constructor
			// to the attributes...
			for (var key in attribs ) {
				this.$xml.lastChild.attributes[key] = attribs[key];
			}
		}
		this._reParse ();//XMLSA
	}
	
	// remove child by index
	public function removeChildByIndex(name,idx) {
		this[name][idx].$xml.removeNode();
		this[name].splice(idx,1);
	}
	
	// remove child by index
	public function removeNode() {
		this.$xml.removeNode();
		this.$parent._reParse();
	}
	
	// insert before
	public function insertBefore(node) {
		this.$parent.$xml.insertBefore (node,this.$xml);
		this.$parent._reParse();
	}
	
	/*************************************************/
	// Private
	/*************************************************/
	// Parser
	// called by the constructor and by reParse
	public function _parse(node, parent) {
		this.$parent = parent;
		// make shure we work with XMLNode
		if (node instanceof XML) {
			this.$version = "XMLSA 1.4";
			this.$root = node;
			node = node.firstChild;
		} else {
			this.$root = this.$parent.$root;
		}
		// store a reference to $xml
		this.$xml=node;
		this.attributes = node.attributes;
		if (node.nodeType == 1 and node.firstChild.nodeType <> 3) {		
			for (var childCounter=0; childCounter< node.childNodes.length; childCounter++) {
				var tempName = node.childNodes[ childCounter ].nodeName;
				if (this[ tempName ]==undefined) {
					this[ tempName ] = new Array();
					this[ tempName ].__resolve = XMLSA.prototype.mixed__resolve;
					_global.ASSetPropFlags(this[ tempName ],null,1,1);
				}
				this[ tempName ].push (new XMLSA(node.childNodes[childCounter],xmlobj));
			}
		}
	}
	
	// reParse
	// free a brach and reparse it
	public function _reParse(){
		this._cleanup();
		// parse it again...
		this._parse (this.$xml,this.$parent);
	}
	
	public function _cleanup() {
		// delete all
		for (var found in this){
			if (found != "onLoad") {
				trace(found);
				delete (this[found]);
			}
		}
	}
	
	// make path
	public function _makeURL( host ) {
		if (this._online()) {
			var nocache = (random(100000)+100000);
			if (_global.sessionID!=undefined) {
				return host+"?sid="+_global.sessionID+"&nocache="+nocache;
			} else {
				return host+"?nocache="+nocache;
			}	
		} else {
			return host;
		}
	}
	
	public function _online() {
		// are we online?
		return (_root._url.substr(0,7) == "http://");
	}
	
	// used by send, load and sendAndLoad
	public function _makeLoader(target) {
		var loader = new XML();
		loader.ignoreWhite = true;
		loader.link = target;
		loader.onLoad = function(ok) {
			if (ok) {
				_global.ASSetPropFlags(this.link,["onLoad"],1,1);
				this.link._cleanup();
				_global.ASSetPropFlags(this.link,["onLoad"],0,1);
				this.link._parse(this);
				this.link.onLoad(true);
				// Experimental Session Support
				//---------------------------------------------------
				// use the attribute 'session' in the root tag to
				// submit a sessionID if you transmit the word
				// 'timeout' or 'end' the session gets deleted
				var header = this.link.attributes;
				if (header.session != undefined) {
					switch (header.session) {
						case "timeout":
						case "end":
							if (_global.session!=undefined) { 
								delete(_global.session);
								_global.onSessionEnd(header);
							}
							break;
						default:
							_global.session = new Object();
							_global.session.id=header.session;
							_global.onSessionStart(header);
							break;
					}
				}
			} else {
				this.link.onLoad(false);
			}
		}
		return loader;
	}
	
	public function _search(recursive) {
		var result = new Array();
		for (var found in this) {
			for (var node in this[found]) {
				if (this[found][node].$xml != undefined) {
					if (this[found][node].$xml.$criteria()) {
						result.push(this[found][node]);
					}
					if (recursive) {
						result = result.concat(this[found][node]._search.apply(this[found][node], arguments));
					}
				}
			}
		}
		return result;
	}
	
	// new since 1.4 allows notations without a nodenumber because
	// it defaults them to 0 in that case! (redirection)
	public function mixed__resolve(found) {
		return this[0][found];
	}
	
	
	
}