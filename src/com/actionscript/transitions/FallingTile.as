/*
created by Satori Canton
(c) 2005 ActionScript.com
*/
import flash.filters.BlurFilter;
import com.actionscript.AScomponent;
class com.actionscript.transitions.FallingTile extends AScomponent {
	
	private var _clipMask:MovieClip;
	private var _g:Number;
	private var _v:Number;
	private var _rv:Number;
	
	function FallingTile() {
		this._clipMask.swapDepths(10);
		this._clipMask.removeMovieClip();
		this.attachMovie("ClipMask", "_clipMask", 10);
		this._g = 8;
		this._v = 0;
		this._rv = 0;
	}
	
	public function setImage(s:String):Void {		
		this._clipMask.setImage(s);
	}
	public function setMaskSize(w:Number, h:Number):Void {
		this._clipMask.createMask(w, h);
	}
	public function setOffset(x:Number, y:Number):Void {
		this._clipMask.setOffset(x, y);
	}
	public function setGravity(n:Number):Void {
		this._g = n;
	}
	public function popAndFall():Void {
		this._rv = Math.random() * 30 - 15;
		this._v = -Math.random() * 25 + 5;
		this.onEnterFrame = function() {
			this.filters = [new BlurFilter(0, this._v, 1)];
			this._y += this._v;
			this._v += this._g;
			this._clipMask._rotation += this._rv;
			this._yscale -= (this._yscale - 40) / 10;
			if(this._y > Stage.height + this._height) {
				this.broadcastEvent("onTileRemoved");
				this.removeMovieClip();
			}
		}
	}
	public function blurAway():Void {
		this.onEnterFrame = function() {
			this._alpha -= this._g;
			if(this._alpha < 0) {
				this.broadcastEvent("onTileRemoved");
				this.removeMovieClip();
			}
		}
	}
	public function fadeAway():Void {
		this.onEnterFrame = function() {
			this._alpha -= this._g;
			var n:Number = (100 - this._alpha)/2;
			this.filters = [new BlurFilter(n, n, 1)];
			if(this._alpha < 0) {
				this.broadcastEvent("onTileRemoved");
				this.removeMovieClip();
			}
		}
	}
	public function zoomAway():Void {
		this.onEnterFrame = function() {
			this._xscale = this._yscale -= this._g;
			if(this._xscale < 0) {
				this.broadcastEvent("onTileRemoved");
				this.removeMovieClip();
			}
		}
	}
}