/**
 * CustomArray
 * Copyright © 2007 András Csizmadia
 * Copyright © 2007 VPmedia
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
 * Project: CustomArray
 * File: CustomArray.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.SWFAddressCustom extends MovieClip implements IFramework
{
  // START CLASS
	/**
	* <p>Description: Decl.</p>
	*
	* @author András Csizmadia
	* @version 1.0
	*/
	public var className:String = "CustomArray";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// constructor
  function SWFAddressCustom()
  {
  }
  /**
	* <p>Description: String helper</p>
	*
	* @author András Csizmadia
	* @version 1.0
	*/
  public static function replace(str:String, find:String, replace:String):String {
 		return str.split(find).join(replace);
  }
  /**
	* <p>Description: Get index from content array</p>
	*
	* @author András Csizmadia
	* @version 1.0
	*/
  public static function getIndex(arr:Array, obj:Object):Number {
		for (var i = 0; i < arr.length; i++) {
			if (arr[i] == obj) {
				return i;
			}
		}
	}
  /**
	* <p>Description: Formatter helper</p>
	*
	* @author András Csizmadia
	* @version 1.0
	*/
  public static function toTitleCase(str:String):String {
   	return str.substr(0,1).toUpperCase() + str.substr(1).toLowerCase();
  }
  /**
	* <p>Description: Formatter</p>
	*
	* @author András Csizmadia
	* @version 1.0
	*/
  public static function formatTitle(addr:String):String {
   	return '' + ((addr.length > 0) ? ' / ' + toTitleCase(replace(addr.substr(1), '/', ' / ')) : '');
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