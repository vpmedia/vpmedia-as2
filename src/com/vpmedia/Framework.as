/**
 * VPmedia Application Framework (VAF)
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
 * Project: VAF
 * File: Framework.as
 * Created by: András Csizmadia
 *
 */
// event delegate import
import com.vpmedia.core.IFramework;
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
//
class com.vpmedia.Framework extends MovieClip implements IFramework {
	// START CLASS
	function Framework () {
		AsBroadcaster.initialize (this);
		EventDispatcher.initialize (this);
		// generic onStatus
	}
	// class
	public var className:String = "Framework";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// definition
	public var error:Object;
	public var debugMode:Boolean;
	public var serverMode:Boolean;
	public var isCompatible:Boolean;
	public var runPath:String;
	public var runProtocol:String;
	public var projectVersion:Number;
	public var playerVersion:String;
	public var playerType:String;
	public var minorVersion:Number;
	public var majorVersion:Number;
	public var osType:String;
	public var startTime:Number;
	public var isReadCookies:Boolean;
	public var appName:String;
	public var xres:Number;
	public var yres:Number;
	//
	public var cfg:LoadVars;
	public var $version:Number;
	// AsBroadcaster
	public var addListener:Function;
	public var removeListener:Function;
	public var broadcastMessage:Function;
	// EventDispatcher
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	/**
	 * <p>Description: Start framework</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function start () {
		this.debugMode = false;
		var tmp_date:Date = new Date ();
		this.startTime = tmp_date.getTime ();
		this.setEnvironment ();
		this.isCompatible = this.getVersionCompatible ();
		this.getRunLocation ();
		this.setAppName ();
		this.setConfigLoader ();
		// message/level
		this.error = new Object ();
		_root._focusrect = false;
		this.dispatchEvent ({type:"onInit", target:this});
	}
	/**
	 * <p>Description: Get running time</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getAppTime ():Number {
		//trace ("%%" + "getAppTime" + "%%");
		var tmp_date:Date = new Date ();
		var __appTime = Number (tmp_date.getTime () - this.startTime);
		return __appTime;
	}
	/**
	 * <p>Description: Check Run Location</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getRunLocation ():String {
		//trace ("%%" + "getRunLocation" + "%%");
		var __val:String;
		var __p:String;
		var __s:Boolean;
		if (_root._url.split ('file:///')[0] == "") {
			__val = "Application running on a file system";
			__p = "file";
			__s = false;
		}
		else if (_root._url.split ('http://')[0] == "") {
			__val = "Application running on over HTTP";
			__p = "http";
			__s = true;
		}
		else if (_root._url.split ('https://')[0] == "") {
			__val = "Application running on over HTTPS";
			__p = "https";
			__s = true;
		}
		this.runProtocol = __p;
		this.serverMode = __s;
		this.runPath = _root._url.substring (0, _root._url.lastIndexOf ("/"));
		//
		return __val;
	}
	public function getFileSeparator ():String {
		var os:String = System.capabilities.os;
		if (os.indexOf ("Win") > -1) {
			return "\\";
		}
		else if (os.indexOf ("Mac") > -1) {
			return ":";
		}
		else if (os.indexOf ("Linux") > -1) {
			return "/";
		}
	}
	/**
	 * <p>Description: AntiCache</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getAntiCache ():String {
		//trace ("%%" + "getAntiCache" + "%%");
		var tmp_date:Date = new Date ();
		var __antiCacheStr = "&flash_anti_cache=" + tmp_date.getTime ();
		return __antiCacheStr;
	}
	/**
	 * <p>Description: Set FrameWork error</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function setError (__message, __level) {
		this.error.message = __message;
		this.error.level = __level;
		this.dispatchEvent ({type:"onError", target:this, message:__message, level:__level});
		//return;
	}
	/**
	 * <p>Description: Set FrameWork name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function setAppName ():Void {
		var s = com.vpmedia.CustomString.replace ("\\", "/", _level0._url);
		var tmp = s.split ("/");
		tmp.length <= 1 ? tmp = _root._url.split ("\\") : "";
		var tmp_name = tmp[tmp.length - 1];
		var tmpPosEnd = tmp_name.lastIndexOf (".");
		var __name = tmp_name.substr (0, tmpPosEnd);
		this.appName = __name;
	}
	/**
	 * <p>Description: Set FrameWork enviroment</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function setEnvironment ():Void {
		this.projectVersion = _root.getSWFVersion ();
		this.playerType = System.capabilities.playerType;
		this.osType = getVersion ().split (" ")[0];
		this.playerVersion = getVersion ();
		this.minorVersion = Number (getVersion ().split (",")[2]);
		this.majorVersion = Number (getVersion ().split (" ")[1].substr (0, 1));
		this.isReadCookies = !System.capabilities.localFileReadDisable;
		this.xres = System.capabilities.screenResolutionX;
		this.yres = System.capabilities.screenResolutionY;
	}
	/**
	 * <p>Description: SWF vs. Player compatible check</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function getVersionCompatible ():Boolean {
		//trace ("%%" + "getVersionCompatible" + "%%");
		var __str = $version;
		var __tmpstr = __str.substr (4, 1);
		var __isCompatible:Boolean = true;
		if (__tmpstr <= 5) {
			__isCompatible = false;
		}
		else {
			__str = this.playerVersion.split (",")[0];
			if (this.projectVersion > __str.substr (__str.length - 1, __str.length)) {
				__isCompatible = false;
			}
		}
		return __isCompatible;
	}
	/**
	 * <p>Description: Detect Flash</p>
	 *
	 * @author Macromedia
	 * @version 1.0
	 */
	private function getPlayerVersion ():Void {
		//trace ("%%" + "detectVersion" + "%%");
		var playerVersion = eval ("$version");
		var myLength:Number = playerVersion.length;
		var i:Number = 0;
		while (i <= myLength) {
			i = i + 1;
			var temp = playerVersion.substr (i, 1);
			if (temp == " ") {
				var platform = playerVersion.substr (1, i - 1);
				var majorVersion = playerVersion.substr (i + 1, 1);
				var secondHalf = playerVersion.substr (i + 1, myLength - i);
				var minorVersion = secondHalf.substr (5, 2);
			}
		}
	}
	/**
	 * <p>Description: Config loadVars</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function loadConfig (__url):Void {
		this.cfg.load (__url);
	}
	private function setConfigLoader ():Void {
		this.cfg = new LoadVars ();
		//this.cfg.onLoad = this.configLoaded;
		this.cfg.onLoad = Delegate.create (this, this.onConfigLoaded);
		this.cfg.onHTTPStatus = Delegate.create (this, this.onConfigHttpStatus);
	}
	private function onConfigLoaded (success):Void {
		for (var name in this['cfg']) {
			if (escape (name) != "%0D%0A") {
				if (typeof (this['cfg'][name]) != "function") {
					_global[name] = unescape (this['cfg'][name]);
					//trace ("--config global -> '" + name + "'='" + unescape (this['cfg'][name]) + "'");
				}
			}
		}
		delete (this);
		// parsed
		this.dispatchEvent ({type:"onConfigLoad", target:this});
	}
	private function onConfigHttpStatus (_httpStatus:Number):Void {
		var httpStatus = _httpStatus;
		if (httpStatus < 100) {
			var httpStatusType = "flashError";
		}
		else if (httpStatus < 200) {
			var httpStatusType = "informational";
		}
		else if (httpStatus < 300) {
			var httpStatusType = "successful";
		}
		else if (httpStatus < 400) {
			var httpStatusType = "redirection";
		}
		else if (httpStatus < 500) {
			var httpStatusType = "clientError";
		}
		else if (httpStatus < 600) {
			var httpStatusType = "serverError";
		}
	}
	/**
	 * <p>Description: Get method list</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getMethodList ():Void {
		trace ("** " + this.version + " **");
		trace ("*  -> start()");
		trace ("*  -> getProperties()");
		trace ("*  -> showProperties()");
		trace ("*  -> getVersion()");
		trace ("*  -> getAppTime()");
		trace ("*  -> getVersionCompatible ()");
		trace ("*  -> getPlayerVersion ()");
		trace ("*  -> getRunLocation ()");
		trace ("*  -> getAntiCache ()");
		trace ("*  -> setDefaultStage ()");
		trace ("*  ->> onInit ()");
		trace ("*  ->> onConfigLoad ()");
		trace ("*  ->> onError ()");
	}
	/**
	 * <p>Description: Get version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String {
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Show and Get settings</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function showProperties ():Void {
		//trace ("%%" + "showProperties" + "%%");
		// show
		var __o = this.getProperties ();
		for (var i in __o) {
			trace ("--" + i + ": " + [__o[i]]);
		}
	}
	public function getProperties ():Object {
		//trace ("%%" + "getProperties" + "%%");
		// show
		var __o = new Object ();
		__o.serverMode = this.serverMode;
		__o.debugMode = this.debugMode;
		__o.xres = this.xres;
		__o.yres = this.yres;
		__o.osType = this.osType;
		__o.screenRes = this.xres + "x" + this.yres;
		__o.playerType = this.playerType;
		__o.playerVersion = this.playerVersion;
		__o.majorVersion = this.majorVersion;
		__o.minorVersion = this.minorVersion;
		__o.projectVersion = this.projectVersion;
		__o.runPath = this.runPath;
		__o.runProtocol = this.runProtocol;
		__o.isCompatible = this.isCompatible;
		__o.isReadCookies = this.isReadCookies;
		__o.appTime = this.getAppTime ();
		__o.appName = this.appName;
		return __o;
	}
	//END CLASS
}
