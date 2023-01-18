/**
 * CookieUtil
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
 * Project: CookieUtil
 * File: CookieUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.CookieUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "CookieUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	private var name:String;
	private var localObject;
	private var onStatus:Function;
	/**
	* Constructor
	*/
	public function CookieUtil (name:String)
	{
		this.name = name;
		this.localObject = SharedObject.getLocal (this.name);
		this.localObject.onStatus = function ()
		{
			this.onStatus (arguments);
		};
	}
	/**
	* Saves the specified object.
	*/
	public function save (object):Void
	{
		this.localObject.data[this.name] = object;
		this.localObject.flush ();
	}
	/**
	* Loads the specified local object.
	*/
	public function load ()
	{
		this.localObject = SharedObject.getLocal (this.name);
		return this.localObject.data[this.name];
	}
	/**
	* Checks if the specified object exists.
	*/
	public function exists ():Boolean
	{
		if (this.localObject.data[this.name] != undefined)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	/**
	* Removes the object from the local system.
	*/
	public function remove ():Void
	{
		delete this.localObject.data[this.name];
		this.localObject.flush ();
	}
	/**
	* Gets the data from the local object.
	*/
	public function getData ()
	{
		return this.localObject.data[this.name];
	}
	/**
	* Gets the bytesize of the local object.
	*/
	public function getSize ():Number
	{
		return this.localObject.getSize ();
	}
}
