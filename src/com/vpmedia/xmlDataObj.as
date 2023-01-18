/**
 * <p>Description: XMLtoObject</p>
 *
 * @author Matos Kristóf & András Csizmadia
 * @version 2.5
 */
class com.vpmedia.xmlDataObj extends XML
{
	function xmlDataObj ()
	{
	}
	var _callback:String;
	var xmlFile:String;
	// var data:Object = new Object ()
	var data:Object;
	var description:String;
	var size:Number;
	function onParsed ()
	{
		var callbackFunction = eval (this._callback);
		if (typeof (callbackFunction) == "function")
		{
			callbackFunction ();
		}
	}
	function setCallback (strFnPath)
	{
		this._callback = strFnPath;
	}
	function reload ()
	{
		this.readXMLfile (this.xmlFile);
	}
	function readXMLfile (_xmlFile)
	{
		// changed!
		this.data = new Object ();
		this.xmlFile = _xmlFile;
		this.ignoreWhite = true;
		this.onLoad = this._onLoadParseXML;
		this.load (xmlFile);
	}
	function _onLoadParseXML (_success)
	{
		if (_success)
		{
			var ref = this.firstChild;
			var currNode = "";
			for (var i = 0; i < ref.childNodes.length; i++)
			{
				currNode = ref.childNodes[i];
				if (currNode.nodeName == "subnode")
				{
					this.data[currNode.attributes.name] = this._getValue (currNode.childNodes[0].nodeValue, currNode.attributes.type);
				}
				if (currNode.nodeName == "node")
				{
					this.data[currNode.attributes.name] = this._addObject (currNode);
				}
			}
			// total size of XML document
			this.size = this.getBytesTotal ();
			// get the load status message into variable
			this.description = _handleEvent (this.status);
		}
		this.onParsed ();
	}
	function _addObject (refNode, objType)
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
	function _getValue (argValue, argType)
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
	function _handleEvent (_eventID)
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
