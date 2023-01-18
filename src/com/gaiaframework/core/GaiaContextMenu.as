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

import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.core.EventHQ;
import mx.utils.Delegate;

class com.gaiaframework.core.GaiaContextMenu
{
	private static var menu:ContextMenu;
	private static var customItems:Array;
	private static var gotoHash:Object;
	private static var separator:Boolean;
	
	public static function init(enable:Boolean):Void
	{
		menu = new ContextMenu();
		customItems = [];
		if (enable)
		{
			menu.hideBuiltInItems();
			gotoHash = {};
			separator = true;
			//
			var title:String = SiteModel.title.split("%PAGE%").join("").split(SiteModel.delimiter).join("");
			var projectName:ContextMenuItem = new ContextMenuItem(title, GaiaContextMenu.deadClick);
			customItems.push(projectName);
			//
			traverseTree(SiteModel.tree);
		}
		var gaiaLink:ContextMenuItem = new ContextMenuItem("Built with Gaia Framework", GaiaContextMenu.gaiaClick);
		gaiaLink.separatorBefore = true;
		customItems.push(gaiaLink);
		//
		menu.customItems = customItems;
		_root.menu = menu;
	}
	private static function traverseTree(page:PageAsset):Void
	{
		var children:Object = page.children;
		for (var a:String in children)
		{
			var childPage:PageAsset = children[a];
			if (childPage.context && childPage.title.length > 0) addPageToMenu(childPage);
			if (childPage.children) traverseTree(childPage);
		}
	}
	private static function addPageToMenu(page:PageAsset):Void
	{
		gotoHash[page.title] = page.branch;
		var cmi:ContextMenuItem = new ContextMenuItem(page.title);
		cmi.onSelect = Delegate.create(GaiaContextMenu, GaiaContextMenu.goto);
		cmi.separatorBefore = separator;
		separator = false;
		customItems.push(cmi);
	}
	private static function goto(obj:Object, menuItem:ContextMenuItem):Void
	{
		EventHQ.instance.goto(gotoHash[menuItem.caption]);
	}
	private static function gaiaClick():Void
	{
		getURL("http://www.gaiaflashframework.com/", "_blank");
	}
	private static function deadClick():Void {}
}