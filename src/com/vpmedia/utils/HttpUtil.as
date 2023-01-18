/**
 * HttpUtil
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
 * Project: HttpUtil
 * File: HttpUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.HttpUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "HttpUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//Information Codes 
	public var HTTPCode_arr = new Array ();
	function HttpUtil ()
	{
		this.HTTPCode_arr[100] = "Continue";
		this.HTTPCode_arr[101] = "Switching Protocols";
		//Success Codes 
		this.HTTPCode_arr[200] = "OK";
		this.HTTPCode_arr[201] = "Created";
		this.HTTPCode_arr[202] = "Accepted";
		this.HTTPCode_arr[203] = "Non-Authoritative Information";
		this.HTTPCode_arr[204] = "No Content";
		this.HTTPCode_arr[205] = "Reset Content";
		this.HTTPCode_arr[206] = "Partial Content";
		//Redirection Codes 
		this.HTTPCode_arr[300] = "Multiple Choices";
		this.HTTPCode_arr[301] = "Moved Permanently";
		this.HTTPCode_arr[302] = "Found";
		this.HTTPCode_arr[303] = "See Other";
		this.HTTPCode_arr[304] = "Not Modified";
		this.HTTPCode_arr[305] = "Use Proxy";
		this.HTTPCode_arr[307] = "Temporary Redirect";
		//Client Error Codes 
		this.HTTPCode_arr[400] = "Bad Request";
		this.HTTPCode_arr[401] = "Unauthorized";
		this.HTTPCode_arr[402] = "Payment Required";
		this.HTTPCode_arr[403] = "Forbidden";
		this.HTTPCode_arr[404] = "Not Found";
		this.HTTPCode_arr[405] = "Method Not Allowed";
		this.HTTPCode_arr[406] = "Not Acceptable";
		this.HTTPCode_arr[407] = "Proxy Authentication Required";
		this.HTTPCode_arr[408] = "Request Timeout";
		this.HTTPCode_arr[409] = "Conflict";
		this.HTTPCode_arr[410] = "Gone";
		this.HTTPCode_arr[411] = "Length Required";
		this.HTTPCode_arr[412] = "Precondition Failed";
		this.HTTPCode_arr[413] = "Request Entity Too Large";
		this.HTTPCode_arr[414] = "Request-URI Too Large";
		this.HTTPCode_arr[415] = "Unsupported Media Type";
		this.HTTPCode_arr[416] = "Requested Range Not Satisfiable";
		this.HTTPCode_arr[417] = "Expectation Failed";
		//Server Error Codes 
		this.HTTPCode_arr[500] = "Internal Server Error";
		this.HTTPCode_arr[501] = "Not Implemented";
		this.HTTPCode_arr[502] = "Bad Gateway";
		this.HTTPCode_arr[503] = "Service Unavailable";
		this.HTTPCode_arr[504] = "Gateway Timeout";
		this.HTTPCode_arr[505] = "HTTP Version not supported";
	}
	// Get HTTP Error code description.
	public function getCodeName (__id)
	{
		var __name = this.HTTPCode_arr[__id];
		if (__name == undefined)
		{
			__name = "Unknown";
		}
		return __name;
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
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
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
