/**
 * UserInterfaceManager
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
 * Project: UserInterfaceManager
 * File: UserInterfaceManager.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;
// Define Class
class com.vpmedia.managers.UserInterfaceManager {
	// START CLASS
	public var className:String = "UserInterfaceManager";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// Constructor
	function UserInterfaceManager () {
		EventDispatcher.initialize (this);
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
	 * <p>Description: doTransition</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function doTransition (__target:MovieClip, __type:String, __dir:Number, __ease:String, __dur:Number, __s:Number):Void {
		var transParam:Object = new Object ();
		var tm:TransitionManager = new TransitionManager (__target);
		// direction
		switch (__dir)
		{
		case 1 :
			transParam.direction = Transition.OUT;
			break;
		case 0 :
			transParam.direction = Transition.IN;
			break;
		default :
			transParam.direction = Transition.IN;
		}
		// duration
		if (__dur)
		{
			transParam.duration = __dur;
		}
		else
		{
			transParam.duration = 1;
		}
		// startpoint
		if (__s)
		{
			transParam.startPoint = __s;
		}
		else
		{
			transParam.startPoint = 0;
		}
		// type
		switch (__type)
		{
		case "Iris" :
			transParam.type = Iris;
			transParam.shape = "CIRCLE";
			break;
		case "Wipe" :
			transParam.type = Wipe;
			break;
		case "PixelDissolve" :
			transParam.type = PixelDissolve;
			transParam.xSections = 40;
			transParam.ySections = 40;
			break;
		case "Blinds" :
			transParam.type = Blinds;
			transParam.numStrips = 40;
			break;
		case "Fade" :
			transParam.type = Fade;
			break;
		case "Zoom" :
			transParam.type = Zoom;
			break;
		case "Fly" :
			transParam.type = Fly;
			break;
		case "Photo" :
			transParam.type = Photo;
			break;
		case "Rotate" :
			transParam.type = Rotate;
			break;
		case "Squeeze" :
			transParam.type = Squeeze;
			break;
		default :
			transParam.type = Iris;
			transParam.shape = "CIRCLE";
		}
		switch (__ease)
		{
		case "Strong" :
			transParam.easing = Strong.easeInOut;
			break;
		case "Elastic" :
			transParam.easing = Elastic.easeOut;
			break;
		case "Bounce" :
			transParam.easing = Bounce.easeOut;
			break;
		case "Back" :
			transParam.easing = Back.easeOut;
			break;
		default :
			transParam.easing = Strong.easeInOut;
		}
		// execute the motion
		tm.startTransition (transParam);
	}
	// END CLASS
}
