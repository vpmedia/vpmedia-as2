/**
 * TraceUtil
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
 * Project: TraceUtil
 * File: TraceUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.TraceUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "TraceUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	public var output;
	public var autoscroll:Boolean;
	public var outputType:String;
	public var logger;
	// Constructor 
	function TraceUtil ()
	{
	}
	//textbox,mmcomponent
	/**
	 * <p>Description: Object Dump</p>
	 *
	 * @author András Csizmadia
	 * @version 2.0
	 */
	public function dumpObject (debugObject, message)
	{
		//trace ("--AdvancedTrace dumpObject--");
		if (!message)
		{
			message = "";
		}
		var msg = new Array ();
		if (typeof (debugObject) == "object")
		{
			for (var prop in debugObject)
			{
				if (typeof (debugObject[prop]) == "object")
				{
					dumpObject (debugObject[prop], prop);
				}
				else
				{
					msg.push ("{" + prop + ":'" + debugObject[prop] + "'},");
				}
			}
		}
		else if (debugObject)
		{
			msg.push (debugObject);
		}
		msg.push ("[" + message + "]");
		msg = msg.reverse ();
		//
		for (var j = 0; j < msg.length; j++)
		{
			trace (msg[j]);
			if (this.output)
			{
				//this.output.htmlText += msg;
				this.output.text += msg[j];
			}
		}
		//
		if (this.autoscroll)
		{
			this.output.vPosition = this.output.maxVPosition;
			this.output.redraw ();
		}
		//      
		return msg;
	}
	/**
	 * <p>Description: Clears the output text</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	public function clearOutput ():Void
	{
		this.output.text = "";
	}
	/**
	 * <p>Description: Argument trace</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	public function write (arguments):Void
	{
		// Trace each argument on its own line
		for (var i = 0; i < arguments.length; i++)
		{
			trace (arguments[i]);
		}
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
