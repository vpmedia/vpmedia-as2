/**
 * DomainUtil
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
 * Project: DomainUtil
 * File: DomainUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.DomainUtil extends MovieClip implements IFramework {
	// START CLASS
	public var className:String = "DomainUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//Information Codes 
	public var DomainCode_arr = new Array ();
	function DomainUtil () {
	}
	public static function getProtocolFromURL (basePath:String) {
		!basePath ? basePath = _root._url : "";
		var allowDom:String = basePath.substring (0, basePath.indexOf ("/", 7));
		if (basePath.toUpperCase ().indexOf ("HTTP://") > -1) {
			var res = "http";
		}
		else if (basePath.toUpperCase ().indexOf ("HTTPS://") > -1) {
			var res = "https";
		}
		else {
			var res = "file";
		}
		return res;
	}
	public static function getSubDomainFromURL (basePath:String) {
		!basePath ? basePath = _root._url : "";
		var allowDom:String = basePath.substring (0, basePath.indexOf ("/", 7));
		if (basePath.toUpperCase ().indexOf ("HTTP://") > -1) {
			var baseDomain = basePath.substring (7).split ("/")[0];
		}
		else {
			var baseDomain = basePath.substring (8).split ("/")[0];
		}
		var baseArray = baseDomain.split (".");
		var l = baseArray.length;
		if (baseDomain.toLowerCase () == "localhost") {
			var res = "localhost";
		}
		else {
			var res = baseArray[l - 3];
		}
		if (!res) {
			res = "www";
		}
		return res;
	}
	public static function getDomainFromURL (basePath:String) {
		!basePath ? basePath = _root._url : "";
		var allowDom:String = basePath.substring (0, basePath.indexOf ("/", 7));
		if (basePath.toUpperCase ().indexOf ("HTTP://") > -1) {
			var baseDomain = basePath.substring (7).split ("/")[0];
		}
		else {
			var baseDomain = basePath.substring (8).split ("/")[0];
		}
		var baseArray = baseDomain.split (".");
		var l = baseArray.length;
		if (baseDomain.toLowerCase () == "localhost") {
			var res = "localhost";
		}
		else {
			var res = baseArray[l - 2] + "." + baseArray[l - 1];
		}
		return res;
	}
	public static function getPathFromURL (basePath:String) {
		!basePath ? basePath = _root._url : "";
		var res = basePath.substring (0, basePath.lastIndexOf ("/")) + "/";
		return res;
	}
	/**
	 * <p>Description: Set secure domain</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function setSecureDomain (basePath:String):Void {
		!basePath ? basePath = _root._url : "";
		var allowDom:String = basePath.substring (0, basePath.indexOf ("/", 7));
		if (basePath.substring (0, 7).toUpperCase () == "HTTP://") {
			System.security.allowDomain (allowDom);
		}
		else {
			System.security.allowInsecureDomain (allowDom);
		}
	}
	/**
	 * <p>Description: Get Class version</p>
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
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String {
		return ("[" + className + "]");
	}
	// END CLASS
}
