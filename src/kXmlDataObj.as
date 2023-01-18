class kXmlDataObj extends XML
{
	function kXmlDataObj ()
	{

	}
	var _callback:String;
	var xmlFile:String;
	var data:Object = new Object ();

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
		this.read (this.xmlFile);
	}

	function read (xmlFile:String)
	{
		trace ("[XML] read: " + xmlFile);		
		this.xmlFile = xmlFile;
		this.ignoreWhite = true;
		this.onLoad = this._parse;
		this.load (xmlFile);
	}
	function _parse (success:Boolean)
	{
		trace ("[XML] parse: " + success);
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
}