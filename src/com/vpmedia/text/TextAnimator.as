/**
* TEXT ANIMATOR
*/
import com.vpmedia.text.TextScript;
class com.vpmedia.text.TextAnimator {
	/**
	* Variables
	*/
	/**
	* Constructor
	*/
	public function TextAnimator () {
	}
	/**
	 * <p>Description: TEXT EFFECTS</p>
	 *
	 * @author András Csizmadia
	 * @version 2.0
	 */
	public static function doTextEffect (__scope:MovieClip, __text:String, __x:Number, __y:Number, __tf:TextFormat, __d:Number, __w:Number, __h:Number, __e):MovieClip {
		if (!__w) {
			//__w = Stage.width;
		}
		if (!__h) {
			//__h = Stage.height;
		}
		if (!__x) {
			__x = 0;
		}
		if (!__y) {
			__y = 0;
		}
		if (!__d) {
			__d = 0;
		}
		if (!__tf) {
			__tf = new TextFormat ();
			__tf.font = "Arial";
			__tf.bold = true;
			__tf.size = 14;
			__tf.color = 0x000000;
		}
		switch (__e) {
		case "blurIn" :
			return TextScript.blurIn (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "typewriter" :
			return TextScript.typewriter (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "zoomIn" :
			return TextScript.zoomIn (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "zoomOut" :
			return TextScript.zoomOut (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "dropIn" :
			return TextScript.dropIn (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "randomDropIn" :
			return TextScript.randomDropIn (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		case "wave" :
			//return TextScript.createEffect (__scope, __text, __x, __y, __tf, __d, __w, __h, TextAnimator.wave);
			break;
		case "slideIn" :
			//return TextScript.createEffect (__scope, __text, __x, __y, __tf, __d, __w, __h, TextAnimator.slideIn);
			break;
		case "hammerDown" :
			//return TextScript.createEffect (__scope, __text, __x, __y, __tf, __d, __w, __h, TextAnimator.hammerDown);
			break;
		case "rotateBuild" :
			//return TextScript.createEffect (__scope, __text, __x, __y, __tf, __d, __w, __h, TextAnimator.rotateBuild);
			break;
		case "colorShift" :
			//return TextScript.createEffect (__scope, __text, __x, __y, __tf, __d, __w, __h, TextAnimator.colorShift);
			break;
		default :
			return TextScript.randomDropIn (__scope, __text, __x, __y, __tf, __d, __w, __h);
			break;
		}
	}
	/*public static function hammerDown () {
	this._x -= 50;
	this.field._x += 50;
	this.velocity = 0;
	this._rotation = -90;
	this._alpha = 0;
	this.onEnterFrame = function () {
	if (this.frameCount++ > this.delay) {
	this._visible = true;
	this.velocity++;
	this._rotation += this.velocity;
	if (this._alpha < 100) {
	this._alpha += 10;
	}
	if (this._rotation > 0) {
	this._rotation = 0;
	this.velocity = -(this.velocity) * 0.6;
	}
	}
	};
	}
	public static function slideIn () {
	this.xLoc = this._x;
	this._x = -this._width;
	this.onEnterFrame = function () {
	if (this.frameCount++ > this.delay) {
	this.filters = [new BlurFilter (Math.abs ((this._x - this.xLoc) / 5), 0, 1)];
	this._visible = true;
	this._x -= (this._x - this.xLoc) / 5;
	}
	};
	}
	public static function wave () {
	this.targ = this._y;
	this._y = -this._height;
	this.onEnterFrame = function () {
	if (this.frameCount++ > this.delay) {
	this._visible = true;
	this.v = 0;
	this.onEnterFrame = function () {
	this.v += (this.targ - this._y) / 30;
	this.v *= .90;
	this._y += this.v;
	};
	}
	};
	}
	public static function rotateBuild () {
	this._x += this.field._width / 2;
	this._y += this.field._height / 2;
	this.field._x = -this.field._width / 2;
	this.field._y = -this.field._height / 2;
	this.rs = 360;
	this.onEnterFrame = function () {
	if (this.frameCount++ > this.delay) {
	this._visible = true;
	this.rs -= 5;
	if (this.rs <= 0) {
	this.rs = 0;
	delete (this.onEnterFrame);
	}
	this._alpha = 100 - (100 * (this.rs / 360));
	this._xscale = this._yscale = this.rs + 100;
	this._rotation = this.rs;
	}
	};
	}*/
}
