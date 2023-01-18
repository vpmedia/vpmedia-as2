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
import com.gaiaframework.assets.AssetProgress;
import net.stevensacks.utils.CacheBuster;
import net.stevensacks.data.XML2AS;

class com.gaiaframework.assets.XMLAsset extends AbstractAsset
{
	private var _xml:XML;
	private var _obj:Object;
	
	function XMLAsset()
	{
		super();
	}
	public function get xml():XML
	{
		return _xml;
	}
	public function get obj():Object
	{
		if (!_obj) 
		{
			_obj = {};
			XML2AS.parse(xml.firstChild, _obj);
		}
		return _obj;
	}
	public function init():Void
	{
		isActive = true;
		_xml = new XML();
		_xml.ignoreWhite = true;
	}
	public function preload():Void
	{
		_xml.load(CacheBuster.create(src));
		super.load();
	}
	public function load():Void
	{
		if (showPreloader) AssetProgress.instance.load(this);
		preload();
	}
	public function getBytesLoaded():Number
	{
		return _xml.getBytesLoaded();
	}
	public function getBytesTotal():Number
	{
		return _xml.getBytesTotal();
	}
	public function destroy():Void
	{
		delete _xml;
		delete _obj;
		super.destroy();
	}
	public function retry():Void
	{
		_xml.load(CacheBuster.create(src));
	}
}