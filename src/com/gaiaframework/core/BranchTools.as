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

import com.gaiaframework.core.SiteModel;
import com.gaiaframework.assets.PageAsset;

class com.gaiaframework.core.BranchTools
{
	public static function getPage(branch:String):PageAsset
	{
		var branchArray:Array = branch.split("/");
		var page:PageAsset = SiteModel.tree;
		for (var i:Number = 1; i < branchArray.length; i++)
		{
			page = page.children[branchArray[i]];
		}
		return page;
	}
	
	// get valid branch returns a branch that is defined in the site.xml
	public static function getValidBranch(branch:String):String
	{
		var branchArray:Array = branch.split("/");
		var page:PageAsset = SiteModel.tree;
		var validBranch:Array = [];
		if (branchArray[0] != "index") branchArray.unshift("index");
		validBranch.push(branchArray[0]);
		for (var i:Number = 1; i < branchArray.length; i++)
		{
			if (page.children[branchArray[i]] != undefined) 
			{
				page = page.children[branchArray[i]];
				validBranch.push(branchArray[i]);
			} 
			else 
			{
				break;
			}
		}
		var returnBranch:String = validBranch.join("/");
		return getDefaultChildBranch(returnBranch);
	}
	public static function getFullBranch(branch:String):String
	{
		var validBranch:String = getValidBranch(branch);
		if (branch.indexOf(validBranch) > -1) return branch;
		return validBranch;
	}
	public static function getPagesOfBranch(branch:String):Array
	{
		var branchArray:Array = branch.split("/");
		var pageArray:Array = [];
		var page:PageAsset = SiteModel.tree;
		pageArray.push(page);
		for (var i:Number = 1; i < branchArray.length; i++)
		{
			pageArray.push(page = page.children[branchArray[i]]);
		}
		return pageArray;
	}
	public static function getValidRoute(route:String):String
	{
		var routeArray:Array = route.split("/");
		var routes:Object = SiteModel.routes;
		for (var a:String in routes)
		{
			if (a == route) return route;
		}
		routeArray.length--;
		if (routeArray.length == 0) return "";
		return getValidRoute(routeArray.join("/"));
	}
	private static function getDefaultChildBranch(branch:String):String
	{
		var page:PageAsset = getPage(branch);
		if (page.defaultChild == undefined) return branch;
		return getDefaultChildBranch(page.children[page.defaultChild].branch);
	}
}