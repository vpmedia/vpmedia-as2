/**
 * @author John Grden 
 * @author Alessandro Crugnola
 * @author Chris Allen
 * 
 * @param Special thanks to Alessandro Crugnola for getting us started!
 * @version 1.2
 */
class org.opensourceflash.data.XMLObject
{
	private static var initialized:Boolean = init();
	private static var lastObjectProcessed:Object;
	private static var strings:Array;
	
	//sepy
	private static var oResult:Object
	private static var oXML:XML;
	
	
	public static function addStrings(p_strings:Array):Void
	{
		// if you have addition specialty strings to add for decoding, add them here
		// it doesn't have to be simple character conversion, it can be full phrase replacement
		// IE: lets' say you have a site for LucasArts, and every where Star Wars is mentioned, it has 
		// to be italized - you can add a string to look for it and replace it with html tags:
		// addStrings(new Array({from:"Star Wars", to:"<i>Star Wars</i>"}))
		
		for(var i:Number=0;i<p_strings.length;i++)
		{
			// in adding the new strings to the FRONT of the array, you can do things like
			// throw your tracking through this first to strip out "/" or "'"
			// if we added these to the END of the array, it would not catch them.
			strings.splice(0, 0, p_strings[i]);
		}
	}

	public static function getlastObjectProcessed():Object
	{
		return lastObjectProcessed
	}
	 
	public static function getXML(p_obj:Object, p_nodeName:String):XML
	{
		return new XML(parseObject(p_obj, p_nodeName));
	}

	public static function getObject( p_xml:XML, p_allArray:Boolean):Object
	{
		lastObjectProcessed = new Object();
		//lastObjectProcessed = convertToObject(p_xml, lastObjectProcessed, p_allArray);
		lastObjectProcessed = translateXML(p_xml);
		return lastObjectProcessed;
	}
	
	private static function cleanObject(p_obj:Object):Object
	{
		// when XML is converted to an object, it includes a root object, pass back everything without that root
		for(var items:String in p_obj) p_obj = p_obj[items];break;
		return p_obj;
	}
	
	// called when the class first loads.  Sets the strings array for encoding
	private static function init()
	{		
		strings = new Array
		(
			{
				to:"&lt;", from:"<"
			},
			{
				to:"&gt;", from:">"
			},
			{
				to:"&apos;", from:"'"
			},
			{
				to:"&quot;", from:"\""
			},
			{
				to:"&amp;", from:"&"
			}
		)
		return true;
	}
	
	private static function parseObject(p_obj:Object, p_nodeName:String):String
	{
		// if first time this is calld there's no p_nodeName, assume root, since subsequent calls will have this argument included
		if(p_nodeName == undefined) p_nodeName = "root";
		var str = "<" + p_nodeName + ">";
		for(var items:String in p_obj)
		{
			if(typeof(p_obj[items]) == "object") 
			{
				str += parseObject(p_obj[items], items);
			}else
			{
				var nodeValue = p_obj[items]
				if(typeof(nodeValue) != "boolean" && typeof(nodeValue) != "number") nodeValue = encode(p_obj[items]);
				str += "<" + items + ">" + nodeValue + "</" + items + ">";
			}
		}
		str += "</" + p_nodeName + ">";
		return str;
	}
	
	private static function encode(p_str:String):String
	{
		for(var i:Number=0;i<strings.length;i++)
		{
			p_str = p_str.split(strings[i].from).join(strings[i].to);
		}
		if(p_str == undefined) p_str = "";
		return p_str;
	}
	
	private static function translateXML (from, path, name, position) 
	{
		var nodes, node, old_path;
		if (path == undefined) 
		{
			path = XMLObject;
			name = "lastObjectProcessed";
		}
		path = path[name];

		if (from.hasChildNodes ()) 
		{
			nodes = from.childNodes;
			if (position != undefined) 
			{
				old_path = path;
				path = path[position];
			}
			while (nodes.length > 0) 
			{
				node = nodes.shift ();
				if (node.nodeName != undefined) 
				{
					var __obj__ = new Object ();
					var data = node.firstChild.nodeValue;
					if (!isNaN(data)) data = Number(data);
					if (data == "true" || data == "false") data = data == "true" ? true : false;
					if (node.childNodes.length <= 1 && node.firstChild.nodeType != 1) __obj__ = data;
					if (position != undefined) 
					{
						old_path = path;
					}
					if (path[node.nodeName] != undefined) 
					{
						if (path[node.nodeName].__proto__ == Array.prototype) 
						{
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
					} else 
					{
						path[node.nodeName] = __obj__;
						name = node.nodeName;
						position = undefined;
					}
				}
				if (node.hasChildNodes ()) 
				{
					translateXML (node, path, name, position);
				}
			}
		}
		return lastObjectProcessed;
	}
}