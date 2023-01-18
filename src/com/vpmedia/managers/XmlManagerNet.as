/**
 * XmlManagerNet
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
 * Project: XmlManagerNet
 * File: XmlManagerNet.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
import logging.*;
import logging.events.*;
// Start
class com.vpmedia.managers.XmlManagerNet extends MovieClip
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "XmlManagerNet";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	private var AppLogger:Logger;
	private var xrayPublisher;
	private var serverURL:String;
	private var requestLANG = "HU";
	private var response_xml:XML;
	private var request_xml:XML;
	private var request_name:String = null;
	private var request_object:Object = {};
	/**
	 * <p>Description: Functions</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function setLANG (__lang)
	{
		AppLogger.info ("setLANG");
		this.requestLANG = __lang;
	}
	function setServerURL (__url)
	{
		AppLogger.info ("setServerURL");
		this.serverURL = __url;
	}
	function getServerURL ()
	{
		AppLogger.info ("getServerURL");
		return this.serverURL;
	}
	/**
	 * <p>Description: Constructor</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function XmlManagerNet ()
	{
		EventDispatcher.initialize (this);
		AppLogger = Logger.getLogger ("Application");
		//xrayPublisher = new logging.XrayOutput ();
		//AppLogger.addPublisher (xrayPublisher);
	}
	/**
	 * <p>Description: XML STATUS MSG CONVERTER</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function getStatusDescription (msg)
	{
		var msgArr = msg.split (",");
		var description = "";
		if (msgArr.length > 0)
		{
			for (var i = 0; i < msgArr.length; i++)
			{
				description += getStatusDescriptionItem (msgArr[i]) + "\n";
			}
		}
		else
		{
			description = getStatusDescriptionItem (msg);
		}
		return description;
	}
	private function getStatusDescriptionItem (msg)
	{
		var description;
		switch (msg)
		{
		case _global.DEFAULT_STATUS_MESSAGE_SUCCESS :
			requestLANG == "HU" ? description = "Success." : null;
			break;
		case "DATABASE_ERROR" :
			requestLANG == "HU" ? description = "Database Error" : null;
			break;
		default :
			description = msg;
			break;
		}
		return description;
	}
	public function setRequest (__request_name, __request_object)
	{
		this.request_object[__request_name] = __request_object;
		AppLogger.info ("setRequest" + " " + this.request_object[__request_name]);
		this.request_object[__request_name] = __request_object[__request_name];
	}
	private function getXMLStatusDescription (__xml)
	{
		AppLogger.info ("getXMLStatusDescription");
		var tmp_arr = __xml.RESPONSE.$PARAM;
		for (var count = 0; count < tmp_arr.length; count++)
		{
			if (tmp_arr[count]._NAME == "STATUS")
			{
				var __status = tmp_arr[count].__text;
			}
		}
		var __status_description = getStatusDescription (__status);
		var resultObject = new Object ();
		resultObject.code = __status;
		resultObject.description = __status_description;
		return resultObject;
	}
	public function getXML_Request (__request_name)
	{
		AppLogger.info ("XML Request:" + __request_name);
		var cItem = this.request_object[__request_name];
		this.request_name = cItem.request_name;
		this.request_xml = new XML ();
		var rootNode:XMLNode = request_xml.createElement ("REQUEST");
		request_xml.appendChild (rootNode);
		request_xml.firstChild.attributes.NAME = this.request_name;
		var tmp_arr = cItem.data;
		for (var i = 0; i < tmp_arr.length; i++)
		{
			var __tag = tmp_arr[i].tag;
			var __tagName = tmp_arr[i].tagName;
			var __tagValue = tmp_arr[i].tagValue;
			var __value = tmp_arr[i].value;
			//
			var child:XMLNode = request_xml.createElement (__tag);
			child.attributes[__tagName] = __tagValue;
			request_xml.firstChild.appendChild (child);
			var textNode:XMLNode = request_xml.createTextNode (__value);
			child.appendChild (textNode);
		}
		AppLogger.info (request_xml.toString ());
		//
		this.response_xml = new XML ();
		response_xml.onLoad = Delegate.create (this, responseXML_onLoad);
		//
		request_xml.sendAndLoad (this.getServerURL () + "?functionId=" + request_name, response_xml);
	}
	private function responseXML_onLoad (success)
	{
		if (success)
		{
			parseXML (response_xml, request_name);
		}
		else
		{
			AppLogger.warning ("error loading xml.");
		}
	}
	/**
	 * <p>Description: XML</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function parseXML (__xml, __request_name)
	{
		AppLogger.info ("parseXML");
		var __statusObject = getXMLStatusDescription (__xml);
		var __status = __statusObject.code;
		var __status_description = __statusObject.description;
		var infoObject = new Object ();
		infoObject.xml_data = __xml;
		infoObject.request_name = __request_name;
		infoObject.request_description = __request_name;
		infoObject.response_name = __status;
		infoObject.response_description = __status_description;
		this.dispatchEvent ({type:"onParse", target:this, result:infoObject});
		//AppLogger.info (__request_name + "\n" + __status + "\n" + __status_description);
	}
	/**
	 * <p>Description: Get Class version</p>
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
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
