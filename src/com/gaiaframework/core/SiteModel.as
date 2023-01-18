/**********************************************************************************************************************
* Gaia Framework for Adobe Flash ©2007
* Written by: Steven Sacks
* email: stevensacks@gmail.com
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaframework.com/
* By using the Gaia Framework, you agree to keep the above contact information in the source code.

Distributed under Creative Commons Attribution-ShareAlike 3.0 Unported License
http://creativecommons.org/licenses/by-sa/3.0/

THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE ("CCPL" OR "LICENSE"). 
THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS 
LICENSE OR COPYRIGHT LAW IS PROHIBITED.

BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS OF THIS LICENSE. 
TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN 
CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**********************************************************************************************************************/

import net.stevensacks.utils.ObservableClass;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.assets.AssetCreator;
import net.stevensacks.utils.CacheBuster;
import net.stevensacks.data.XML2AS;
import mx.utils.Delegate;

// This class loads and parses the site.xml and builds the site tree from it

class com.gaiaframework.core.SiteModel extends ObservableClass
{
	private var xml:XML;
	private static var _tree:PageAsset;
	private static var _title:String;
	private static var _delimiter:String;
	private static var _preloader:String;
	private static var _context:Boolean;
	private static var _defaultFlow:String;
	private static var _routing:Boolean;
	private static var _routes:Object;
	
	function SiteModel()
	{
		super();
		xml = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = Delegate.create(this, parseXML);
		xml.load(CacheBuster.create("site.xml"));
	}
	public static function get tree():PageAsset
	{
		return _tree;
	}
	public static function get title():String
	{
		return _title;
	}
	public static function get delimiter():String
	{
		return _delimiter;
	}
	public static function get preloader():String
	{
		return _preloader;
	}
	public static function get context():Boolean
	{
		return _context;
	}
	public static function get defaultFlow():String
	{
		return _defaultFlow;
	}
	public static function get routing():Boolean
	{
		return _routing;
	}
	public static function get routes():Object
	{
		return _routes;
	}
	private function parseXML():Void
	{
		var xmlObj:Object = {};
		XML2AS.parse(xml.firstChild, xmlObj);
		//
		_title = xmlObj.site[0].attributes.title;
		_preloader = xmlObj.site[0].attributes.preloader || "preload.swf";
		_context = (xmlObj.site[0].attributes.context == "true");
		_delimiter = xmlObj.site[0].attributes.delimiter || ": ";
		_routing = (xmlObj.site[0].attributes.routing == "true");
		if (_routing) _routes = {};
		if (xmlObj.site[0].attributes.transitionType == "preload") _defaultFlow = "preload";
		else if (xmlObj.site[0].attributes.transitionType == "reverse")	_defaultFlow = "reverse";
		else _defaultFlow = "normal";
		//
		var indexNode:Object = xmlObj.site[0].page[0];
		_tree = new PageAsset();
		_tree.id = indexNode.attributes.id;
		_tree.src = indexNode.attributes.src;
		_tree.title = indexNode.attributes.title;
		_tree.preloadAsset = true;
		_tree.depth = "BOTTOM";
		if (indexNode.asset.length > 0) _tree.assets = parseAssets(indexNode.asset, _tree.depth);
		_tree.defaultChild = indexNode.attributes.defaultChild;
		_tree.children = parsePages(_tree, indexNode.page);
		_tree.transitionType = "normal";
		if (_tree.children[_tree.defaultChild] == undefined) _tree.defaultChild = indexNode.page[indexNode.page.length - 1].attributes.id;
		//
		dispatchEvent({type:"ready", data:_tree});
	}
	private function parsePages(parent:PageAsset, childNodes:Array):Object
	{
		var children:Object = {};
		for (var i:Number = 0; i < childNodes.length; i++) 
		{
			var node:Object = childNodes[i];
			var page:PageAsset = new PageAsset();
			page.parent = parent;
			page.id = node.attributes.id;
			page.src = node.attributes.src;
			page.title = node.attributes.title;
			page.context = (node.attributes.context == "true");
			page.external = (node.attributes.src.split(".").pop() != "swf" || node.attributes.src.indexOf("javascript") > -1);
			page.preloadAsset = true;
			//
			var dtu:String = node.attributes.depth.toUpperCase();
			if (dtu == "TOP" || dtu == "BOTTOM") 
			{
				page.depth = dtu;
			}
			else
			{
				page.depth = "MIDDLE";
			}
			//
			if (node.attributes.transitionType == "normal") page.transitionType = "normal";
			else if (node.attributes.transitionType == "preload") page.transitionType = "preload";
			else if (node.attributes.transitionType == "reverse") page.transitionType = "reverse";
			else page.transitionType = SiteModel.defaultFlow;
			//
			if (node.asset.length > 0) page.assets = parseAssets(node.asset, page.depth);
			if (node.page.length > 0) 
			{
				page.defaultChild = node.attributes.defaultChild;
				page.children = parsePages(page, node.page);
				if (page.children[page.defaultChild] == undefined) page.defaultChild = node.page[node.page.length - 1].attributes.id;
			}
			else
			// only add terminal pages to routes
			{
				if (_routing)
				{
					page.route = node.attributes.route || page.title;
					page.route = getValidRoute(page.route).toLowerCase();
					_routes[page.route] = page.branch;
				}
			}
			children[page.id] = page;
		}
		return children;
	}
	private function parseAssets(nodes:Array, pageDepth:String):Object
	{
		var assets:Object = {};
		for (var i:Number = 0; i < nodes.length; i++) 
		{
			var node:Object = nodes[i];
			assets[node.attributes.id] = AssetCreator.create(node, pageDepth);
		}
		return assets;
	}
	private function getValidRoute(route:String):String
	{
		var s:String;
		var i:Number;
		route = route.split(" ").join("-");
		route = route.split(".").join("-");
		i = 44;
		while (i-- > 33)
		{
			s = String.fromCharCode(i);
			route = route.split(s).join("-");
		}
		i = 64;
		while (i-- > 58)
		{
			s = String.fromCharCode(i);
			route = route.split(s).join("-");
		}
		route = route.split("`").join("");
		i = 94;
		while (i-- > 91)
		{
			s = String.fromCharCode(i);
			route = route.split(s).join("");
		}
		i = 127;
		while (i-- > 123)
		{
			s = String.fromCharCode(i);
			route = route.split(s).join("");
		}
		return route;
	}
}