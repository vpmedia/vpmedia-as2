/**
 * XmlManager
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: XmlManager
 * File: XmlManager.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import mx.utils.ObjectCopy;
import com.vpmedia.events.Delegate;
import com.vpmedia.ObjectDumper;
//import XML;
// Define Class
class com.vpmedia.managers.XmlManager extends XML
{
	function XmlManager ()
	{
		EventDispatcher.initialize (this);
		this.init ();
	}
	// class
	public var className:String = "XmlManager";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	//
	private var xmlFile:String;
	private var data:Object;
	private var description:String;
	private var size:Number;
	private var status:Number;
	private var ignoreWhite:Boolean;
	private var loaded:Boolean;
	private var contentType:String;
	private var docTypeDecl:String;
	private var xmlDecl:String;
	// f7 compatibility
	private var onHTTPStatus:Function
	//
	var result_lv:LoadVars;
	var send_lv:LoadVars;
	var server:String;
	/**
	 * <p>Description: Get XmlManager version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Init</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function init ():Void
	{
		//trace ("*init*");
		this.ignoreWhite = true;
		//
		this.onLoad = Delegate.create (this, this.onLoadXML);
		this.onData = Delegate.create (this, this.onDataXML);
		this.onHTTPStatus = Delegate.create (this, this.onHttpStatusXML);
		//
		this.send_lv = new LoadVars ();
		this.result_lv = new LoadVars ();
		this.result_lv.onLoad = Delegate.create (this, this.onResultLvLoad);
		//
		this.data = new Object ();
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function onResultLvLoad (success)
	{
		if (success)
		{
			var res_xml = new XML ();
			res_xml.ignoreWhite = true;
			res_xml.parseXML (this.result_lv.xml);
			var temp_obj = this.xmlToObject (res_xml);
			this.dispatchEvent ({type:"onXmlLvParsed", target:this, data:temp_obj});
		}
		else
		{
			this.dispatchEvent ({type:"onXmlLvLoadError", target:this});
		}
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function setServer (__server):Void
	{
		//trace ("*readXMLfile*");
		this.server = __server;
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function loadXmlLv (__requestName, __o)
	{
		ObjectCopy.copyProperties (this.send_lv, __o);
		this.send_lv.functionId = __requestName;
		trace ("XML Request:" + ObjectDumper.toString (this.send_lv, true, true, true));
		this.send_lv.sendAndLoad (this.server, this.result_lv, "POST");
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function loadXml (__xmlFile):Void
	{
		//trace ("*readXMLfile*");
		this.xmlFile = __xmlFile;
		this.load (this.xmlFile);
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function reloadXml ():Void
	{
		//trace ("*reReadXMLfile*");
		this.loadXml (this.xmlFile);
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function onHttpStatusXML (__status)
	{
		//trace ("*onHttpStatusXML*");
		this.dispatchEvent ({type:"onHttpStatus", target:this, status:__status});
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function onDataXML (__xmlSrc)
	{
		//trace ("*onDataXML*");
		this.dispatchEvent ({type:"onDataStatus", target:this});
		if (__xmlSrc == undefined)
		{
			this.onLoad (false);
		}
		else
		{
			this.parseXML (__xmlSrc);
			this.loaded = true;
			this.onLoad (true);
		}
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function onLoadXML (_success:Boolean):Void
	{
		//trace ("*onLoadXML*");
		if (_success)
		{
			this.data = xmlToObject (this);
			// total size of XML document
			this.size = this.getBytesTotal ();
			// get the load status message into variable
			this.description = _handleEvent (this.status);
			if (this.loaded)
			{
				this.dispatchEvent ({type:"onParsed", target:this, size:this.size, data:this.data, status:this.status, description:this.description, xmlFile:this.xmlFile});
			}
			else
			{
				this.dispatchEvent ({type:"onLoadError", target:this, status:this.status, description:this.description, xmlFile:this.xmlFile});
			}
		}
		else
		{
			this.dispatchEvent ({type:"onParseError", target:this, status:this.status, description:this.description, xmlFile:this.xmlFile});
		}
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function xmlToObject (__xml:XML):Object
	{
		//trace ("**xmlToObject");
		var ref = __xml.firstChild;
		var currNode = "";
		var __obj = new Object ();
		for (var i = 0; i < ref.childNodes.length; i++)
		{
			currNode = ref.childNodes[i];
			if (currNode.nodeName == "subnode")
			{
				__obj[currNode.attributes.name] = this._getValue (currNode.childNodes[0].nodeValue, currNode.attributes.type);
			}
			if (currNode.nodeName == "node")
			{
				__obj[currNode.attributes.name] = this._addObject (currNode);
			}
		}
		return __obj;
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function _addObject (refNode, objType):Array
	{
		var _result = new Array ();
		var _key = 0;
		for (var i = 0; i < refNode.childNodes.length; i++)
		{
			if (refNode.childNodes[i].nodeName == "subnode")
			{
				var _tmpKey = refNode.childNodes[i].attributes.name;
				var _tmpValue = this._getValue (refNode.childNodes[i].childNodes[0].nodeValue, refNode.childNodes[i].attributes.type);
				if (_tmpKey != "")
				{
					_result[_tmpKey] = _tmpValue;
				}
				else
				{
					_result[_key] = _tmpValue;
					_key++;
				}
			}
			if (refNode.childNodes[i].nodeName == "node")
			{
				var _tmpKey = refNode.childNodes[i].attributes.name;
				if (_tmpKey != "")
				{
					_result[_tmpKey] = this._addObject (refNode.childNodes[i], refNode.childNodes[i].attributes.type);
				}
				else
				{
					_result[_key] = this._addObject (refNode.childNodes[i], refNode.childNodes[i].attributes.type);
					_key++;
				}
			}
		}
		return _result;
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function _getValue (argValue, argType)
	{
		argType = argType.toLowerCase ();
		switch (argType)
		{
		case "boolean" :
			argValue = argValue.toLowerCase ();
			return (argValue == "true" || parseInt (argValue) > 0) ? true : false;
			break;
		case "string" :
			return String (unescape (argValue));
			break;
		case "number" :
			return Number (argValue);
			break;
		case "date" :
			var aDate = new Array (7);
			var aTmp = argValue.split (",");
			for (var i = 0; i < aTmp.length; i++)
			{
				aDate[i] = aTmp[i];
			}
			var dtRes = new Date (aDate[0], Number (aDate[1]) - 1, aDate[2], aDate[3], aDate[4], aDate[5], aDate[6]);
			return dtRes;
			break;
		}
		return unescape (argValue);
		break;
	}
	/**
	 * <p>Description: Desc.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function _handleEvent (_eventID)
	{
		var errorMessage:String;
		switch (_eventID)
		{
		case 0 :
			errorMessage = "No error; parse was completed successfully.";
			break;
		case -2 :
			errorMessage = "A CDATA section was not properly terminated.";
			break;
		case -3 :
			errorMessage = "The XML declaration was not properly terminated.";
			break;
		case -4 :
			errorMessage = "The DOCTYPE declaration was not properly terminated.";
			break;
		case -5 :
			errorMessage = "A comment was not properly terminated.";
			break;
		case -6 :
			errorMessage = "An XML element was malformed.";
			break;
		case -7 :
			errorMessage = "Out of memory.";
			break;
		case -8 :
			errorMessage = "An attribute value was not properly terminated.";
			break;
		case -9 :
			errorMessage = "A start-tag was not matched with an end-tag.";
			break;
		case -10 :
			errorMessage = "An end-tag was encountered without a matching start-tag.";
			break;
		default :
			errorMessage = "An unknown error has occurred.";
			break;
		}
		return errorMessage;
	}
}
