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
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.assets.PageAsset;
import flash.external.ExternalInterface;

// This class implements the SWFAddress Class v1.1 written by Rostislav Hristov
// More info: http://www.asual.com/swfaddress/

class com.gaiaframework.core.SWFAddress extends ObservableClass
{
	private static var _deeplink:String = "";	
	private var _value:String = "";	
	private var isInternal:Boolean = false;
	
	private static var _instance:SWFAddress;
	
	private function SWFAddress() 
	{
		super();
	}
	public static function birth():Void
	{
		if (_instance == null) _instance = new SWFAddress();
	}
	public static function get instance():SWFAddress
	{
		return _instance;
	}
	public static function get deeplink():String
	{
		return _deeplink;
	}	
	public function init():Void 
	{
		_value = "";
		ExternalInterface.addCallback("getSWFAddressValue", this, function():String {return this._value});
		ExternalInterface.addCallback("setSWFAddressValue", this, setValue);
		setValue(getValue() || _root.deeplink || _value);
	}
	public function onGoto(evt:Object):Void
	{
		isInternal = true;
		if (!evt.external)
		{
			if (!SiteModel.routing)
			{
				var newBranch:String = evt.fullBranch.split("/").slice(1).join("/");
				setValue(newBranch);
			}
			else
			{
				_deeplink = evt.fullBranch.substring(evt.validBranch.length, evt.fullBranch.length);
				setValue(BranchTools.getPage(evt.validBranch).route + _deeplink);
			}
			setTitle(SiteModel.title.split("%PAGE%").join(BranchTools.getPage(evt.validBranch).title));
		}
	}
	public function getTitle():String
	{
		var title:String = String(ExternalInterface.call("SWFAddress.getTitle")); 
		if (title == "undefined" || title == "null") title = "";
		return title;
	}
	public function setTitle(title:String):Void
	{
		ExternalInterface.call("SWFAddress.setTitle", title);
	}	
	public function getValue():String 
	{
		var addr:String = String(ExternalInterface.call("SWFAddress.getValue"));  
		var id:String = String(ExternalInterface.call("SWFAddress.getId"));
		if (id != "null") 
		{
			 if (addr == "undefined" || addr == "null") addr = "";  
		} 
		else 
		{  
			 addr = _value;  
		}  
		return addr; 
	}	
	public function setValue(addr:String):Void 
	{
		if (addr == "undefined" || addr == "null" || addr == undefined) addr = "";
		if (_value != addr || _value.length == 0) 
		{
			_value = addr;
			dispatchDeeplink();	
			ExternalInterface.call("SWFAddress.setValue", _value);
		}
		if (!isInternal) onChange();
		isInternal = false;
    }
	public function onChange():Void 
	{
		if (_value.length > 0) 
		{
			if (SiteModel.routing) 
			{
				var validRoute:String = validate(_value);
				if (validRoute.length > 0) dispatchEvent({type:"goto", branch:SiteModel.routes[validRoute] + _deeplink});
			}
			else 
			{
				dispatchEvent({type:"goto", branch:_value});
			}
		} 
		else 
		{
			dispatchEvent({type:"goto", branch:"index"});
		}
	}
	private function dispatchDeeplink():Void 
	{
		_deeplink = "";
		var validated:String;
		validated = validate(_value);
		if (validated.length > 0) _deeplink = _value.substring(validated.length, _value.length);
		if (_deeplink.length > 0) _global.tt("deeplink", _deeplink);
		dispatchEvent({type:"deeplink", deeplink:_deeplink});
	}
	private function validate(val:String):String
	{
		if (val.length == 0) return "";
		if (val.charAt(0) == "#") val = val.substr(1);
		if (SiteModel.routing)
		{
			_value = unescape(_value);
			return BranchTools.getValidRoute(val);
		}
		else
		{
			return BranchTools.getFullBranch(val).split("/").slice(1).join("/");
		}
	}
}