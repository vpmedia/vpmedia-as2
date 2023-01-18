/**
 * StageUtil
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
 * Project: StageUtil
 * File: StageUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
import com.vpmedia.core.IFramework;
// Start
class com.vpmedia.utils.StageUtil extends MovieClip implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "StageUtil";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// constructor
	function StageUtil ()
	{
		EventDispatcher.initialize (this);
	}
	/**
	 * <p>Description: Position on Stage</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function centerOnStage (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.centerOnStageX (__mc);
		com.vpmedia.utils.StageUtil.centerOnStageY (__mc);
	}
	public static function centerOnStageX (__mc:MovieClip):Void
	{
		__mc._x = int ((Stage.width / 2) - (__mc._width / 2));
	}
	public static function centerOnStageY (__mc:MovieClip):Void
	{
		__mc._y = int ((Stage.height / 2) - (__mc._height / 2));
	}
	public static function L_OnStage (__mc:MovieClip):Void
	{
		__mc._x = 10;
	}
	public static function R_OnStage (__mc:MovieClip):Void
	{
		__mc._x = Stage.width - __mc._width;
	}
	public static function T_OnStage (__mc:MovieClip):Void
	{
		__mc._y = 10;
	}
	public static function B_OnStage (__mc:MovieClip):Void
	{
		__mc._y = Stage.height - __mc._height;
	}
	public static function LB_OnStage (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.L_OnStage (__mc);
		com.vpmedia.utils.StageUtil.B_OnStage (__mc);
	}
	public static function RB_OnStage (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.R_OnStage (__mc);
		com.vpmedia.utils.StageUtil.B_OnStage (__mc);
	}
	public static function TL_OnStage (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.T_OnStage (__mc);
		com.vpmedia.utils.StageUtil.L_OnStage (__mc);
	}
	public static function TR_OnStage (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.T_OnStage (__mc);
		com.vpmedia.utils.StageUtil.R_OnStage (__mc);
	}
	public static function setStageWidth (__mc:MovieClip):Void
	{
		__mc._width = Stage.width;
	}
	public static function setStageHeight (__mc:MovieClip):Void
	{
		__mc._height = Stage.height;
	}
	public static function setStageSize (__mc:MovieClip):Void
	{
		com.vpmedia.utils.StageUtil.setStageWidth (__mc);
		com.vpmedia.utils.StageUtil.setStageHeight (__mc);
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
