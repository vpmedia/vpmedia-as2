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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.ClipAsset;
import com.gaiaframework.assets.SoundAsset;
import com.gaiaframework.assets.XMLAsset;
import com.gaiaframework.assets.FLVAsset;

class com.gaiaframework.assets.AssetCreator
{
	public static function create(node:Object, pageDepth:String):AbstractAsset
	{
		var asset:AbstractAsset;
		var ext:String = node.attributes.type.toUpperCase() || String(node.attributes.src.split(".").pop()).toUpperCase();
		if (ext == "SWF" || ext == "JPG" || ext == "JPEG" || ext == "PNG" || ext == "GIF") 
		{
			asset = new ClipAsset();
			var dtu:String = node.attributes.depth.toUpperCase();
			if (dtu == "TOP" || dtu == "BOTTOM" || dtu == "MIDDLE")
			{
				ClipAsset(asset).depth = dtu;
			}
			else 
			{
				ClipAsset(asset).depth = pageDepth;
			}
		}
		else if (ext == "XML")
		{
			asset = new XMLAsset();
		}
		else if (ext == "MP3" || ext == "WAV")
		{
			asset = new SoundAsset();
		}
		else if (ext == "FLV")
		{
			asset = new FLVAsset();
		}
		else
		{
			_global.tt("Unknown Asset Type", ext);
			return null;
		}
		asset.id = node.attributes.id;
		asset.src = node.attributes.src;
		asset.title = node.attributes.title;
		asset.preloadAsset = (node.attributes.preload != "false");
		asset.showPreloader = (node.attributes.showPreloader != "false");
		return asset;
	}
}