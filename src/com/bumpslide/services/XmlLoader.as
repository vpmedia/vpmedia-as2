import com.bumpslide.util.Delegate; 
import com.bumpslide.util.Debug;

/**
 * Friendly Xml Loader
 * 
 * <p>Wraps XML object, handles errors, etc. 
 * 
 * @author David Knape
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms. 
 */
 
class com.bumpslide.services.XmlLoader {
	
	var _xml : XML;
	var _url : String;
	var _source : String = "";
	var onError : Function;
	var onSuccess : Function;
		
	public function XmlLoader() {		
		//Debug.warn('[XmlLoader] CTOR');
		_xml = new XML();
		_xml.ignoreWhite = true;	
		_xml.onLoad = Delegate.create( this, onXmlLoaded);
		onError = Delegate.create( this, defaultErrorHandler );
		
		_global.XML2AS = XmlLoader.XML2AS;
	}
	
	function get xml () {
		return _xml;
	}
	
	function destroy() {
		//Debug.warn('[XmlLoader] destroy');
		delete _xml;
	}
	
	public function load( url:String) {
		_url = url;
		return _xml.load( url );
	}		
		
	private function defaultErrorHandler(status, message, url) {
		Debug.error('[XmlLoader] ERROR Loading '+url+"\n"+message);
	}
		
	private function onXmlLoaded(success) {
		if(!success || _xml.status<0) {
			onError.apply( this, [_xml.status, statusMessage, _url])
		} else {			
			onSuccess.apply( this, [_xml, this])
		}				
	}
	
	function getXmlAsObject() {
		var resultObj = {};	
		XmlLoader.XML2AS(_xml.firstChild, resultObj);
		return resultObj[_xml.firstChild.nodeName][0];
	}
	
	public function get statusMessage () : String {
		var msg : String = '';
		switch(_xml.status) {
			case  0:  msg = 'No error; parse was completed successfully.'; break;
			case -2:  msg = 'A CDATA section was not properly terminated.'; break;
			case -3:  msg = 'The XML declaration was not properly terminated.'; break;
			case -4:  msg = 'The DOCTYPE declaration was not properly terminated.'; break;
			case -5:  msg = 'A comment was not properly terminated.'; break;
			case -6:  msg = 'An XML element was malformed.'; break;
			case -7:  msg = 'Out of memory.'; break;
			case -8:  msg = 'An attribute value was not properly terminated.'; break;
			case -9:  msg = 'A start-tag was not matched with an end-tag.'; break;
			case -10: msg = 'An end-tag was encountered without a matching start-tag.'; break;

		}
		if(!_xml.loaded) msg  = 'Failed to load XML '+_source;
		return msg;
	}

	static public function XML2AS(n, r) {
		var a, d, k;
		if (r[k=n.nodeName] == null) {
			r = ((a=r[k]=[{}]))[d=0];
		} else {
			r = (a=r[k])[d=r[k].push({})-1];
		}
		if (n.hasChildNodes()) {
			if ((k=n.firstChild.nodeType) == 1) {
				r.attributes = n.attributes;
				for (var i in k=n.childNodes) {
					XML2AS(k[i], r);
				}
			} else if (k == 3 || k==4) {
				a[d].text = new String(n.firstChild.nodeValue);
				a[d].attributes = n.attributes;
			}  
		} else {
			r.attributes = n.attributes;
		}
	}; 
	
	
}