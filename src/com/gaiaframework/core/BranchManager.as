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

// This class is used by the SiteController to manage the adding and removal of pages of the active branch.

class com.gaiaframework.core.BranchManager
{	
	private static var activePages:Object = {};
	
	public static function loadPage(page:PageAsset):Void
	{
		activePages[page.branch] = page;
	}
	public static function createTransitionOutArray(newBranch:String):Array
	{
		cleanup();
		var transitionOutArray:Array = [];
		for (var a:String in activePages)
		{
			if (newBranch.indexOf(a) == -1) transitionOutArray.push(activePages[a]);
		}
		transitionOutArray.sort(sortByBranchDepth);
		return transitionOutArray;
	}
	public static function cleanup():Void
	{
		for (var a:String in activePages)
		{
			if (!activePages[a].active) delete activePages[a];
		}
	}
	private static function sortByBranchDepth(a, b):Number
	{
		var aLen:Number = a.branch.split("/").length;
		var bLen:Number = b.branch.split("/").length;
		if (aLen < bLen)return -1;
		else if (aLen > bLen) return 1;
		else return 0;
	}
}