/**
 * XmlUtil
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
 * Project: XmlUtil
 * File: XmlUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.XmlUtil extends XML implements IFramework
{
	// START CLASS
	public var className:String = "XmlUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	function XmlUtil ()
	{
	}
	//
	public function toArray ()
	{
		var x = this;
		var a = [];
		a.$ = x;
		a._ = [];
		a._$ = x.nodeName;
		for (var c in x.attributes)
		{
			var $ = x.attributes[c];
			a["_" + c] = a._[c] = !isNaN ($) ? Number ($) : $ == "true" ? true : $ == "false" ? false : $;
		}
		for (var c = 0; c < x.childNodes.length; c++)
		{
			var n = x.childNodes[c];
			a[c] = a[n.nodeName] = n.nodeType == 1 ? x2a (n) : n.toString ();
		}
		return a;
	}
	/**
	 * <p>XMLNode.transformTags(formatObject,AllowTagsByDefault) - Remove,Process any Tag in an XML file
	 * formatObject - a generic Object which contains the info on how to modify the tags.
	 * AllowTagsByDefault - boolean value which specifies whether to allow unspecified tags or not</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	public function transformTags (XML_node, formatObj, AllowTags, depth)
	{
		var str = "";
		if (XML_node.nodeType == 1)
		{
			var tag = {start:"", end:""};
			var attribObj = {};
			var aList = "";
			var depth = depth == undefined ? 0 : depth + 1;
			var c = XML_node.childNodes;
			for (var i = 0; i < c.length; i++)
			{
				if (c[i].nodeType == 1)
				{
					var buildTag = false;
					var name = c[i].nodeName.toLowerCase ();
					var obj = formatObj[name];
					if (obj != undefined)
					{
						if (typeof (obj) == "boolean")
						{
							buildTag = obj;
						}
						else if (typeof (obj) == "string")
						{
							name = obj;
							buildTag = true;
						}
						else if (obj instanceof Function)
						{
							tag = obj (c[i]);
						}
						else if (obj instanceof Object)
						{
							if (obj.__replace__ != undefined)
							{
								name = obj.__replace__ instanceof Function ? obj.__replace__ (name) : obj.__replace__;
							}
							for (a in c[i].attributes)
							{
								var val = c[i].attributes[a];
								var aObj = obj[a];
								if (aObj != undefined)
								{
									if (typeof (aObj) == "string")
									{
										a = aObj;
									}
									else if (aObj instanceof Object)
									{
										if (aObj.__replace__ != undefined)
										{
											a = aObj.__replace__ instanceof Function ? aObj.__replace__ (a) : aObj.__replace__;
										}
										if (aObj.__value__ != undefined)
										{
											val = aObj.__value__ instanceof Function ? aObj.__value__ (val) : aObj.__value__;
										}
									}
								}
								attribObj[a] += val;
							}
							buildTag = true;
						}
					}
					else if (AllowTags)
					{
						var attribObj = c[i].attributes;
						buildTag = true;
					}
					for (attrib in attribObj)
					{
						aList += " " + attrib.toLowerCase () + "=\"" + attribObj[attrib] + "\"";
					}
					if (buildTag)
					{
						tag.start = "<" + name + aList + ">";
						tag.end = "</" + name + ">";
					}
					str += tag.start + c[i].transformTags (formatObj, AllowTags, depth) + tag.end;
				}
				else
				{
					str += c[i].nodeValue;
				}
			}
		}
		else
		{
			return XML_node.nodeValue;
		}
		return str;
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
