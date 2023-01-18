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
import com.gaiaframework.assets.AbstractAsset;

// Used by BranchLoader to create an array in order of pages and assets that are part of a particular branch.

class com.gaiaframework.core.BranchIterator
{
	private static var items:Array;
	private static var index:Number;
	
	public static function init(branch:String):Number
	{
		var branchArray:Array = branch.split("/");
		items = [];
		index = -1;
		var page:PageAsset = SiteModel.tree;
		addPage(page);
		for (var i:Number = 1; i < branchArray.length; i++)
		{
			addPage(page = page.children[branchArray[i]]);
		}
		return items.length;
	}
	public static function next():AbstractAsset
	{
		if (++index < items.length) return items[index];
		return null;
	}
	private static function addPage(page:PageAsset):Void
	{
		items.push(page);
		if (page.assets != undefined) 
		{
			for (var a:String in page.assets)
			{
				var asset:AbstractAsset = page.assets[a];
				items.push(asset);
			}
		}
	}
}