/**
 * CustomObject
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
 * Project: CustomObject
 * File: CustomObject.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.CustomObject extends Object implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "ClassName";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// constructor
	function CustomObject()
	{
	}
	/**
	 * <p>Description: Trace Object</p>
	 *
	 * @author András Csizmadia
	 * @version 2.0
	 */
	public static function traceObj (debugObject:Object, message:String)
	{
		var msg:String = "";
		msg += "[" + new com.vpmedia.CustomDate().displayCurrentTime () + "][" + message + "]";
		if (!debugObject)
		{
			//debugObject = null;
		}
		if (!message)
		{
			var message = "";
		}
		if (typeof (debugObject) == "object")
		{
			for (var prop in debugObject)
			{
				if (typeof (debugObject[prop]) == "object")
				{
					traceObj (debugObject[prop], prop);
				}
				else
				{
					msg += "\n" + prop + "=" + "" + debugObject[prop];
				}
			}
		}
		else if (debugObject)
		{
			msg += "[" + new com.vpmedia.CustomDate().displayCurrentTime () + "]" + debugObject;
		}
		return msg;
	}
	/**
	 * <p>Description: Object Length,Reverse</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function getObjLength (__obj:Object)
	{
		var __counter:Number = 0;
		for (var i in __obj)
		{
			//trace(i+" : "+__obj[i]);
			__counter++;
		}
		return __counter;
	}
	/**
	 * <p>Description: Reverse Object</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	public static function reverseObject (o:Object):Object
	{
		var a:Array = new Array ();
		var s:Object = new Object ();
		var p:Object = new Object ();
		var r:Object = new Object ();
		for (var n in o)
		{
			a.push (n);
		}
		a.reverse ();
		var i:Number = a.length;
		while (i--)
		{
			p = a[i];
			s = o[p];
			r[p] = s;
		}
		delete o;
		return r;
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
